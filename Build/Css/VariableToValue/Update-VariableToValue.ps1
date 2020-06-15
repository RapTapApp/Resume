using namespace System.Management.Automation
using namespace System.Text.RegularExpressions

function Update-VariableToValue([string]$CssText, [hashtable]$Variables) {
    
    Write-Information "Updating CSS variables to values..."
    
    $__Log = New-Log
    $__CssText = $CssText

    $Variables.GetEnumerator() |
        Where-Object {
            $__Var = $_
            $__Token = [regex]::Escape($('var({0})' -f $__Var.Name))
            $__Found = [regex]::Matches($__CssText, $__Token)
            $__Found.Count
        } |
        ForEach-Object {
            $__CssText = [regex]::Replace($__CssText, $__Token, $__Var.Value)

            # Log change
            Add-LogItem $__Log -Item ([ordered] @{
                    Variable      = $__Var.Name
                    TotalFound    = $__Found.Count
                    ReplacedValue = $__Var.Value
                })
        }
        


    Write-VerboseLog $__Log -Title 'Updated CSS variables to values'

    Write-Output $__CssText
}
