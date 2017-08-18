$Scripts = Get-ChildItem $PSScriptRoot -Exclude All.ps1,UpdateCommon.ps1

foreach($Script in $Scripts)
{
    if($Script.Name.EndsWith(".ps1"))
    {
        Import-Module $Script -Force
    }
    else
    {
        Write-Verbose ("Skipped module " + $Script.Name)
    }
}