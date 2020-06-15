using namespace System.Management.Automation

function Import-CssClassTable($Path) {

    Write-Information "Reading css from: '$Path'..." 

    Get-Content $Path -Raw |
        Remove-Comments |
        Convert-HslToRgbColor |
        Convert-VariableToValue |
        Select-ClassTable
}
