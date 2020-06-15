using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Text.RegularExpressions

function Select-ClassTable {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $CssText
    )

    process {
        Write-Information "Selecting CSS classes..." 

        $__Log = New-Log
        $__Table = @{}

        [regex]::Matches($CssText, '(?six)(\.)(?<CLASS>[a-z0-9\-]+)(\s+\{\s*)(?<STYLES>.+?)(\})') | 
            ForEach-Object {

                $__Item = [ordered] @{
                    Class  = $_ | Get-MatchedGroupValue -Name 'CLASS' 
                    Styles = $_ | Get-MatchedGroupValue -Name 'STYLES' | Select-ClassStyleTable
                }

                $__Table.Add($__Item.Class, $__Item.Styles)

                Add-LogItem $__Log -Item $__Item
            }



        Write-VerboseLog $__Log -Title 'Selected CSS classes'

        Write-Output $__Table
    }
}
