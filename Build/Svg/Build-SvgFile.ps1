using namespace System.IO
using namespace System.Management.Automation
using namespace System.Xml

function Build-SvgFile {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [FileInfo] $SourceFile,

        [Parameter(Mandatory)]
        [hashtable] $CssClasses,

        [Parameter(Mandatory)]
        $OutDir
    )

    process {

        Write-Information "Building svg from: '$(Resolve-Path $SourceFile.FullName -Relative)'..." 

        $__XmlDoc = [xml] (Get-Content $SourceFile.FullName -Raw)

        $__SvgElement = $__XmlDoc.GetElementsByTagName('svg')
        if (! $__SvgElement) {
            Write-Warning "Did not contain <svg> element"

        } else {

            $__LinkElement = $__SvgElement.GetElementsByTagName('link')
            if (! $__LinkElement) {
                Write-Warning "Did not contain <link> element"

            } else {

                $__SvgElement.RemoveChild($__LinkElement) | Out-Null
                Write-Verbose 'Removed <link> element'

                Convert-CssClassToInlineAttributes $__XmlDoc -CssClasses $CssClasses

                # Save output
                $__OutFile = Join-Path $OutDir -ChildPath  $SourceFile.Name
                $__XmlDoc.Save($__OutFile)
            
                Write-Verbose "Build svg output: '$__OutFile'"
            
                Write-Output $__OutFile
            }
        }
    }
}
