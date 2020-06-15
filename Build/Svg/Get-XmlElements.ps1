using namespace System.Management.Automation
using namespace System.Xml

function Get-XmlElements {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [XmlNode] $Node
    )

    process {
        if ($Node.NodeType -eq [XmlNodeType]::Element) {
            Write-Output $Node
        }

        $Node.ChildNodes | Get-XmlElements
    }
}
