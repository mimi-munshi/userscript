


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
        
        $check = Read-Host "Is this who you are looking for?" $userNameList[$i] "(y/n) "
        if ($check -eq 'y' -or $check -eq 'Y')
        {
            
            $bool = (Get-Enabled -User (Get-AdUser -Identity $objectList[$i].SamAccountName))
            if ($bool)
            {
                Write-Host $userNameList[$i]" is Enabled"           
            }
            else 
            {
                Write-Host $userNameList[$i] "is not Enabled"
            }
            
            $userObjects = @{

            
                AccountName = (Get-UserAccountName -User $objectList[$i])
                EmployeeName = (Get-EmployeeName -User $objectList[$i])
                EmployeeNumber = (Get-EmployeeNumber -User $objectList[$i])
                JobTitle = (Get-JobTitle -User $objectList[$i])
                EmployeePhone = (Get-EmployeePhone -User $objectList[$i])
                EmployeeManager = (Get-Manager -User $objectList[$i])
                EmployeeGroups = (Get-OU -User $objectList[$i])

            }
            $jsonOutput = $userObjects | ConvertTo-Json
            Write-Host $jsonOutput
               
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

Function Get-UserAccountName
{
    param([System.Object]$User)
    return $User.UserPrincipalName

}

Function Get-EmployeeName
{
    param([System.Object]$User)
    return $User.Name
}

Function Get-EmployeeNumber
{
    param([System.Object]$User)
    return $User.SID
}

Function Get-JobTitle
{
    param([System.Object]$User)   
    return (Get-AdUser -Identity $User.SamAccountName -Properties SamAccountName,Title).Title
}

Function Get-EmployeePhone
{
    param([System.Object]$User)   
    return (Get-AdUser -Identity $User.SamAccountName -Properties homephone).homephone
}

Function Get-Manager
{
   
    param([System.Object]$User)
    
    if ($null -ne (Get-AdUser -Identity $User.SamAccountName -Properties manager).manager)
    {
    $string = (Get-AdUser -Identity $User.SamAccountName -Properties manager).manager
    $part = ($string -split ',')[0]
    $substring = $part.Substring(3)
    return $substring
    }
    else 
    {
    $substring = 0
    }
    
}

Function Get-OU
{
    param([System.Object]$User) 
    $groupList = (Get-ADPrincipalGroupMembership -Identity $User.SamAccountName).Name
    return $groupList
    

}

Search-User