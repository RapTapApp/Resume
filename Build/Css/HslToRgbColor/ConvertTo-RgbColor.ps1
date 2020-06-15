using namespace System.Management.Automation

function ConvertTo-RgbColor([double] $Hue, [double] $Saturation, [double] $Lightness) {

    $Hue /= 360.0
    $Saturation /= 100.0
    $Lightness /= 100.0

    # Init black
    [int]$R = 0
    [int]$G = 0
    [int]$B = 0

    if ($Lightness -ne 0) {

        if ($Saturation -eq 0) {

            # Shades of gray
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
