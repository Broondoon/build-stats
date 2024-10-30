//Save File Paths
String Dir_DataDirectoryPath =
    "lib\\model\\storage\\local_storage\\test_storage";
String Dir_ItemFileString = Dir_DataDirectoryPath + "\\items.json";
String Dir_ChecklistFileString = Dir_DataDirectoryPath + "\\checklists.json";
String Dir_ChecklistDayFileString =
    Dir_DataDirectoryPath + "\\checklistDays.json";
String Dir_WorksiteFileString = Dir_DataDirectoryPath + "\\worksites.json";

//API Path Strings
String API_Path = "http://localhost:3000/api";
String API_WorksitePath = API_Path + "/worksite";
String API_ChecklistPath = API_Path + "/checklist";
String API_ChecklistDayPath = API_Path + "/checklistDay";
String API_ItemPath = API_Path + "/item";
String API_WorksiteUserVisiblePath = API_WorksitePath + "/userWorksites";

//API DataOject Strings
String API_DataObject_WorksiteStateList = "worksiteStates";
String API_DataObject_ChecklistStateList = "checklistStates";
String API_DataObject_ChecklistDayStateList = "checklistDayStates";
String API_DataObject_ItemStateList = "itemStates";

//ID Markers
String ID_TempIDPrefix = "temp_";
String ID_WorksitePrefix = "worksite_";
String ID_ChecklistPrefix = "checklist_";
String ID_ChecklistDayPrefix = "checklistDay_";
String ID_ItemPrefix = "item_";
String ID_DefaultBlankChecklistDayID =
    ID_TempIDPrefix + ID_ChecklistDayPrefix + "-1";

//Type Defaults
String Default_FallbackDate = "1969-07-20";
