using namespace System.Management.Automation
using namespace System.Xml

function Convert-CssClassToInlineAttributes {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, Position = 0)]
        [xml] $XmlDoc,

        [Parameter(Mandatory)]
        [hashtable] $CssClasses
    )

    Write-Information "Converting CSS classes to inline attributes..." 

    $__Log = New-Log

    $XmlDoc |
        Get-XmlElements -pv __Element |
        Where-Object { 
            $__ClassAttr = $__Element.Attributes['class']
            Write-Output $__ClassAttr
        } |
        Where-Object { 
            $__ClassName = $__ClassAttr.Value
            $__CssClasses.ContainsKey($__ClassName) 
        } |
        ForEach-Object { 
            # Remove class attribute
            $__Element.Attributes.Remove($__ClassAttr) | Out-Null

            foreach ($__Style in $__CssClasses[$__ClassName].GetEnumerator()) {

                # Add inline attribute
                $__Element.Attributes.Append(
                    $__Element.OwnerDocument.CreateAttribute($__Style.Name)
                ).Value = $__Style.Value

                # Log change
                Add-LogItem $__Log -Item ([ordered] @{
                        ElementName    = $__Element.Name
                        ClassName      = $__ClassName
                        AttributeName  = $__Style.Name
                        AttributeValue = $__Style.Value
                    })
            }
        }



    Write-VerboseLog $__Log -Title 'Converted CSS classes to inline attributes'
}