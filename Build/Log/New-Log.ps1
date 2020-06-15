using namespace System.Collections.Generic
using namespace System.Management.Automation

function New-Log {

    [CmdLetBinding()]    
    [OutputType([List[PSCustomObject]])]
    param()

    $__Log = [List[PSCustomObject]]::new()

    Write-Output $__Log -NoEnumerate
}
