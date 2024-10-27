//Save File Paths
String DataDirectoryPath = "lib\\model\\storage\\local_storage\\test_storage";
String ItemFileString = DataDirectoryPath + "\\items.json";
String ChecklistFileString = DataDirectoryPath + "\\checklists.json";
String WorksiteFileString = DataDirectoryPath + "\\worksites.json";

String FallbackDate = "1969-07-20";

//API Path Strings
String API_Path = "http://localhost:3000/api";
String API_WorksitePath = API_Path + "/worksite/";

//ID Markers
String ID_TempIDPrefix = "temp_";
String DefaultBlankChecklistDayID = ID_TempIDPrefix + "-1";
