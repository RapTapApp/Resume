using namespace System.Management.Automation

function Add-LogItem {

    [CmdLetBinding()]    
    param(
        [Parameter(Position = 0)]
        [System.Collections.Generic.List[PSCustomObject]] $Log,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Item
    )

    if ($Log -eq $null) {
        throw [System.ArgumentNullException]::new('Log')
    }

    $Log.add(
        $([PSCustomObject]$Item)
    )
}
