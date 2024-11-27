//Save File Paths
String Dir_DataDirectoryPath =
    "lib\\model\\storage\\local_storage\\test_storage";
String Dir_ItemFileString = Dir_DataDirectoryPath + "\\items.json";
String Dir_ChecklistFileString = Dir_DataDirectoryPath + "\\checklists.json";
String Dir_ChecklistDayFileString =
    Dir_DataDirectoryPath + "\\checklistDays.json";
String Dir_WorksiteFileString = Dir_DataDirectoryPath + "\\worksites.json";
String Dir_UnitFileString = Dir_DataDirectoryPath + "\\units.json";

//For testing only.
String Server_Port = "8081";
//API Path Strings
String API_Path = "http://localhost:${Server_Port}";
String API_Inidcator = "/api";

String API_Worksite = API_Inidcator + "/worksite";
String API_WorksitePath = API_Path + API_Worksite;
String API_WorksiteUserVisible = API_Worksite + "/userWorksites";
String API_WorksiteUserVisiblePath = API_Path + API_WorksiteUserVisible;

String API_Checklist = API_Inidcator + "/checklist";
String API_ChecklistPath = API_Path + API_Checklist;
String API_ChecklistOnWorksite = API_Checklist + "/onWorksite";
String API_ChecklistOnWorksitePath = API_Path + API_ChecklistOnWorksite;

String API_ChecklistDay = API_Inidcator + "/checklistDay";
String API_ChecklistDayPath = API_Path + API_ChecklistDay;
String API_DaysOnChecklist = API_ChecklistDay + "/daysOnChecklist";
String API_DaysOnChecklistPath = API_Path + API_DaysOnChecklist;

String API_Item = API_Inidcator + "/item";
String API_ItemPath = API_Path + API_Item;
String API_ItemOnChecklistDay = API_Item + "/onChecklistDay";
String API_ItemOnChecklistDayPath = API_Path + API_ItemOnChecklistDay;
String API_ItemOnChecklist = API_Item + "/onChecklist";
String API_ItemOnChecklistPath = API_Path + API_ItemOnChecklist;

String API_Unit = API_Inidcator + "/unit";
String API_UnitPath = API_Path + API_Unit;
String API_UnitsAll = API_Unit + "/all";
String API_UnitsAllPath = API_Path + API_UnitsAll;

String API_DataSync = API_Inidcator + "/dataSync";
String API_DataSyncPath = API_Path + API_DataSync;

//API DataOject Strings
String API_DataObject_WorksiteStateList = "worksiteStates";
String API_DataObject_ChecklistStateList = "checklistStates";
String API_DataObject_ChecklistDayStateList = "checklistDayStates";
String API_DataObject_ItemStateList = "itemStates";
String API_DataObject_UnitStateList = "unitStates";
String API_DataObject_UserId = "userId";
String API_DataObject_CompanyId = 'companyId';
String API_DataObject_UnitId = 'unitId';
//ID Markers
String ID_TempIDPrefix = "temp_";
String ID_WorksitePrefix = "worksite_";
String ID_ChecklistPrefix = "checklist_";
String ID_ChecklistDayPrefix = "checklistDay_";
String ID_ItemPrefix = "item_";
String ID_UserPrefix = "user_";
String ID_CompanyPrefix = "company_";
String ID_UnitPrefix = "unit_";
String ID_DefaultBlankChecklistDayID =
    ID_TempIDPrefix + ID_ChecklistDayPrefix + "-1";

//Type Defaults
String Default_FallbackDate = "1969-07-20";

//Datasync Timer length
int DataSyncTimerDurationSeconds = 60;
