@echo off
REM Define paths directly
set WORKSPACE=C:\Users\Unity_0118\Desktop\Demo_API
set REPORT_DIR=%WORKSPACE%\reports
set COMBINED_REPORT=%REPORT_DIR%\combined_report.html

REM Create reports directory if it doesn't exist
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

REM Initialize the combined report
echo ^<html^>^<head^>^<title^>Combined Report^</title^>^</head^>^<body^> > "%COMBINED_REPORT%"

REM Define JSON files
set JSON_FILES=API_Test.postman_collection.json API_Test\ Copy.postman_collection.json

REM Loop through each JSON file and run the collection
for %%f in (%JSON_FILES%) do (
    echo Running collection %%f...
    newman run "%WORKSPACE%\%%f" -n 2 -r htmlextra --reporter-htmlextra-export "%REPORT_DIR%\temp_report.html"

    REM Check if the report is generated
    if exist "%REPORT_DIR%\temp_report.html" (
        echo ^<h1^>Report for %%~nxf^</h1^> >> "%COMBINED_REPORT%"
        type "%REPORT_DIR%\temp_report.html" >> "%COMBINED_REPORT%"
        echo ^<hr^> >> "%COMBINED_REPORT%"
    ) else (
        echo Failed to generate the report for %%f.
    )
)

REM Finalize the combined report
echo ^</body^>^</html^> >> "%COMBINED_REPORT%"

REM Clean up temporary files
del "%REPORT_DIR%\temp_report.html"

echo Combined report created as combined_report.html
pause
