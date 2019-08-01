#Accept input parameters  
Param(  
    [Parameter(Position=0, Mandatory=$false, ValueFromPipeline=$true)]  
    [string] $Office365Username,  
    [Parameter(Position=1, Mandatory=$false, ValueFromPipeline=$true)]  
    [string] $Office365Password  
)  
  
#Constant Variables  
$OutputFile = "DistributionGroupMembers.csv"   #The CSV Output file that is created, change for your purposes  
$arrDLMembers = @{}  
  
 
#Kill existing Powershell sessions 
Get-PSSession | Remove-PSSession  
  
#Provide credentials 
if (([string]::IsNullOrEmpty($Office365Username) -eq $false) -and ([string]::IsNullOrEmpty($Office365Password) -eq $false)) 
{ 
    $SecureOffice365Password = ConvertTo-SecureString -AsPlainText $Office365Password -Force      
        
    $Office365Credentials  = New-Object System.Management.Automation.PSCredential $Office365Username, $SecureOffice365Password  
} 
else 
{  
    $Office365Credentials  = Get-Credential 
} 
#Create remote Powershell session  
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Office365credentials -Authentication Basic –AllowRedirection          
 
#Import the session  
Import-PSSession $Session -AllowClobber | Out-Null           
  
#Prepare Output file with headers  
Out-File -FilePath $OutputFile -InputObject "Distribution Group DisplayName,Distribution Group Email,Member DisplayName, Member Email, Member Type" -Encoding UTF8  
  
#Get all Distribution Groups from Office 365  
$objDistributionGroups = Get-DistributionGroup -ResultSize Unlimited  
  
#Iterate    
Foreach ($objDistributionGroup in $objDistributionGroups)  
{      
     
    write-host "Processing $($objDistributionGroup.DisplayName)..."  
  
    #Get members of this group  
    $objDGMembers = Get-DistributionGroupMember -Identity $($objDistributionGroup.PrimarySmtpAddress)  
      
    write-host "Found $($objDGMembers.Count) members..."  
      
    #Iterate through each member  
    Foreach ($objMember in $objDGMembers)  
    {  
        Out-File -FilePath $OutputFile -InputObject "$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)" -Encoding UTF8 -append  
        write-host "`t$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)" 
    }  
}  
 
#Clean up session  
Get-PSSession | Remove-PSSession  
 