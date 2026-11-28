@echo off
REM ----- menu select number

:TOP
echo *****************************************************************
echo * menu                                                          *
echo *   0:CityList                 ÅÀ city-list.csv                 *
echo *   1:Weekly_HeatStress_Index ÅÀ Weekly_HeatStress_Index.CSV    *
echo *   2:Weekly_Comfortable_Ranking ÅÀ ComfortableRegionFinder.CSV *
echo *   3:Largest All-Time Temperature Range TOP10 ÅÀ Largest_All-Time_Temperature_Range_TOP10.csv *
echo *   4:Largest Daily Temperature Range TOP20 ÅÀ Largest_Daily_Temperature_Range_TOP20.csv *
echo *   5:Smallest Daily Temperature Range TOP50 ÅÀ Smallest_Daily_Temperature_Range_TOP50.csvV *
echo *                                                                 *
echo *  99:exit                                                        *
echo *****************************************************************

:MENUSTART
set "USR_INPUT_STR="
set /P "USR_INPUT_STR=Input number: "

REM 
if "%USR_INPUT_STR%"=="0" (
    goto EXECUTE_0
) else if "%USR_INPUT_STR%"=="1" (
    goto EXECUTE_1
) else if "%USR_INPUT_STR%"=="2" (
    goto EXECUTE_2
) else if "%USR_INPUT_STR%"=="3" (
    goto EXECUTE_3
) else if "%USR_INPUT_STR%"=="4" (
    goto EXECUTE_4
) else if "%USR_INPUT_STR%"=="5" (
    goto EXECUTE_5

) else if "%USR_INPUT_STR%"=="99" (
    goto EXITTRAP
) else (
    echo Wrong number
    echo.
    goto MENUSTART
)

REM 0 start
:EXECUTE_0
call "C:\weather\db_sql2csv\Select2CSV-citylist.bat"
cls
goto TOP

REM 1 start
:EXECUTE_1
call "C:\weather\db_sql2csv\Weekly_HeatStress_Index.bat"
cls
goto TOP

REM 2 start
:EXECUTE_2
call "C:\weather\db_sql2csv\ComfortableRegionFinder.bat"
cls
goto TOP

REM 3 start
:EXECUTE_3
call "C:\weather\db_sql2csv\Largest_All-Time_Temperature_Range_TOP10.bat"
cls
goto TOP

REM 4 start
:EXECUTE_4
call "C:\weather\db_sql2csv\Largest_Daily_Temperature_Range_TOP20.bat"
cls
goto TOP

REM 5 start
:EXECUTE_5
call "C:\weather\db_sql2csv\Smallest_Daily_Temperature_Range_TOP20.bat"
cls
goto TOP



:EXITTRAP
echo.
echo End
echo Press any key to continue...
set /p dummy=
exit

