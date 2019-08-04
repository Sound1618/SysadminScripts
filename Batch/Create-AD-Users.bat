:: Modify parameters and path before running!

@echo OFF
	set theDomain=dc=kicks, dc=local
	set input=users.txt
	IF NOT EXIST .\%input% GOTO ERR1

REM create users and user home directory (including NTFS Permissions)
REM Profile will later be complemented with 
REM group policy user configuration (Folder Redirection, Logon scripts e.a.)

FOR /F "tokens=1-3 skip=3" %%i in (%input%) do (
	REM create user home and profile directory in advance
	md F:\home\%%i
	md F:\users\%%i

	REM create user account
	dsadd user "cn=%%i, ou=%%k, ou=theOffice, %theDomain%" 
				-pwd aaaAAA111 -mustchpwd yes -canchpwd yes 
				-profile \\SRV01\users$\dsadd user "cn=%%i, ou=%%k, ou=theOffice, %theDomain%" 
				-hmdir \\SRV01\home$\%%i -hmdrv P: 
				-loscr logon.bat


	REM while we're at it, set NTFS security for user home and profile folder
	REM 	 User : Read/Write 	Administrators : Full Control,
	
	xcacls F:\home\%%i /c /y /t /e /g "%%i":rcd;ew Administrators:f;f
	xcacls F:\users\%%i /c /y /t /e /g "%%i":rcd;ew Administrators:f;f

)


REM create groups in each OU

dsadd group "cn=lTeam, ou=theOffice, %theDomain%" -secgrp yes -scope L -samid lTeam

for %%i in (Teamleiders, Administratie, Coordinators, Stagiairs) do (
	dsadd group "cn=l%%i, ou=theOffice, %theDomain%" -secgrp yes -scope L -samid l%%i
)


for %%j in (PT,CT,VT,FT,ND) do (
	dsadd group "cn=lTeam, ou=%%j, ou=theOffice, %theDomain%" -secgrp yes -scope L -samid lTeam_%%j

	for %%i in (Teamleiders, Administratie, Coordinators, Stagiairs) do (

		dsadd group "cn=%%i, ou=%%j, ou=theOffice, %theDomain%" -secgrp yes -scope G -samid %%i_%%j
			
		echo 	make GLOBAL GROUPS member of LOCAL GROUPS
		dsmod group "cn=lTeam, ou=theOffice, %theDomain%" -addmbr "cn=%%i, ou=%%j, ou=theOffice, %theDomain%"

		dsmod group "cn=lTeam, ou=%%j, ou=theOffice, %theDomain%" -addmbr "cn=%%i, ou=%%j, ou=theOffice, %theDomain%"

		dsmod group "cn=l%%i, ou=theOffice, %theDomain%" -addmbr "cn=%%i, ou=%%j, ou=theOffice, %theDomain%"
	)
)


REM make users member of group according to listing in inputfile

for /F "tokens=1-3 skip=3" %%i in (%input%) do (
	dsmod group "cn=%%j, ou=%%k, ou=theOffice, %theDomain%"  -addmbr "cn=%%i, ou=%%k, ou=theOffice, %theDomain%"
)


REM remove groups that we don't want (if any)

REM remove groups (Administratie, Coordinators, Stagiairs) from ou ND,
REM dsrm ObjectDN ... [-subtree] -noprompt	;;removes objects
REM dsmod group GroupDN -rmmbr MemberDN	;;removes members from a group


dsrm "cn=Administratie, ou=ND, ou=theOffice, %theDomain%"  -noprompt
dsrm "cn=Coordinators, ou=ND, ou=theOffice, %theDomain%"  -noprompt
dsrm "cn=Stagiairs, ou=ND, ou=theOffice, %theDomain%"  -noprompt


REM custom modifications : for exeptions eg. for users in more than 1 group
REM add statements here


REM FINISH
GOTO BATCHEND

:ERR1
ECHO %0 requires input from %input%. inputfile %input% not found. 
EXIT /B 1

:BATCHEND
ECHO %0 done.
