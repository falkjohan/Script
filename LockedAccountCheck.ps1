<#
.SYNOPSIS
Checks if a specific user account in Active Directory is locked.

.DESCRIPTION
This script uses a DirectorySearcher to locate a specific user account based on its samAccountName.
Once the account is found, the script retrieves the 'msds-user-account-control-computed' attribute to determine the account's status.
The script then checks if the user account is locked by comparing the 'msds-user-account-control-computed' attribute value
against the ADS_UF_LOCKOUT flag.

.PARAMETER sAMAccountName
The username of the account to be checked.

.EXAMPLE
$sAMAccountName = "user123"
# Run the script to check if the user account 'user123' is locked.

.NOTES
Author: Johan Falk
Version: 1.0
Date: 2022-05-03

#>


$sAMAccountName = "<useraccount>" # Enter username of the account to be checked 
$ADS_UF_LOCKOUT = 16    
$Attribute = "msds-user-account-control-computed"    
$ADSearcher = New-Object System.DirectoryServices.DirectorySearcher
$ADSearcher.PageSize = 1000
$ADSearcher.Filter = "samaccountname=$sAMAccountName"
$User = $ADSearcher.FindOne()    
$MyUser = $User.GetDirectoryEntry()
$MyUser.RefreshCache($Attribute)    
$UserAccountFlag = $MyUser.Properties[$Attribute].Value    
if ( $UserAccountFlag -band $ADS_UF_LOCKOUT )
{

Write-host "Account $sAMAccountName is locked"
}
else
{

Write-host "Account $sAMAccountName isn't locked"
}