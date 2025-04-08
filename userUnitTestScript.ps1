


Function Search-User
{
   [string[]]$userNameList = (Get-AdUser -Filter * ).Name
   $objectList = (Get-AdUser -Filter *)
   [string]$name;
   [char]$check
   [int]$count = 0;
   $name = Read-Host "Enter Name";
   for ($i = 0; $i -lt $userNameList.length; $i++)
   {
    if ($userNameList[$i] -match $name)
    {
        $count++;
        
        $check = Read-Host "Is this who are looking for?" $userNameList[$i] "(y/n) "
        if ($check -eq 'y' -or $check -eq 'Y')
        {
            
            $bool = (Get-Enabled -User (Get-AdUser -Identity $objectList[$i].SamAccountName))
            if ($bool)
            {
                Write-Host $userNameList[$i]" is Enabled"
                
            }
            break;
        }

        
    }
   

   }
 

   
   if( $count -le 0)
   {
       Write-Host "User does not exist in Active Directory"
   }


}

Function Get-Enabled
{
    param([string]$User)
    
    
    return (Get-AdUser -Identity $User).Enabled

}

Search-User
