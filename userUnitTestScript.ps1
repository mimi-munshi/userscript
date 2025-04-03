


Function Search-User
{
   [string[]]$userNameList = Get-AdUser -Filter * | Select-Object Name 
   [string]$name;
   [char]$check
   $name = Read-Host "Enter Name";
   for ($i = 0; $i -lt $userNameList.length; $i++)
   {
    if ($userNameList[$i] -match $name)
    {
        
        $check = Read-Host "Is this who are looking for? (y/n): " $userNameList[$i]
        if ($check -eq 'y' -or $check -eq 'Y')
        {
            $bool = (Get-Enabled -user (Get-AdUser -Filter *))
            if ($bool)
            {
                Write-Host "User is Enabled"
            }
            break;
        }
        else 
        {
            Write-Host "User does not exist in Active Directory"
        }
        



        
    }

   }
 

   
   


}

Function Get-Enabled
{
    param([System.Object[]]$user)
    
    Write-Host $user.SamAccountName
    return 5 -gt 0#(Get-AdUser -Identity $samName).Enabled

}

Search-User