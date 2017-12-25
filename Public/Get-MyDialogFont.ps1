
#region function Get-MyDialogFont
function Get-MyDialogFont()
{
  <#
    .SYNOPSIS
      Set default Dialog Form Font and Colors
    .DESCRIPTION
      Set default Dialog Form Font and Colors
    .PARAMETER FontFamily
      Default Dialog Text FontFamily
    .PARAMETER FontSize
      Default Dialog Text Font Size
    .PARAMETER NoScale
      Do Not Scale Font Size
    .EXAMPLE
      Get-MyDialogFont
    .EXAMPLE
      Get-MyDialogFont -ControlSpace 4 -FontFamily "Verdana" -FontSize 10
    .EXAMPLE
      $Default = Get-MyDialogFont -ControlSpace 4 -FontFamily "Verdana" -FontSize 10 -PassThru
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [System.Drawing.FontFamily]$FontFamily = $Script:MyDialogDefaults.FontFamily,
    [ValidateRange(6, 72)]
    [Single]$FontSize = $Script:MyDialogDefaults.FontSize,
    [Switch]$NoScale
  )
  Write-Verbose -Message "Enter Function Get-MyDialogFont"
  
  $TextString = "The quick brown fox jumped over the lazy dogs back"
  $Graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
  if ($NoScale.IsPresent -or $Script:MyDialogDefaults.NoScale)
  {
    $Ratio = 1
  }
  else
  {
    $Ratio = 96 / $Graphics.DpiX
  }
  $MeasureString = $Graphics.MeasureString($TextString, (New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)))
  [PSCustomObject]@{
    "Regular" = (New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point));
    "Bold" = (New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point));
    "Width" = [Math]::Floor($MeasureString.Width / $TextString.Length)
    "Height" = [Math]::Ceiling($MeasureString.Height);
  }
  $Graphics.Dispose()
  $Graphics = $Null
  $MeasureString = $Null
  $TextString = $Null
  
  Write-Verbose -Message "Exit Function Get-MyDialogFont"
}
#endregion

