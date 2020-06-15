using namespace System.Management.Automation
using namespace System.Text.RegularExpressions

function Remove-Comments {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $CssText
    )

    process {
        Write-Information "Removing Css comments..." 

        $__CssText = [regex]::Replace($CssText, '(?s)(\s+)(/\*)(.*?)(\*/)', '')

        Write-Verbose "Removed Css comments" 

        Write-Output $__CssText
    }
}
