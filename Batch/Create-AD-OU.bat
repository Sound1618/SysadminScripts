:: Replace parameters name OU
set theDomain=dc=kicks, dc=local

:: OU in domain
	dsadd ou "ou=theOffice, %theDomain%"

:: OUs for Users in OU
	for %%i in (CT,PT,ST,FT,ND) do 
		dsadd ou "ou=%%i, ou=theOffice, %theDomain%"
	)

:: Add xtra OU’s if required
	dsadd ou "ou=_computers, ou=theOffice, %theDomain%"
	dsadd ou "ou=_printers, ou=theOffice, %theDomain%"