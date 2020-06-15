using namespace System.Collections.Generic
using namespace System.Management.Automation

function Write-VerboseLog {

    [CmdLetBinding()]    
    param(
        [Parameter(Position = 0)]
        [List[PSCustomObject]] $Log,

        [Parameter(Mandatory)]
        [string] $Title
    )

    if ($Log -eq $null) {
        throw [System.ArgumentNullException]::new('Log')
    }

    Write-Verbose "[ $Title ]"

    $Log | 
        Format-Table | 
        Out-String -Stream | 
        Where-Object { $_ } | 
        Write-Verbose
    
    Write-Verbose "Total: $($Log.Count)"
}
