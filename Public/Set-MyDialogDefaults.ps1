
#region function Set-MyDialogDefaults
function Set-MyDialogDefaults()
{
  <#
    .SYNOPSIS
      Set default Dialog Form Font and Colors
    .DESCRIPTION
      Set default Dialog Form Font and Colors
    .PARAMETER ControlSpace
      Space between Form Controls
    .PARAMETER FontFamily
      Default Dialog Text FontFamily
    .PARAMETER FontSize
      Default Dialog Text Font Size
    .PARAMETER NoScale
      Do Not Scale Font Size
    .PARAMETER BackColor
      Default Dialog Form BackgroundColor
    .PARAMETER ForeColor
      Default Dialog Form ForegroundColor
    .PARAMETER GroupForeColor
      Default Dialog Group ForegroundColor
    .PARAMETER LabelForeColor
      Default Dialog Label ForegroundColor
    .PARAMETER TextBackColor
      Default Dialog Textbox BackgroundColor
    .PARAMETER TextForeColor
      Default Dialog Textbox ForegroundColor
    .PARAMETER ButtonBackColor
      Default Dialog Button BackgroundColor
    .PARAMETER ButtonForeColor
      Default Dialog Button ForegroundColor
    .EXAMPLE
      Set-MyDialogDefaults
    .EXAMPLE
      Set-MyDialogDefaults -ControlSpace 4 -FontFamily "Verdana" -FontSize 10
    .EXAMPLE
      $Default = Set-MyDialogDefaults -ControlSpace 4 -FontFamily "Verdana" -FontSize 10 -PassThru
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
    [ValidateRange(2, 8)]
    [int]$ControlSpace = 4,
    [System.Drawing.FontFamily]$FontFamily = "Verdana",
    [ValidateRange(6, 72)]
    [Single]$FontSize = 10,
    [Switch]$NoScale,
    [System.Drawing.Color]$BackgroundColor = [System.Drawing.SystemColors]::Control,
    [System.Drawing.Color]$ForegroundColor = [System.Drawing.SystemColors]::ControlText,
    [System.Drawing.Color]$ButtonBackgroundColor = [System.Drawing.SystemColors]::Control,
    [System.Drawing.Color]$ButtonForegroundColor = [System.Drawing.SystemColors]::ControlText,
    [System.Drawing.Color]$GroupForegroundColor = [System.Drawing.SystemColors]::ControlText,
    [System.Drawing.Color]$LabelForegroundColor = [System.Drawing.SystemColors]::ControlText,
    [System.Drawing.Color]$TextBackgroundColor = [System.Drawing.SystemColors]::Window,
    [System.Drawing.Color]$TextForegroundColor = [System.Drawing.SystemColors]::WindowText,
    [Switch]$PassThru
  )
  Write-Verbose -Message "Enter Function Set-MyDialogDefaults"
  $TextString = "The quick brown fox jumped over the lazy dogs back"
  $Graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
  if ($NoScale.IsPresent)
  {
    $Ratio = 1
  }
  else
  {
    $Ratio = 96 / $Graphics.DpiX
  }
  $MeasureString = $Graphics.MeasureString($TextString, (New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)))
  $Script:MyDialogDefaults = [PSCustomObject]@{
    "ControlSpace" = $ControlSpace;
    "FontFamily" = $FontFamily;
    "FontSize" = $FontSize * $Ratio;
    "Regular" = (New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point));
    "Bold" = (New-Object -TypeName System.Drawing.Font($FontFamily, ($FontSize * $Ratio), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point));
    "Ratio" = $Ratio;
    "NoScale" = $NoScale.IsPresent;
    "Width" = [Math]::Floor($MeasureString.Width / $TextString.Length)
    "Height" = [Math]::Ceiling($MeasureString.Height);
    "DpiX" = $Graphics.DpiX;
    "DpiY" = $Graphics.DpiY;
    "BackgroundColor" = $BackgroundColor;
    "ForegroundColor" = $ForegroundColor;
    "ButtonBackgroundColor" = $ButtonBackgroundColor;
    "ButtonForegroundColor" = $ButtonForegroundColor;
    "GroupForegroundColor" = $GroupForegroundColor;
    "LabelForegroundColor" = $LabelForegroundColor;
    "TextBackgroundColor" = $TextBackgroundColor;
    "TextForegroundColor" = $TextForegroundColor;
  }
  if ($PassThru.IsPresent)
  {
    $Script:MyDialogDefaults
  }
  $Graphics.Dispose()
  $Graphics = $Null
  $Ratio = $Null
  $MeasureString = $Null
  $TextString = $Null
  
  Write-Verbose -Message "Exit Function Set-MyDialogDefaults"
}
#endregion

Set-MyDialogDefaults -NoScale

