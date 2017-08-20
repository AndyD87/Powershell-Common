Import-Module "$PSScriptRoot\Process.ps1" -Force

Function Python-GetEnv
{
    PARAM(
        [Parameter(Mandatory=$False, Position=1)]
        [string]$Version = "3.6",
        [switch]$Mandatory
    )

    $VTarget = New-Object System.Version($Version)
    if($VTarget.Major -eq 2)
    {
        if(Get-Command python.exe -ErrorAction SilentlyContinue)
        {
            Write-Output "Python already in PATH"
        }
        # Test default location from BuildSystem
        elseif((Test-Path "C:\Tools\Python27"))
        {
            $env:PATH += ";C:\Tools\Python27"
            Write-Output "Python found at C:\Tools\Python27"
        }
        # Test default location from orignal Python-Setup 2.7.x
        elseif((Test-Path "C:\Python27"))
        {
            $env:PATH += ";C:\Python27"
            Write-Output "Python found at C:\Python27"
        }
        # Check for Portable Version downloaded
        elseif((Test-Path "$PSScriptRoot\Tools\WinPython"))
        {
            $env:PATH += ";$PSScriptRoot\Tools\WinPython\python-2.7.13"
            Write-Output "Python found at $PSScriptRoot\Tools\WinPython\python-2.7.13"
        }
        elseif($Mandatory)
        {
            Write-Output "Mandatory Python not found, try to download portable Version"
            $Url       = "http://mirror.adirmeier.de/projects/ThirdParty/WinPython/binaries/2.7.13.1/WinPython.32bit.zip"
            $TempZip   = "$PSScriptRoot\Tools\WinPython.zip"
            $Target    = "$PSScriptRoot\Tools\WinPython"
            $TargetBin = "$Target\python-2.7.13"
            Import-Module "$PSScriptRoot\Web.ps1" -Force
            Import-Module "$PSScriptRoot\Compress.ps1" -Force
            if(-not (Test-Path "$PSScriptRoot\Tools"))
            {
                New-Item -ItemType Directory -Path "$PSScriptRoot\Tools"
            }
            if(Web-Download $Url $TempZip)
            {
                Compress-Unzip $TempZip $Target
                Remove-Item $TempZip
                Write-Output "WinPython now available at $TargetBin"
                $env:PATH += ";$TargetBin"
            }
            else
            {
               throw( "WinPython not found, download failed" )
            }
        }
        else
        {
            Write-Output "No Python found"
        }
    }

    if($VTarget.Major -eq 3)
    {
        if(Get-Command python.exe -ErrorAction SilentlyContinue)
        {
            Write-Output "Python already in PATH"
        }
        # Test default location from BuildSystem
        elseif((Test-Path "C:\Tools\Python36"))
        {
            $env:PATH += ";C:\Tools\Python36"
            Write-Output "Python found at C:\Tools\Python36"
        }
        # Test default location from orignal Python-Setup 3.6.x
        elseif((Test-Path "C:\Program Files\Python36"))
        {
            $env:PATH += ";C:\Program Files\Python36"
            Write-Output "Python found at C:\Program Files\Python36"
        }
        # Test default location from orignal Python-Setup 3.4.x
        elseif((Test-Path "C:\Program Files\Python34"))
        {
            $env:PATH += ";C:\Program Files\Python34"
            Write-Output "Python found at C:\Program Files\Python34"
        }
        # Check for Portable Version downloaded
        elseif((Test-Path "$PSScriptRoot\Tools\WinPython"))
        {
            $env:PATH += ";$PSScriptRoot\Tools\WinPython\python-3.6.2.0"
            Write-Output "Python found at $PSScriptRoot\Tools\WinPython\python-3.6.2.0"
        }
        elseif($Mandatory)
        {
            Write-Output "Mandatory Python not found, try to download portable Version"
            $Url       = "http://mirror.adirmeier.de/projects/ThirdParty/WinPython/binaries/3.6.2.0/WinPython.32bit.zip"
            $TempZip   = "$PSScriptRoot\Tools\WinPython.zip"
            $Target    = "$PSScriptRoot\Tools\WinPython"
            $TargetBin = "$Target\python-3.6.2"
            Import-Module "$PSScriptRoot\Web.ps1" -Force
            Import-Module "$PSScriptRoot\Compress.ps1" -Force
            if(-not (Test-Path "$PSScriptRoot\Tools"))
            {
                New-Item -ItemType Directory -Path "$PSScriptRoot\Tools"
            }
            if(Web-Download $Url $TempZip)
            {
                Compress-Unzip $TempZip $Target
                Remove-Item $TempZip
                Write-Output "WinPython now available at $TargetBin"
                $env:PATH += ";$TargetBin"
            }
            else
            {
               throw( "WinPython not found, download failed" )
            }
        }
        else
        {
            Write-Output "No Python found"
        }
    }
}

Python-GetEnv "2.7" -Mandatory
