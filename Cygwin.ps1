
Function Cygwin-GetEnv
{
    PARAM(
        [switch]$Mandatory
    )
    
    # Test default location from orignal Cygwin-Setup x64
    if((Test-Path "C:\cygwin64\bin"))
    {
        $env:PATH += ";C:\cygwin64\bin"
        Write-Output "Cygwin found at C:\cygwin64\bin"
    }
    # Test default location from orignal Cygwin-Setup x86
    if((Test-Path "C:\cygwin\bin"))
    {
        $env:PATH += ";C:\cygwin\bin"
        Write-Output "Cygwin found at C:\cygwin\bin"
    }
    # Test default location on BuildSystem VM (x64)
    elseif((Test-Path "C:\Tools\cygwin64\bin"))
    {
        $env:PATH += ";C:\Tools\cygwin64\bin"
        Write-Output "Cygwin found at C:\Tools\cygwin64\bin"
    }
    # Test default location on BuildSystem VM (x86)
    elseif((Test-Path "C:\Tools\cygwin\bin"))
    {
        $env:PATH += ";C:\Tools\cygwin\bin"
        Write-Output "Cygwin found at C:\Tools\cygwin\bin"
    }
    elseif($Mandatory)
    {
        throw( "No Cygwin found" )
    }
    else
    {
        Write-Output "No Cygwin found"
    }
}
