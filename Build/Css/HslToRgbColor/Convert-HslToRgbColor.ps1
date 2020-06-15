using namespace System.Management.Automation

function Convert-HslToRgbColor {

    [CmdLetBinding()]    
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $CssText
    )

    process {
        Write-Information "Converting HSL to RGB colors..." 

        $__Log = New-Log
        $__CssText = $CssText

        [regex]::Matches($__CssText, '(?si)hsl\(\s*(?<HUE>[0-9]+)\s*,\s*(?<SAT>[0-9]+)%\s*,\s*(?<LGH>[0-9]+)%\s*\)') | 
            Sort-Object { $_.Index + $_.Length } -Descending |
            ForEach-Object {

                $__Hsl = @{
                    Hue        = [int]($_ | Get-MatchedGroupValue -Name 'HUE')
                    Saturation = [int]($_ | Get-MatchedGroupValue -Name 'SAT')
                    Lightness  = [int]($_ | Get-MatchedGroupValue -Name 'LGH')
                }

                $__Rgb = ConvertTo-RgbColor @__Hsl

                # Update text
                $__CssText = (
                    $__CssText.Substring(0, $_.Index) + 
                    $__Rgb +
                    $__CssText.Substring($_.Index + $_.Length)
                )

                # Log change
                Add-LogItem $__Log -Item ([ordered] @{
                        'Hue °'        = $__Hsl.Hue
                        'Saturation %' = $__Hsl.Saturation
                        'Lightness %'  = $__Hsl.Lightness
                        Index          = $_.Index
                        Length         = $_.Length
                        Rgb            = $__Rgb
                    })
            }



        Write-VerboseLog $__Log -Title 'Converted HSL to RGB colors'

        Write-Output $__CssText
    }
}



# ------------------------------------------------------------------------------------------------------------------
function ConvertTo-RgbColor([double] $Hue, [double] $Saturation, [double] $Lightness) {

    $Hue /= 360.0
    $Saturation /= 100.0
    $Lightness /= 100.0

    [int]$R = 0
    [int]$G = 0
    [int]$B = 0

    if ($Lightness -ne 0) {
        if ($Saturation -eq 0) {
            $R = $G = $B = (255 * $Lightness)
        } else {
            if ($Lightness -lt 0.5) {
                [double]$Beta = $Lightness * (1.0 + $Saturation)
            } else {
                [double]$Beta = $Lightness + $Saturation - ($Lightness * $Saturation)
            }

            [double]$Alpha = 2.0 * $Lightness - $Beta

            $R = ConvertTo-RgbColorComponent $Alpha $Beta ($Hue + 1.0 / 3.0)
            $G = ConvertTo-RgbColorComponent $Alpha $Beta ($Hue)
            $B = ConvertTo-RgbColorComponent $Alpha $Beta ($Hue - 1.0 / 3.0)
        }
    }

    Write-Output ('#{0:X2}{1:X2}{2:X2}' -f $R, $G, $B)
}



# ------------------------------------------------------------------------------------------------------------------
function ConvertTo-RgbColorComponent([double] $Alpha, [double] $Beta, [double] $Hue) {

    if ($Hue -lt 0.0) {
        $Hue += 1.0
    } elseif ($Hue -gt 1.0) {
        $Hue -= 1.0
    }

    $Component = $(
        if ($Hue -lt 1.0 / 6.0) {
            $Alpha + ($Beta - $Alpha) * 6.0 * $Hue
        } elseif ($Hue -lt 0.5) {
            $Beta
        } elseif ($Hue -lt 2.0 / 3.0) {
            $Alpha + (($Beta - $Alpha) * ((2.0 / 3.0) - $Hue) * 6.0)
        } else {
            $Alpha
        }
    )

    Write-Output (255 * $Component)
}
