@echo off
setlocal enabledelayedexpansion
title SQL代码管理工具
set Host=ZCH-PAD10
set User=sa
set Passwd=88888888
set database=CMS_db
set IntegratedSecurity=true

rem ---------------------------------
rem -------以下代码不要乱改----------
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
echo.  1.创建数据库
echo.  2.创建数据表
echo.  e.进入sqlcmd
echo. ===============================================
echo. exit.退出程序
set /p c=请选择序号:
if "!c!"=="1" call :exeCreateDatabase
if "!c!"=="2" call :exeCreateTable
if "!c!"=="e" sqlcmd
goto start

:exeCreateDatabase
sqlcmd !ConnectString! -i 0-Create_DataBase.sql
echo.创建数据库完成
pause
goto :eof

:exeCreateTable
sqlcmd !ConnectString! -i 1-Create_Table.sql
echo.创建数据表完成
pause
goto :eof
