using namespace System.Management.Automation
using namespace System.Text.RegularExpressions

function Get-MatchedGroupValue {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Match] $Match,

        [Parameter(Mandatory)]
        [string] $Name
    )

    process {
        $Match.Groups | 
            Where-Object Name -EQ $Name  | 
            ForEach-Object { $_.Value }
    }
}
