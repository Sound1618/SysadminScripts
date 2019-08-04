#Backs up all Group Policies to a folder before rolling out changes in Win Server 2012
#$Path and $Filename can be created to ease the task when using along with backup restore script

Import-Module grouppolicy
$date = get-date -format yyyy.M.d
New-Item -Path \\server\c$\Backup\GroupPolicies\$date -ItemType directory
Backup-Gpo -All -Path \\server\c$\Backup\GroupPolicies\Gopbackup$date