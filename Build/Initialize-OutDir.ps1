using namespace System.Management.Automation

function Initialize-OutDir() {

    Write-Information "Recreating '_out' folder..."

    if (Test-Path -LiteralPath '.\_out' -PathType Container) {
        Remove-Item -LiteralPath '.\_out' -Force -Recurse -Verbose
    }

    New-Item -Path '.\_out' -ItemType Directory | Write-Output

    Write-Verbose "Recreated '_out' folder"
}
