:: Replace paths for local paths and extension for the desired filetype to be moved 
:: To be run by a scheduled task every 5 mins to applications that only accept individual files and not in a bulk

@echo off

 for %%f in (F:\Path\To\File\*.csv) do call :p "%%f"
 for /f %%f in ('dir /b /s /os /a-d E:\SFTP_Root\PRD_Path\To\Folder\*.csv') do call :p "%%f"
 goto :eof

 :p
	copy %1 "E:\SFTP_Root\PRD_Westpac\CONNECT\StagingFolder" > NUL
    move %1 "\\SERV01\WindowsService\PRD_Westpac\ConvertorStagingFolder" > NUL
	timeout 120 > NUL
 goto :eof


