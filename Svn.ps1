Import-Module "$PSScriptRoot\Process.ps1"

Function Svn-GetEnv
{
    PARAM(
        [Parameter(Mandatory=$False, Position=1)]
        [switch]$Mandatory
    )

    if(Get-Command svn.exe -ErrorAction SilentlyContinue)
    {
        Write-Output "Subversion already in PATH"
    }
    elseif($Mandatory)
    {
        Write-Output "Mandatory Subversion not found, try to download portable Version"
        $TempZip   = "$PSScriptRoot\Tools\Subversion.zip"
        $Target    = "$PSScriptRoot\Tools\Subversion"
        $TargetBin = "$Target\bin"
        Import-Module "$PSScriptRoot\Web.ps1" -Force
        Import-Module "$PSScriptRoot\Compress.ps1" -Force
        if(-not (Test-Path "$PSScriptRoot\Tools"))
        {
            New-Item -ItemType Directory -Path "$PSScriptRoot\Tools"
        }
        if(Web-Download "http://mirror.adirmeier.de/projects/ThirdParty/Subversion/binaries/1.9.7/Subversion.portable.zip" $TempZip)
        {
            Compress-Unzip $TempZip $Target
            Remove-Item $TempZip
            Write-Output "Subversion now available at $TargetBin"
            $env:PATH += ";$TargetBin"
        }
        else
        {
           throw( "Subversion not found, download failed" )
        }
    }
    else
    {
        Write-Output "No Subversion found";
    }
}

Function Svn-Clean
{
    PARAM(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Target
    )

    $CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

    $temp = Process-StartAndGetOutput "svn" "status --no-ignore" $Target
    [string[]]$FilesToDelete = $temp.Split([Environment]::NewLine)

    cd $Target
    foreach($File in $FilesToDelete)
    {
        if($File.Length -gt 0 -and ($File[0] -eq '?' -or $File[0] -eq 'I'))
        {
            Remove-Item $File.Substring(1).Trim() -Recurse -Force
        }
    }
    svn cleanup
    if($LASTEXITCODE -ne 0)
    {
        throw "Failed svn cleanup:"
    }

    cd $CurrentDir
}