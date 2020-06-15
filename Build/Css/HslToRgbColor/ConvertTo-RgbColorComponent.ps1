using namespace System.Management.Automation

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
