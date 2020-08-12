$UserList=Get-ADUSER -Filter * 
foreach ($User in $UserList) {
Set-ADUSER $user -ChangePasswordAtLogon $false
}
