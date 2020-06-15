using namespace System.Management.Automation

$InformationPreference = [ActionPreference]::Continue
$VerbosePreference = [ActionPreference]::Continue
$ErrorActionPreference = [ActionPreference]::Stop

Set-Location $PSScriptRoot



Write-Information 'Loading scripts from build folder...'
foreach ($__Script in @(Get-ChildItem -Path '.\Build' -Filter *.ps1 -Recurse)) {

    Write-Verbose "Script: $__Script"
    . $__Script.FullName 
}


    
$__OutDir = Initialize-OutDir

$__CssClasses = Import-CssClassTable '.\style.css'

$__OutSvgFiles = @(
    Get-ChildItem -Filter '*.svg' -Recurse -File |
        ? { $_.DirectoryName -ne $__OutDir } |
        Build-SvgFile -CssClasses $__CssClasses -OutDir $__OutDir
)
