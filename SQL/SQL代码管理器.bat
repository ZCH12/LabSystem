@echo off
setlocal enabledelayedexpansion
title SQL���������
set Host=ZCH-PAD10
set User=sa
set Passwd=88888888
set database=CMS_db
set IntegratedSecurity=true

rem ---------------------------------
rem -------���´��벻Ҫ�Ҹ�----------
rem ---------------------------------
set ConnectString=-S %Host%
if /i "!IntegratedSecurity!"=="true" (
	set ConnectString=!ConnectString! -E
) else (
	set ConnectString=!ConnectString! -U !User! -P !Passwd!
)


:start
cls
echo. ===============================================
echo.  1.�������ݿ�
echo.  2.�������ݱ�
echo.  e.����sqlcmd
echo. ===============================================
echo. exit.�˳�����
set /p c=��ѡ�����:
if "!c!"=="1" call :exeCreateDatabase
if "!c!"=="2" call :exeCreateTable
if "!c!"=="e" sqlcmd
goto start

:exeCreateDatabase
sqlcmd !ConnectString! -i 0-Create_DataBase.sql
echo.�������ݿ����
pause
goto :eof

:exeCreateTable
sqlcmd !ConnectString! -i 1-Create_Table.sql
echo.�������ݱ����
pause
goto :eof
