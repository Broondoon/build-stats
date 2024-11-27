# Heavily out of date, but general logic is still consistent.
@startuml
actor user as user
boundary Front_End_UI as Front_End_UI
entity Change_Manager as Change_Manager
entity Worksite_Cache as Worksite_Cache
entity Worksite as Worksite
entity Checklist_Cache as Checklist_Cache
entity Checklist as Checklist
entity ChecklistDay as ChecklistDay
entity Item_Cache as Item_Cache
entity Item as Item
control File_IO as File_IO
control Data_Connection as Data_Connection
boundary Server as Server
skin rose
group open worksites list
  user -> Front_End_UI ++: navigates to Worksite list
  Front_End_UI -> Change_Manager ++: GetUserWorksites()
  group GetUserWorksites()
    alt first load
      alt can connect to middle ware
        Change_Manager -> Data_Connection ++: Get all worksites for user
        Data_Connection -> Server ++: Get all Worksites for user
        return all worksites for user
        return all Worksite for user
        opt
          Change_Manager -> File_IO ++: determine if any worksites in saved files are marked for deletion
          return all worksites marked for deletion
          loop for all worksites marked for deletion
            Change_Manager -> Worksite_Cache ++: deleteWorksite(worksite)
            ref over Worksite_Cache, Server : deleteWorksite(Worksite)
            return confirm deletion of worksite
            Change_Manager -> Change_Manager :remove deleted worksite from all worksites for user
          end
      end
      else can't connect to middle ware
        Change_Manager -> Data_Connection ++: Get all worksites for user
        return can't connect to middle ware
        Change_Manager -> File_IO ++: Get all Worksites for user
        return all worksites for user
      end
      loop for all worksites for user
        Change_Manager -> Worksite_Cache : Store worksite in Worksite Cache
      end
    end
  end
  return all Worksites for user
  note over user, Front_End_UI 
    Make sure we have 
    conditions for if 0 worksites returned
  end note
  return displays list of worksites
end

group Add worksites
  ref over user,Server : open worksites list
  user -> Front_End_UI ++: Taps Plus 1 worksite button
  Front_End_UI -> Change_Manager ++: CreateWorksite()
  Change_Manager -> Change_Manager : creates blank worksite with negative ID
  Change_Manager <-> Worksite_Cache : stores blank worksite in cache only
  return blank worksite 
  return displays new worksite
end

group Edit worksite
  ref over user,Server : open worksites list
  user -> Front_End_UI ++: taps edit worksite button
  return display of worksite edit options
  user -> Front_End_UI ++: edit worksite and save changes
  Front_End_UI -> Change_Manager ++ : UpdateWorksite(updated worksite)
  ref over Change_Manager, Server : UpdateWorksite(updated Worksite)
  return updated Worksite
  return updated Worksite
end

group UpdateWorksite(updated Worksite)
  opt can connect to middle ware
    alt Worksite has negative temp ID
      Change_Manager -> Data_Connection ++: Create Worksite
      Data_Connection -> Server ++ : Post Worksite
      return new worksite
      return new worksite
      Change_Manager -> Worksite_Cache ++ : remove worksite with prior temp ID.
      return confirm deletion
      Change_Manager -> File_IO ++: remove worksite with prior temp ID.
      return confirm deletion
      Change_Manager -> Change_Manager : set updated worksite to new worksite
      Change_Manager -> File_IO ++: Save Worksite changes
      return confirm changes
      Change_Manager -> Worksite_Cache  ++: Save Worksite changes
      return confirm changes
    else
      Change_Manager <-> Worksite_Cache : get worksite matching this ID.
      alt updated worksite does not match previous version of worksite
        Change_Manager -> Data_Connection ++: Update Worksite
        Data_Connection -> Server ++: Patch worksite changes
        return updated worksite
        return updated worksite
        Change_Manager -> File_IO ++: Save Worksite changes
        return confirm changes
        Change_Manager -> Worksite_Cache  ++: Save Worksite changes
        return confirm changes
      end
    end
  end
end


group select Worksite
  user -> Front_End_UI ++ : selects Worksite
  Front_End_UI -> Worksite_Cache ++: getWorksiteById(id)
  return worksite
  note over Front_End_UI, Worksite_Cache: Eventually need to add syncing logic incase worksite was changed elsewhere
  ref over user, Server : select Checklist (Dev version. Does not support multiple checklists)
  return display checklistDay for day
end

group select Checklist
  note over Front_End_UI, Change_Manager
    Will eventually need to add a system for selecting Checklist, 
    but in current dev setup, the Worksite.currentChecklist should hold 
    the only checklist available for the Worksite.
  end note
  Front_End_UI -> Change_Manager ++: GetChecklistDayByDate(todays date, Worksite.currentChecklist)
  ref over Change_Manager, Server : GetChecklistDayByDate(todays date, Worksite.currentChecklist)
  return returns checklistDay for day
  group On Exiting checklist
    Critical	
      Front_End_UI -> Change_Manager ++: removeChecklistDay(ID = DefaultBlankChecklistDayID)
      Change_Manager -> Checklist_Cache ++: getChecklistDayByID(ID = DefaultBlankChecklistDayID)
      Ref over Change_Manager, Checklist_Cache: getChecklistDayByID(ID = DefaultBlankChecklistDayID)
	Return checklist day
      ref over Change_Manager, Server : removeChecklistDay(checklist day)
      return validation
    end
  end
end

group GetChecklistDayByDate(date, checklist) returns ChecklistDay
  alt checklist day exists in hashmap
    Change_Manager -> Checklist ++: getChecklistDayID(date) search hashmap for checklist day for key current day
    return true and checklist Day id
  else Checklist day does not exist in hashmap
    alt hashmap has any keys
      Change_Manager -> Checklist ++: getChecklistDayID(date) search hashmap for checklist day for key current day
      Checklist -> Checklist ++ : find nearest prior checklist day id
      note over Change_Manager, Checklist
        in the case that there is no prior checklist day id I.e the new 
        checklist day is before any existing days then we default to the
        nearest next day
      end note 
      opt nearest prior checklist day id != DefaultBlankChecklistDayID
        Checklist -> Checklist : add DefaultBlankChecklistDayID to hashmap with key = to day after nearest prior checklist day (Or before if the noted edge case occurs)
      end
      deactivate Checklist
      return (nearest prior checklist day id == DefaultBlankChecklistDayID)  and nearest prior checklist day id
      opt nearest prior checklist day id != DefaultBlankChecklistDayID
        Change_Manager -> Checklist_Cache ++: getChecklistDayById(prior checklist day id)
        ref over Checklist_Cache,Server : getChecklistDayById(prior checklist day id)
        return prior checklist day
        Change_Manager <-> Checklist_Cache : Store in cache only a copy of prior checklist day, with id = DefaultBlankChecklistDayID
        note over Front_End_UI, Checklist_Cache 
          This will mean that the blank checklist will not have an in built date 
          matching the technically displayed date Ensure user displayed date is 
          not retreived from checklist
        end note
        Change_Manager -> Change_Manager: set returned checklist Day id to DefaultBlankChecklistDayID
      end
    else hashmap has no keys
      Change_Manager -> Checklist ++: getChecklistDayID(date) search hashmap for checklist day for key current day
      Checklist -> Checklist: add DefaultBlankChecklistDayID to hashmap with key = date
      return false and DefaultBlankChecklistDayID
      Change_Manager <-> Checklist_Cache : Store in cache only blank checklist day, with id = DefaultBlankChecklistDayID
      note over Front_End_UI, Checklist_Cache 
        This will mean that the blank checklist will not have an in built date 
        matching the technically displayed date Ensure user displayed date is 
        not retreived from checklist
      end note
    end
  end
  Change_Manager -> Checklist_Cache ++: getChecklistDayById(returned id)
  ref over Checklist_Cache,Server : getChecklistDayById(prior checklist day id)
  return checklist day
end

group getChecklistDayById(id)
  alt checklist day is in cache
    Checklist_Cache -> Checklist_Cache : get checklist day
  else checklist day is not in cache
    alt checklist day is equal to DefaultBlankChecklistDayID
      break
    else
      alt can connect to middle ware
        Checklist_Cache -> Data_Connection ++: Get checklist day
        Data_Connection -> Server ++: Get checklist day
        return checklist day
        return checklist day
        Checklist_Cache -> Checklist_Cache : save checklist day to cache
      else can't connect to middle ware
        Checklist_Cache -> Data_Connection ++: Get checklist day
        return can't connect to middle ware
        Checklist_Cache -> File_IO ++ : Get checklist day
        return checklist day
        Checklist_Cache -> Checklist_Cache : save checklist day to cache
      end
  end
end

group remove Worksite from app
  user -> Front_End_UI ++: deletes Worksite
  opt worksite ID is not a temp ID
    critical
      Front_End_UI -> user : Confirms Deletion of Worksite twice 
      user -> Front_End_UI : user confirms twice
    end
  end
  Front_End_UI -> Change_Manager ++: deleteWorksite(worksite)
  ref over Change_Manager, Server : deleteWorksite(worksite)
  return confirm deletion
  return confirm deletion
end

group deleteWorksite(worksite)
  critical
    alt can connect to middle ware
      Change_Manager -> Data_Connection ++: delete Worksite
      Data_Connection -> Server ++: Delete Worksite 
      note over Change_Manager, Server
        deleting the worksite on the server will also delete all it's checklists, 
        checklist days, and items at the same time
      end note
      return confirm deletion of Worksite
      return confirm deletion of Worksite
      Change_Manager -> File_IO ++: delete worksite.
      note over Change_Manager, File_IO
        deleting the worksite on the File_IO will also delete all it's checklists, 
        checklist days, and items at the same time
      end note
      return confirm deletion of Worksite
    else can't connect to middle ware
      Change_Manager -> Data_Connection ++: delete Worksite
      return can't connect to server
      Change_Manager -> File_IO ++: Flag worksite for deletion when sync is available.
      return worksite flagged for deletion when sync is available.
    end
    loop for all checklists in worksite
      Change_Manager -> Checklist_Cache ++: getChecklistById(checklist ID)
      return checklist to delete
      Change_Manager -> Change_Manager ++ : removeChecklist(Checklist)
      ref over Change_Manager, Item_Cache : removeChecklist(Checklist)
      return confirm deletion of checklist
    end
    Change_Manager -> Worksite_Cache ++: remove worksite from Worksite_Cache
    return confirm deletion or flag for deletion
  end
end


group remove Checklist from app
  user -> Front_End_UI ++: deletes checklist
  opt checklist ID is not a temp ID
    critical
      Front_End_UI -> user : Confirms Deletion of checklist twice 
      user -> Front_End_UI : user confirms twice
    end
  end
  Front_End_UI -> Change_Manager ++: deleteChecklist(checklist)
  ref over Change_Manager, Server : deleteChecklist(checklist)
  return confirm deletion
  return confirm deletion
end

group deleteChecklist(checklist)
  critical
    alt can connect to middle ware
      Change_Manager -> Data_Connection ++: delete checklist
      Data_Connection -> Server ++: Delete checklist 
      note over Change_Manager, Server
        deleting the worksite on the server will also delete all its checklists 
        checklist days and items at the same time
      end note
      return confirm deletion of checklist
      return confirm deletion of checklist
      Change_Manager -> File_IO ++: delete checklist.
      note over Change_Manager, File_IO
        deleting the checklist on the File_IO will also delete all its 
        checklist days and items at the same time
      end note
      return confirm deletion of checklist
    else can't connect to middle ware
      Change_Manager -> Data_Connection ++: delete checklist
      return can't connect to server
      Change_Manager -> File_IO ++: Flag checklist for deletion when sync is available.
      return checklist flagged for deletion when sync is available.
    end
    Change_Manager -> Worksite_Cache ++: getWorskiteById(checklist.worksiteId)
    return worksite for checklist
    Change_Manager -> Change_Manager ++ : Remove checklist from worksite checklist checklist
    Change_Manager ->  Change_Manager : UpdateWorksite(updated worksite)
    ref over Change_Manager, Server : UpdateWorksite(Updated worksite)
    return
    Change_Manager -> Change_Manager ++ : removeChecklist(checklist)
    ref over Change_Manager, Item_Cache : removeChecklist(checklist)
    return confirm deletion
  end
end

group removeChecklist(checklist)
  loop for all checklists days in checklist
    Change_Manager -> Checklist_Cache ++: getChecklistDayById(checklist day ID)
    return checklist day
    Change_Manager -> Change_Manager ++ : removeChecklistDay(Checklist, checklistday)
    ref over Change_Manager, Item_Cache : removeChecklistDay(Checklist, checklistDay)
    return confirm deletion of checklist
  end
  note over Change_Manager, Checklist_Cache
        currently not a thing since we dont actually store checklists yet except on the worksite
  end note
  Change_Manager -> Checklist_Cache ++: remove checklist from Checklist_Cache 
  return confirm deletion or flag for deletion
end

group removeChecklistDay(checklist, checklist day )
  loop for all items in checklist day
      Change_Manager -> Item_Cache ++: getItemById(Item ID)
      return Item
      Change_Manager -> Change_Manager ++ : removeItem(Item)
      ref over Change_Manager, Item_Cache : removeItem(Item)
      return confirm deletion of item
    end
    Change_Manager -> Change_Manager ++: delete checklist day from hashmap
    return checklist day removed from checklist
    Change_Manager -> Checklist_Cache ++: remove checklist day from Checklist_Cache (we dont remove from File_IO since we should never actually be deleting checklist days individually unless theyre temps)
    return confirm deletion or flag for deletion
end

group delete item from app
  alt checklist day id != item.checklistDayId and checklist value is not blank
    user -> Front_End_UI ++: deletes item
    return cannot delete item in use on previous days.
  else
    user -> Front_End_UI ++: deletes item
    opt item value is not blank
      critical
        Front_End_UI -> user : Confirms Deletion of item twice 
        user -> Front_End_UI : user confirms twice
      end
    end
    Front_End_UI -> Change_Manager ++: deleteItem(item)
    ref over Change_Manager, Server : deleteItem(item)
    return confirm deletion
    return confirm deletion
  end
end

group deleteItem(checklist day id, item)
  critical
    alt can connect to middle ware
      Change_Manager -> Data_Connection ++: delete item
      Data_Connection -> Server ++: Delete item 
      return confirm deletion of item
      return confirm deletion of item
      Change_Manager -> File_IO ++: delete item.
      return confirm deletion of item
    else can't connect to middle ware
      Change_Manager -> Data_Connection ++: delete item
      return can't connect to server
      Change_Manager -> File_IO ++: Flag item for deletion when sync is available.
      return item flagged for deletion when sync is available.
    end
    Change_Manager -> Checklist_Cache ++: GetChecklistDayByDate(item.checklistDayId)
    return checklist day for checklist
    Change_Manager -> Change_Manager ++ : Remove item from  checklist day
    Change_Manager ->  Change_Manager : UpdateChecklistDay(updated checklist day)
    ref over Change_Manager, Server : UpdateChecklistDay(Updated checklist day)
    return
    Change_Manager -> Change_Manager ++ : removeItem(item)
    ref over Change_Manager, Item_Cache : removeItem(item)
    return confirm deletion
  end
end

group removeItem(item)
  Change_Manager -> Item_Cache ++: remove item from Item_Cache
  return confirm deletion
end

group select checklist day
  user -> Front_End_UI ++: User clicks next day button.
  Front_End_UI -> Change_Manager ++: GetChecklistDayByDate(next/previous day, checklist)
  ref over Change_Manager, Server : GetChecklistDayByDate(next/previous day, checklist)
  return next checklist day
  return display checklist day
end

note over Change_Manager, Server
  Theres a logical flaw with the update setup in that it only updates going back 
  up the chain. Can likely fix this with a ValueNotifier class on temp set IDs to 
  trigger a proper change. Will revist when implementing. We probably actually are 
  okay with this not being a two way street except for IDs to prevent saving
  entites that are still correctly in temp states
  actually should see how much of this we can alter with ValueNotifiers
end note
group edit checklist day
  user -> Front_End_UI ++: taps edit checklist day button
  Front_End_UI -> user : displays checklist day edit options
  user -> Front_End_UI : edit checklist day and save changes
  Front_End_UI -> Change_Manager ++ : UpdateChecklistDay(UpdatedChecklist)
  ref over Change_Manager, Server : UpdateChecklistDay(UpdateChecklist)
  return Updated Checklist day
  return Updated Checklist day
end

group UpdateChecklist(updated checklist)
  opt can connect to middle ware
    alt Checklist has negative temp ID
      Change_Manager -> Worksite_Cache ++: getWorksitebyId(checklist.worksiteId)
      return worksite
      opt checklist.worksiteId is a temp Id
        note over Change_Manager, Worksite_Cache: Ensure worksite is created
        Change_Manager -> Change_Manager ++: updateWorksite(original Worksite)
        ref over Change_Manager, Server: updateWorksite(original Worksite)
        return updated worksite if created
        Change_Manager -> Change_Manager : update checklist worksite id to worksite Id
        Change_Manager -> Change_Manager : set worksite to be the updated worksite
      end
      Change_Manager -> Data_Connection ++: Create checklist
      Data_Connection -> Server ++ : Post checklist
      return new checklist
      return new checklist
      Change_Manager -> Checklist_Cache ++: remove checklist with prior temp ID.
      return confirm deletion
      Change_Manager -> File_IO ++: remove checklist with prior temp ID.
      return confirm deletion
      Change_Manager -> Change_Manager : set updated checklist to new checklist
      Change_Manager -> File_IO ++: update checklist in file
      return confirm update
      Change_Manager <-> Worksite : add checklist to worksite list of checklist ids
      ref over Change_Manager, Server: updateWorksite(worksite)
      Change_Manager -> Checklist_Cache ++: update checklist in cache
      return updated Checklist
    else
      Change_Manager <-> Checklist_Cache : get checklist matching this ID.
      opt updated checklist does not match previous version of checklist
        Change_Manager -> Data_Connection ++: Update checklist
        Data_Connection -> Server ++: Patch checklist changes
        return edited checklist
        return edited checklist
        Change_Manager -> File_IO ++: update checklist in file
        return confirm changes
        Change_Manager -> Checklist_Cache ++: update checklist in cache
        return updated checklist
      end
    end
  end
end

group UpdateChecklistDay(Updated ChecklistDay, Date)
 opt can connect to middle ware
    alt Checklist has negative temp ID
      opt Updated ChecklistDay.date does not equal Date
        Change_Manager -> ChecklistDay ++: Update date to equal given date
        return
      end
      Change_Manager -> Checklist_Cache ++: getChecklistbyId(updated checklistDay.checklistId)
      return checklist
      opt checklistDay.checklistId is a temp Id
        note over Change_Manager, Checklist_Cache: Ensure checklist is created
        Change_Manager -> Change_Manager ++: updateChecklist(original checklist)
        ref over Change_Manager, Server: updateChecklist(original checklist)
        return updated checklist if created
        Change_Manager -> Change_Manager : update checklist.checklistId to updated Id
        Change_Manager -> Change_Manager : set checklist to be the updated checklist
      end
      Change_Manager -> Data_Connection ++: Create checklistDay
      Data_Connection -> Server ++ : Post checklistDay
      return new checklistDay
      return new checklistDay
      Change_Manager -> Checklist_Cache ++: remove checklistDay with prior temp ID.
      return confirm deletion
      Change_Manager -> File_IO ++: remove checklistDay with prior temp ID.
      return confirm deletion
      Change_Manager -> Change_Manager : set updated checklistDay to new checklistDay
      Change_Manager -> File_IO ++: update checklistDay in file
      return confirm update
      Change_Manager <-> Checklist : add checklistId to hashmap list of checklistDay ids
      ref over Change_Manager, Server: updateChecklist(checklist)
      Change_Manager -> Checklist_Cache ++: update checklistDay in cache
      return updated checklistDay
    else
      Change_Manager <-> Checklist_Cache : get checklistDay matching this ID.
      opt updated checklistDay does not match previous version of checklist
        Change_Manager -> Data_Connection ++: Update checklistDay
        Data_Connection -> Server ++: Patch checklistDay changes
        return edited checklistDay
        return edited checklistDay
        Change_Manager -> File_IO ++: update checklistDay in file
        return confirm changes
        Change_Manager -> Checklist_Cache ++: update checklistDay in cache
        return updated checklistDay
      end
    end
  end
end

group edit item
  user -> Front_End_UI ++: taps edit item button
  Front_End_UI -> user : displays item edit options
  user -> Front_End_UI : edit item details and save changes
  Front_End_UI -> Change_Manager ++ : UpdateItem(updated Item, ChecklistDay)
  ref over Change_Manager, Server : UpdateItem(Updated Item, ChecklistDay)
  return Updated Item
  return display Item
end

group add item
  user -> Front_End_UI ++: Taps Plus 1 item to category button
  Front_End_UI -> Change_Manager ++: CreateItem()
  ref over Change_Manager, Item_Cache : CreateItem()
  Change_Manager -> Item_Cache ++: stores blank item in cache only
  return added item
  Change_Manager -> ChecklistDay ++: add item to checklist day category hashmap for given category
  return
  return new Item
  return displays new item
end

group CreateItem(otpional (checklistDay, optional item to copy))
  alt tuple is empty
    Change_Manager -> Change_Manager++: creates blank item with temp ID
    return new item
  else
    Change_Manager -> Change_Manager++: create copy of optional item to copy with checklistDayId set to id of checklistday and temp ID
    return new item
  end
end


group UpdateItem(updated Item, checklistDay, Date)
  Change_Manager <-> checklistDay : get catagory of Item
 opt  item checklistDayId does not match checklistDay id 
    Change_Manager -> Change_Manager ++: CreateItem((checklistDay, item))
    ref over Change_Manager,Change_Manager : CreateItem((checklistDay, item))
    Change_Manager -> ChecklistDay : replace prior item in hashmap list with newly created item
    return set updated Item to new item
 end
 opt can connect to middle ware
    alt Item has negative temp ID 
      alt  units and description are not null 
        opt  checklistDayId is a temp Id 
          note over Change_Manager, Checklist_Cache: Ensure checklistDay is created
          Change_Manager -> Change_Manager ++: updateChecklistday(checklistDay, Date)
          ref over Change_Manager, Server: updateChecklistday(checklistDay, Date)
          return updated checklistDay if created
          Change_Manager -> Change_Manager : update item checklistDay id to checklistDay Id
          Change_Manager -> Change_Manager : set checklistDay to be the updated checklistDay
        end
        Change_Manager -> Data_Connection ++: Create Item
        Data_Connection -> Server ++ : Post Item
        return new Item
        return new Item
        Change_Manager -> Item_Cache ++: remove Item with prior temp ID if we didn't just create the item.
        return confirm deletion
        Change_Manager -> File_IO ++: remove Item with prior temp ID if we didn't just create the item.
        return confirm deletion
        Change_Manager -> Change_Manager : set updated Item to new Item
        Change_Manager -> File_IO ++: update Item in file
        return confirm update
        Change_Manager <-> ChecklistDay : add Item id to checksiteDay list of Item ids for catagory
        ref over Change_Manager, Server: updateChecklistday(ChecklistDay)
      else
        Change_Manager <-> ChecklistDay : add Item id to checksiteDay list of Item ids for catagory
        Change_Manager -> Checklist_Cache : store ChecklistDay in cache only
      end
      Change_Manager -> Item_Cache ++: update Item in cache
      return updated Item
    else
      Change_Manager <-> Item : get Item matching this ID.
      alt updated Item does not match previous version of Item
        Change_Manager -> Data_Connection ++: Update Item
        Data_Connection -> Server ++: Patch Item changes
        return edited Item
        return edited item
        Change_Manager -> File_IO ++: update Item in file
        return confirm changes
        Change_Manager -> Item_Cache ++: update Item in cache
        return updated Item
      end
    end
  end
end



group edit checklist day
  user -> Front_End_UI ++: taps edit checklist day button
  Front_End_UI -> user : displays checklist day edit options
  user -> Front_End_UI : edit checklist day and save changes
  Front_End_UI -> Change_Manager ++ : UpdateChecklistDay(UpdatedChecklistDay)
  ref over Change_Manager, Server : UpdateChecklistDay(UpdateChecklistDay)
  return Updated Checklist day
  return display Checklist day
end

group add Category
  user -> Front_End_UI ++: taps add catagory button
  Front_End_UI -> Change_Manager ++ : addCategory(checklistDay, category name)
  Change_Manager -> ChecklistDay ++: addCategory(category name)
  ChecklistDay -> ChecklistDay: add new key to catagory hasmap with empty list of items.
  return confirm addition
  Change_Manager -> Checklist_Cache ++: update checklistDay in Cache
  return updated ChecklistDay
  return updated ChecklistDay
  return display ChecklistDay
end

group edit Category
  user -> Front_End_UI ++: taps edit catagory button
  Front_End_UI -> Change_Manager ++ : editCategory(checklistDay, category name, old category name)
  Change_Manager -> ChecklistDay ++ : editCategory(category name, old category name)
  ChecklistDay -> ChecklistDay: get current catagory item list. create new key value pair in category hashmap with the new category name, delete the old pair.
  return confirm change
  alt category has no items
    Change_Manager -> Checklist_Cache ++: update checklistDay in Cache
    return updated ChecklistDay
  else category has items
    Change_Manager -> Change_Manager ++: UpdateChecklistDay(checklistDay)
    ref over Change_Manager, Server : UpdateChecklistDay(checklistDay)
    return updated checklistDay
  end
  return Updated ChecklistDay
  return display ChecklistDay
end

group delete Category
  alt category has items
    user -> Front_End_UI ++: taps delete catagory button
    Front_End_UI -> Change_Manager ++ : deleteCategory(checklistDay, category name)
    Change_Manager -> ChecklistDay ++ : deleteCategory(category name)
    return cant delete due to existing items
    return cant delete due to existing items
    return cant delete due to existing items
  else
    user -> Front_End_UI ++: taps delete catagory button
    Front_End_UI -> Change_Manager ++ : deleteCategory(checklistDay, category name)
    Change_Manager -> ChecklistDay ++ : deleteCategory(category name)
    ChecklistDay -> ChecklistDay : remove key from category hashmap
    return confirm delete
    alt checklistDay has temp ID
      Change_Manager -> Checklist_Cache ++: update checklistDay in Cache
      return updated ChecklistDay
    else ChecklistDay is a database checklistDay
      Change_Manager -> Change_Manager ++: UpdateChecklistDay(checklistDay)
      ref over Change_Manager, Server : UpdateChecklistDay(checklistDay)
      return updated checklistDay
    end
    return Updated ChecklistDay
    return display ChecklistDay
  end
End

group data sync
  note over Front_End_UI, Server
    Likely going to add valueNotifiers to all add to cache calls for non temp ids
    or perhaps on the properties themselvse. then we have a class that stores a hashset
    of ids and thier checksums
    then on a timer we ping the server to send our current checksums
    the server returns a a list of ids for all the checksums that differ
    we then flag those ids that there are potential updates that need to be rectified.
    when they are next accessed from the cache, we get them from the server and 
    rectfy any conflicts
    Need to look into this more when we have a functioning setup though.
  end note
end

@enduml


