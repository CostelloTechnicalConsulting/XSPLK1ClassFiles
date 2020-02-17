@echo off

SET SPLUNK_HOME=C:\Splunk
SET APP_PKG_DIR="C:\XSPLK1ClassFiles\AppPackages"

cd %SPLUNK_HOME%\bin

splunk install app %APP_PKG_DIR%\destinations.tar -auth "admin:password"

splunk restart
