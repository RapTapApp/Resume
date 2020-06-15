using namespace System.Management.Automation
using namespace System.Text.RegularExpressions

function Select-VariableTable([string]$VarText) {
    
    Write-Information "Selecting CSS variables..." 
        
    $__Log = New-Log
    $__Table = @{}

    [regex]::Matches($VarText, '(?six)(?<NAME>\-\-[a-z0-9\-]+)(\s*:\s*)(?<VALUE>.+?)(;)') | 
        ForEach-Object {

            $__Item = [ordered] @{
                Name  = $_ | Get-MatchedGroupValue -Name 'NAME' 
                Value = $_ | Get-MatchedGroupValue -Name 'VALUE'
            }

            $__Table.Add($__Item.Name, $__Item.Value)

            Add-LogItem $__Log -Item $__Item
        }



    Write-VerboseLog $__Log -Title 'Selected CSS variables'

    Write-Output $__Table
}
