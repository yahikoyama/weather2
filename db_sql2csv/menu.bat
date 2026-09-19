@echo off
REM ----- menu select number

:TOP
echo *****************************************************************
echo * menu                                                         *
echo *   0:CityList                 ÅÀ city-list.CSV                 *
echo *   1:Weekly_HeatStress_Index ÅÀ Weekly_HeatStress_Index.CSV   *
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

:EXITTRAP
echo.
echo End
echo Press any key to continue...
set /p dummy=
exit

