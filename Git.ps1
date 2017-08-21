Import-Module "$PSScriptRoot\Process.ps1"

Function Git-GetEnv
{
    if(Get-Command git -ErrorAction SilentlyContinue)
    {
        Write-Output "git already in PATH"
    }
    elseif((Test-Path "C:\Program Files\Git\bin"))
    {
        $env:PATH += "C:\Program Files\Git\bin"
        Write-Output "git found at C:\Program Files\Git\bin"
    }
    ## Currently no portable version availabe, but it will follow soon
    #elseif($Mandatory)
    #{
    #    Write-Output "Mandatory git not found, try to download portable Version"
    #    $TempZip   = "$PSScriptRoot\Tools\git.zip"
    #    $Target    = "$PSScriptRoot\Tools\git"
    #    $TargetBin = "$Target"
    #    Import-Module "$PSScriptRoot\Web.ps1" -Force
    #    Import-Module "$PSScriptRoot\Compress.ps1" -Force
    #    if(-not (Test-Path "$PSScriptRoot\Tools"))
    #    {
    #        New-Item -ItemType Directory -Path "$PSScriptRoot\Tools"
    #    }
    #    if(Web-Download "http://mirror.adirmeier.de/projects/ThirdParty/git/..../git.portable.zip" $TempZip)
    #    {
    #        Compress-Unzip $TempZip $Target
    #        Remove-Item $TempZip
    #        Write-Output "git now available at TargetBin"
    #        $env:PATH += ";$TargetBin"
    #    }
    #    else
    #    {
    #        throw( "git not found, download failed" )
    #    }
    #}
    elseif($Mandatory)
    {
        throw "No git found"
    }
    else
    {
        Write-Output "No git found"
    }
}

Function Git-Execute
{
    PARAM(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Arguments
    )

    if(Get-Command git -ErrorAction SilentlyContinue)
    {
        Process-StartInlineAndThrow "git" "$Arguments"
    }
    else
    {
        throw "git command not found"
    }
}

Function Git-Clone
{
    PARAM(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Source,
        [Parameter(Mandatory=$true, Position=2)]
        [string]$Target
    )
    Git-Execute "clone `"$Source`" `"$Target`""
}

Function Git-Checkout
{
    PARAM(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Target,
        [Parameter(Mandatory=$true, Position=2)]
        [string]$Checkout
    )
    
    $CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

    cd $Target

    Git-Execute "checkout `"$Source`""

    cd $CurrentDir
}

Function Git-Clean
{
    PARAM(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Target
    )
    
    $CurrentDir = ((Get-Item -Path ".\" -Verbose).FullName)

    cd $Target

    Git-Execute "submodule foreach --recursive `"git clean -dfx`""
    Git-Execute "clean -dfx"

    cd $CurrentDir
}