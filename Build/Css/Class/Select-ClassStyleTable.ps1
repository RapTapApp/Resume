using namespace System.Management.Automation

function Select-ClassStyleTable {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $CssTextStyles
    )

    process {
        # Split text into styles
        $__Table = @{}

        @($CssTextStyles -split ';') | 
            Where-Object { 
                $_.Trim() -match '(?i)(?<NAME>[^\s]+?)\s*:\s*(?<VALUE>.+)' 
            } |
            ForEach-Object { 
                $__Table.Add($Matches.NAME, $Matches.VALUE) 
            }

        Write-Output $__Table
    }
}
