using namespace System.Management.Automation

function Convert-VariableToValue {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $CssText
    )

    process {
        Write-Information "Converting css variables to values..." 
        
        $__CssText = $CssText
        if ($__CssText -match '(?s)(?<=(^:root\s+\{))(?<VARS>.+?)(\})(?<STYLES>.*)') {

            $__CssText = $Matches.STYLES

            $__Variables = Select-VariableTable $Matches.VARS
        
            $__CssText = Update-VariableToValue $__CssText $__Variables
        }

        Write-Output $__CssText
    }
}
