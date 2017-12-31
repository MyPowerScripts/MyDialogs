
#region function Get-MyResponseDialog
function Get-MyResponseDialog()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER  Title
      Title Bar Text of the Get-MyResponse Dialog
    .PARAMETER NoTitle
      Hide Get-MyResponse Dialog Title Bar
    .PARAMETER ShowBorder
      Show Border around Dialog
    .PARAMETER Icon
      Icon to Display next to Message
    .PARAMETER Message
      Message to show on the Get-Response Dialog
    .PARAMETER MessageWidth
      Width of Message Text
    .PARAMETER MessageAlignment
      Alignment of the Message Text
    .PARAMETER ResponseButtons
      Respose Buttons to Display
    .PARAMETER DefaultButton
      Default selected Button
    .PARAMETER NoEscape
      Don't allow the Esc Button to Cencel the Dialog
    .PARAMETER TopMost
      Display Get-MyResponse Dialog as the Top Most Window
    .PARAMETER Owner
      Parent Calling Application Form
    .PARAMETER ControlSpace
      Space between Form Controls
    .PARAMETER FontFamily
      Dialog Text Font Family
    .PARAMETER FontSize
      Dialog Text Font Size
    .PARAMETER BackgroundColor
      Dialog Form BackgroundColor
    .PARAMETER ForegroundColor
      Dialog Form ForegroundColor
    .PARAMETER ButtonBackgroundColor
      Dialog Button BackgroundColor
    .PARAMETER ButtonForegroundColor
      Dialog Button ForegroundColor
    .PARAMETER LabelForegroundColor
      Dialog Label ForegroundColor
    .EXAMPLE
      Get-MyResponseDialog -Title "Get-MyResponse" -Message "This is my Message"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "StandAlone")]
  param (
    [Parameter(ParameterSetName = "Dialog")]
    [Parameter(ParameterSetName = "StandAlone")]
    [String]$Title = "Get-MyResponse",
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNT")]
    [Switch]$NoTitle,
    [Parameter(ParameterSetName = "DialogNT")]
    [Parameter(ParameterSetName = "StandAloneNT")]
    [Switch]$ShowBorder,
    [System.Windows.Forms.MessageBoxIcon]$MessageIcon = "Information",
    [Parameter(Mandatory = $True)]
    [String]$Message,
    [ValidateRange(20, 60)]
    [Int]$MessageWidth = 30,
    [System.Drawing.ContentAlignment]$MessageAlignment = "TopLeft",
    [System.Windows.Forms.MessageBoxButtons]$ResponseButtons = "OK",
    [ValidateRange(1, 3)]
    [Int]$DefaultButton = 0,
    [Switch]$NoEscape,
    [Parameter(ParameterSetName = "StandAlone")]
    [Parameter(ParameterSetName = "StandAloneNT")]
    [Switch]$TopMost,
    [Parameter(Mandatory = $True, ParameterSetName = "Dialog")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [System.Windows.Forms.Form]$Owner,
    [ValidateRange(2, 8)]
    [int]$ControlSpace = $Script:MyDialogDefaults.ControlSpace,
    [System.Drawing.FontFamily]$FontFamily = $Script:MyDialogDefaults.FontFamily,
    [ValidateRange(6, 72)]
    [Single]$FontSize = $Script:MyDialogDefaults.FontSize,
    [System.Drawing.Color]$BackgroundColor = $Script:MyDialogDefaults.BackgroundColor,
    [System.Drawing.Color]$ForegroundColor = $Script:MyDialogDefaults.ForegroundColor,
    [System.Drawing.Color]$ButtonBackgroundColor = $Script:MyDialogDefaults.ButtonBackgroundColor,
    [System.Drawing.Color]$ButtonForegroundColor = $Script:MyDialogDefaults.ButtonForegroundColor,
    [System.Drawing.Color]$LabelForegroundColor = $Script:MyDialogDefaults.LabelForegroundColor
  )
  Write-Verbose -Message "Enter Function Get-MyResponseDialog"
  
  if ($PSBoundParameters.ContainsKey("FontSize") -or $PSBoundParameters.ContainsKey("FontFamily"))
  {
    $TempFont = Get-MyDialogFont -FontFamily $FontFamily -FontSize $FontSize -NoScale
  }
  else
  {
    $TempFont = $Script:MyDialogDefaults
  }
  
  #region $MyDialogForm = System.Windows.Forms.Form
  Write-Verbose -Message "Creating Form Control `$MyDialogForm"
  $MyDialogForm = New-Object -TypeName System.Windows.Forms.Form
  $MyDialogForm.BackColor = $ForegroundColor
  $MyDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $MyDialogForm.Font = $TempFont.Bold
  $MyDialogForm.ForeColor = $BackgroundColor
  if ($NoTitle)
  {
    $MyDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
  }
  else
  {
    $MyDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
  }
  $MyDialogForm.KeyPreview = (-not $NoEscape.IsPresent)
  $MyDialogForm.MaximizeBox = $False
  $MyDialogForm.MinimizeBox = $False
  $MyDialogForm.Name = "MyDialogForm"
  if ($PSCmdlet.ParameterSetName -eq "Dialog")
  {
    $MyDialogForm.Owner = $Owner
    $MyDialogForm.ShowInTaskbar = $False
    $MyDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
    $MyDialogForm.TopMost = $False
  }
  else
  {
    $MyDialogForm.ShowInTaskbar = $True
    $MyDialogForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $MyDialogForm.TopMost = $TopMost
  }
  $MyDialogForm.ShowIcon = $False
  $MyDialogForm.Text = $Title
  #endregion
  
  if ($PSBoundParameters.ContainsKey("FontSize") -or $PSBoundParameters.ContainsKey("FontFamily"))
  {
    $TempFont = Get-MyDialogFont -FontFamily $FontFamily -FontSize $FontSize
  }
  else
  {
    $TempFont = $Script:MyDialogDefaults
  }
  
  #region function Start-MyDialogFormKeyDown
  function Start-MyDialogFormKeyDown()
  {
  <#
    .SYNOPSIS
      KeyDown event for the MyDialogForm Control
    .DESCRIPTION
      KeyDown event for the MyDialogForm Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDialogFormKeyDown -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyDown Event for `$MyDialogForm"
    
    if ($EventArg.KeyValue -eq 27)
    {
      $EventArg.SuppressKeyPress = $True
      $MyDialogForm.Close()
    }
    
    Write-Verbose -Message "Exit KeyDown Event for `$MyDialogForm"
  }
  #endregion
  if (-not $NoEscape.IsPresent)
  {
    $MyDialogForm.add_KeyDown({ Start-MyDialogFormKeyDown -Sender $This -EventArg $PSItem })
  }
  
  #region ******** $MyDialogForm Controls ********
  
  if ($ShowBorder.IsPresent)
  {
    $BorderSpace = $ControlSpace
  }
  else
  {
    $BorderSpace = 0
  }
  
  #region $MyDialogPanel = System.Windows.Forms.Panel
  Write-Verbose -Message "Creating Form Control `$MyDialogPanel"
  $MyDialogPanel = New-Object -TypeName System.Windows.Forms.Panel
  $MyDialogForm.Controls.Add($MyDialogPanel)
  $MyDialogPanel.BackColor = $BackgroundColor
  $MyDialogPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyDialogPanel.Font = $MyDialogConfig.FontData.Regular
  $MyDialogPanel.ForeColor = $ForegroundColor
  $MyDialogPanel.Location = New-Object -TypeName System.Drawing.Point($BorderSpace, $BorderSpace)
  $MyDialogPanel.Name = "MyDialogPanel"
  $MyDialogPanel.Text = "MyDialogPanel"
  #endregion
  
  #region ******** $MyDialogPanel Controls ********
  
  $TempLeft = $ControlSpace
  if ($MessageIcon -ne "None")
  {
    #region $MyDialogPictureBox = System.Windows.Forms.PictureBox
    Write-Verbose -Message "Creating Form Control `$MyDialogPictureBox"
    $MyDialogPictureBox = New-Object -TypeName System.Windows.Forms.PictureBox
    $MyDialogPanel.Controls.Add($MyDialogPictureBox)
    $MyDialogPictureBox.AutoSize = $True
    $MyDialogPictureBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    Switch ($MessageIcon)
    {
      { $PSItem -match "Asterisk|Infomation" }
      {
        #region ******** Information Icon ********
        $MyDialogPictureBox.Image = [System.Drawing.Image]([System.Convert]::FromBase64String(@"
/9j/4AAQSkZJRgABAQEAYABgAAD/4QCyRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAZKGAAcAAAB8AAAALAAAAABVTklDT0RFAABDAFIARQBBAFQATwBSADoAIABnAGQALQBqAHAAZQBnACAAdgAx
AC4AMAAgACgAdQBzAGkAbgBnACAASQBKAEcAIABKAFAARQBHACAAdgA4ADAAKQAsACAAcQB1AGEAbABpAHQAeQAgAD0AIAAxADAAMAAKAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAAwADADASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVW
V1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQF
BgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD++zkkYaYjdhsLLg4dwRnfkADAPVhgY+beB/Oz/wAFSP8Ag4r/
AGYv2Ate134LfCzSn/aZ/aW0Uz2HiDwpoGvR6P8ADj4ZashaNrH4ieObeHVWn8S2MhBu/A3hbT9S1K2e3udN8S6t4Ov3tzIv/BxX/wAFR9d/YB/Zg0f4WfBXXzo37S37TX9veH/CniDT7pxqvwy+G+jpBD45+Idk
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
"@))
        #endregion
        Break
      }
      { $PSItem -match "Exclamation|Warning" }
      {
        #region ******** Warning Icon ********
        $MyDialogPictureBox.Image = [System.Drawing.Image]([System.Convert]::FromBase64String(@"
/9j/4AAQSkZJRgABAQEAYABgAAD/4QCyRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAZKGAAcAAAB8AAAALAAAAABVTklDT0RFAABDAFIARQBBAFQATwBSADoAIABnAGQALQBqAHAAZQBnACAAdgAx
AC4AMAAgACgAdQBzAGkAbgBnACAASQBKAEcAIABKAFAARQBHACAAdgA4ADAAKQAsACAAcQB1AGEAbABpAHQAeQAgAD0AIAAxADAAMAAKAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAAwADADASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVW
V1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQF
BgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD++zkkYaYjdhsLLg4dwRnfkADAPVhgY+beAmHwPmuM7efkfOd5
6fvMA7cccrjJzuOAZUZ+ZDlh/wAtpf8AnozDJAxx2boD85J3jPEfETx1ofw18FeIfG+vPENO0DTZLpoEmkjmv7ppFhsNMtfM+X7VqV9Lb2VurfKs06zSFYldh5+bZrluRZXmWd5xjKGXZTk+AxeaZnmGKn7PDYLL
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
qlio0a2FrVqlOlRxFOnVqVIRhKS//9k=
"@))
        #endregion
        Break
      }
      { $PSItem -match "Hand|Error|Stop" }
      {
        #region ******** Error Icon ********
        $MyDialogPictureBox.Image = [System.Drawing.Image]([System.Convert]::FromBase64String(@"
/9j/4AAQSkZJRgABAQEAYABgAAD/4QCyRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAZKGAAcAAAB8AAAALAAAAABVTklDT0RFAABDAFIARQBBAFQATwBSADoAIABnAGQALQBqAHAAZQBnACAAdgAx
AC4AMAAgACgAdQBzAGkAbgBnACAASQBKAEcAIABKAFAARQBHACAAdgA4ADAAKQAsACAAcQB1AGEAbABpAHQAeQAgAD0AIAAxADAAMAAKAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAAwADADASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVW
V1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQF
BgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD++zkkYaYjdhsLLg4dwRnfkADAPVhgY+beAmHwPmuM7efkfOd5
6fvMA7cccrjJzuOAZUZ+ZDlh/wAtpf8AnozDJAxx2boD85J3jPhH7S/7QPgT9lr4FfEn48/EO4iTw18O/DVzq7WEdy0F74g1eSVLLw74V0ppgY/7V8T69c6fomnLIDFHdX0d1cFLSKaRMMVisPgsNiMZi60MPhcJ
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
sXiMTQpUZ1Y//9k=
"@))
        #endregion
        Break
      }
      { $PSItem -match "Question" }
      {
        #region ******** Question Icon ********
        $MyDialogPictureBox.Image = [System.Drawing.Image]([System.Convert]::FromBase64String(@"
/9j/4AAQSkZJRgABAQEAYABgAAD/4QCyRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAZKGAAcAAAB8AAAALAAAAABVTklDT0RFAABDAFIARQBBAFQATwBSADoAIABnAGQALQBqAHAAZQBnACAAdgAx
AC4AMAAgACgAdQBzAGkAbgBnACAASQBKAEcAIABKAFAARQBHACAAdgA4ADAAKQAsACAAcQB1AGEAbABpAHQAeQAgAD0AIAAxADAAMAAKAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAAwADADASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVW
V1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQF
BgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD++zkkYaYjdhsLLg4dwRnfkADAPVhgY+beB+Ff/BT7/gvn+yT/
AME4L/UPhfbpqP7Qf7S1raq9z8G/Aus2mmaf4LluIhcWR+KvjyaHVbHwZNd27JPB4f07SPE/i/7NNZ3t74d07S9SstVkP+C+f/BT7UP+Cb/7JEMHwu1K1tv2lv2g77WfAnwcuWKXUvgvTtMtYLjx38VTY3Km2vJf
Bllquk6d4fhuEmg/4TDxN4ev7yy1LSbHVLOT/Li1vW9Z8S6zq3iPxFq2pa/4g1/Ur7Wdc1zWb661TWNZ1jVLqW91LVdV1K9lnvNQ1HULyea7vb27mmubq5mlnnlklkZj/sB+zo/Z0ZT9IjKZeM/jPLMqPhXRzLE5
bwtwtl2JrZZjOPcZllZ4fNcdjs1w7hjMBwvgMZCtlf8Awl1cPmmZ5nh8dTpY/LKOWN5j8BxdxdUyip/Z2XcjxzhGdevOKnHCxmlKnGMJXjOtOLU/fThCDg3Gbn7n9JPxg/4Or/8Agp74+1m7uPhufgf8CtB86T+z
dK8KfDhPGWpxWhYmJNV1v4m6n4tt9RvVX5Zbqw0TQ7WXAaPToOQT4P8A/B1f/wAFPfAOs2lx8SD8D/jroPnR/wBpaV4r+HCeDdTltAwMqaVrfwy1Pwlb6desvyxXV/omuWsWS0mnT8AeOfsVf8EkPgb4l/YA8bf8
FSf2+vjL8T/hp+ytoGuS+HvBngT9n7w74c1/4zfEa4h8d2fwxk1Ox1Pxgl54V8P20vxAuZvDGmWOo6Tdm7bTdX1nVdU8PaTY202qfT/i/wD4ITfsw/tQ/sCeJP2/P+CV3x5+OPjXRPA+neNdS8SfA39pzw/4Mi+I
V4/w7gl1Hxn4csPEHw70/RNE07xjp2iRLrGhaMum+JNL8VwXun2tt4k026uo1f8A0oz7I/2Z3DWJxvAWb+CHBeH4fyrj+Hg3nPiFHwrzSrwrkviXPDUqkuC808VKeBlmOFz3Dwr0YY/HvNpYLLcRUcMwzbC16Vf2
XxtKpxnWUcVTzLEyrVML/aFPCfX4KvUwd2vrMMC58kqTafLD2alNK8Kck1f+pf8A4Jg/8F8/2Sv+Cj9/p/wvnXUf2fP2lrm2Z7f4N+OtYtNT0/xpLbxG4vT8KfHkMWlWPjKe0gV55/D+o6R4Z8X/AGaG9vLLw5qO
l6de6rF+6mH5+afq/wDyzl9OMZkzjP3M85+/xX+Ifomt6z4a1nSfEfh3VtS0DxBoGpWOs6HrmjX11pesaNrGl3UV7puq6VqVlLBeafqOn3kEN3ZXtpNDc2tzDFPBLHLGrD/Ud/4IGf8ABT2+/wCCkH7JE8HxR1G1
uf2lv2fLzS/AvxkuFC20vjTTtS0+6n8B/FYWNrtt7SXxnY6Vq+neIoIEhtz4u8MeIryystP0rUNKsov81v2i/wCzoyn6O+Ux8Z/BiWZVvCutmWGy3inhbMsVWzPGcBYzM6yw+VY7A5riHPGY/hfH4ydHKv8AhVrY
jNMszTEYClUx2Z0czTy77LhHi6pm1T+zsx5FjlCU6FeCUI4qMFecZU17sa8Y3qfu0oTgpNQg4e//ACWf8HWHxh1rx/8A8FPf+Fb3N3OdB+BPwM+G3hPStNMm62i1PxlFqXxN1vVVjHyLfajb+LtE0+6lT79roemw
t/x7Cv5oq/pc/wCDq/4P6z4B/wCCnn/CyLi0mGg/HX4GfDXxXpOpeS0dpLqfg2LUvhlrWlI5+U3mnW/hLRL+6iUkx2uuabK5zcYH80df7nfQb/sT/iUH6O39gex+o/8AELOGPb+w5eT+2/qa/wBZebk09t/rH/av
1m/vfWPa8/v8x+ZcS+1/t/N/a35vr1e19/Zc37n5ex9nbytY+kV/a8/abP7Nf/DHKfGbxuf2ZpPFv/Ca/wDCmlvoj4VfxI2oJqwuPLFt/aTWJ1xE19dB+3nQR4jz4gXTBrTNfH+6L4A+O/C//BC//ggfYWP7SN9b
aD+0j8e/DvxU8aeB/gjdTxp4u1f4n/F3RxY+E/DVxojkX9pYeBfCI8E6n8Wr+7ggt/C1wmp6Iz3Otz6Fp+sfwofsm6t4j8N/tOfAHxd4S+D2sftBa/4F+LvgD4gWPwS0HTdW1bUvij/wgfibTfF9z4KjsdC0XxFq
stvr1pos9jfvZ6Fq7wWEtzcPYXUUTxN7T/wUj/ap/aD/AGwf2vvi38Xf2kND8b+AvGtzr9zpek/BzxxJrUd58EfCNq7TeH/hjp+la5o/hy70qz0KzuFluC3hzRLjWtUvL/xJqVkdU1i9uJvivpEfR4oePPF/h94U
LDcO8I+EGA4preO/izPI/wCxcHxT4gcWZdjKWV5HkDyzCVKGY0cLnUsVmWY8WcZ4zBYqpilgcsy7CYyGYp1KPTlGbvKsPi8dzVcRmE6CyvAKr7SVDCUJxdSrV55Jwbp8sIUMPGUVHnnOUeTR/CVf0u/8Gp/xg1nw
D/wU8Pw3t7uYaD8dvgV8TfCmq6b5pS1m1Twbbaf8TdE1Vo/uG+0638I63YWkzg+Ta65qKAfvyR/NFX9Ln/Bqf8HtY8f/APBT3/hZFvZynQfgT8DPiX4s1XUjC8lpDqfjKDTvhlomlO68C91G38Xa3f2sTEGS10PU
ZAf9HIP2v05P7E/4lB+kT/b/ALH6j/xCzif2Ht+Xk/tv6m/9WuXn09t/rH/ZX1a3vfWPZcnv8pzcNe1/t/KPZX5vr1C9t/Zc3775ex9pzeV7n9an/BfT/gmFff8ABR/9kiGf4X2Fnc/tK/s+Xus+O/g5bvMkMvjT
TtStIIfHnwqN9dbbe0l8ZWOl6TqWg3E8kFt/wmPhnw7aXt7p2k6pqd7F/lxa3oms+GtZ1bw74i0nU9A8QaDqV9o2uaHrVjdaXrGjaxpl1LZalpWq6bexQXun6lp95BNaX1jdww3NrcwywTxRyxso/wBvMlsjmX7w
/wCWsI/ifjGOTwRs6EgqeEFfhR/wU+/4IGfskf8ABR+/1H4oQTXv7Pn7S11aqtx8ZfA2mabqmm+M5LeIW1l/wtbwHNdaTY+M5LSBUt4fEOn6v4Z8YeTDZ2N74i1DSdOstLi/wy/Z0ftF8p+jvlMvBjxnjmVbwrrZ
licy4W4py7DVszxnAWMzOs8RmuBx2VYdTxmP4Xx+MnWzT/hLpYjNMszPEY6pSwGZ0czay79N4u4RqZvU/tHLuRY5QjCvQnJQjiowSjTlGcrRhWhFKHvtQnBQTlBw9/8Ahi/4Icf8FE/hD/wTR/bI1T42/G/4feIP
G3gLxh8JPE/wqvtT8G2Olan408B3Ou+IPCXiK28U6Dpus6lo9nqMMjeFW0DXbKLVtN1A6NrN3dWVxdvaPour4H/BbH/goF8Kv+Ckv7bN38f/AIMfD/XPAfgHRvhh4O+F2mT+LLPS9O8Y+OpfCuo+JtUn8b+KdO0f
UNYsrC+uP+Ekj8N6Xa/2zqlzH4X8M6Abue2uGk0yx+6fjB/wan/8FPfAOsXdv8Nz8CvjroIml/s3VPCnxNtvBuqS2qn922q6J8TbDwlbadfFPmntbDXNctYcgJqU/JC/B/8A4NTv+Cn3j7WLSD4kf8KL+BWgmWI6
lqniv4mW3jLVIrRmxI2laL8MrDxbbajegcwWt/rmh2kxBV9Sg4J/1gh4w/s+afi9W+lfHx84B/1/r8Cx4LqVH4gNy/sKNSnX5lwFz/22szdKlTwzpf2ZbljzrALMHLEv4T+z+K3l6yL+ysV9VWK+sr/ZP+Xtrf71
b2XJdt35+tufktE/m10TRNZ8S6zpPhzw7pOpa/4g1/UrHRtD0PRrG61TWNZ1jVLqKy03StK02yinvNQ1HULyeG0srK0hmubq5miggiklkVT/AKjv/BAv/gmDff8ABN/9kma4+KGn2Vt+0v8AtB3ujeO/jHAk8U03
gvTdNsLqLwH8KRfWu+C6l8G2Oq6tqOv3EEk1t/wmHibxHYWd5qGl6fpd7K7/AIJgf8EC/wBkn/gm/f6d8ULiW/8A2g/2l7W1lSD4yeOtJ03TNN8Fyzwm2vh8KfAcV1q1l4MluoXe3uPEOo6t4m8YpBLeWdl4i0/S
tRvdLl/db589Zfvf34P7mcY6Zxzs6Y+frX+T37Rf9ovlP0iMpj4MeDEcyo+FdHMsNmXFPFOZYWvlmM49xmWV1iMqwOByrEKGMwHC+AxkKOa/8KtHD5pmeaYfAVamAyyjliWY/d8I8I1Mpqf2jmPI8c4ShQoQanHC
xmrTlKovdlXlG9P923CEHJKc3P3P/9k=
"@))
        #endregion
        Break
      }
    }
    $MyDialogPictureBox.Location = New-Object -TypeName System.Drawing.Point($TempLeft, $ControlSpace)
    $MyDialogPictureBox.MinimumSize = $MyDialogPictureBox.Image.Size
    $MyDialogPictureBox.Name = "MyDialogPictureBox"
    $MyDialogPictureBox.Size = $MyDialogPictureBox.Image.Size
    $MyDialogPictureBox.Text = "MyDialogPictureBox"
    #endregion
    $TempLeft = $MyDialogPictureBox.Right + $ControlSpace
  }
  
  #region $MyDialogLabel = System.Windows.Forms.Label
  Write-Verbose -Message "Creating Form Control `$MyDialogLabel"
  $MyDialogLabel = New-Object -TypeName System.Windows.Forms.Label
  $MyDialogPanel.Controls.Add($MyDialogLabel)
  $MyDialogLabel.AutoSize = $False
  $MyDialogLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyDialogLabel.Font = $TempFont.Regular
  $MyDialogLabel.ForeColor = $LabelForegroundColor
  $MyDialogLabel.Location = New-Object -TypeName System.Drawing.Point($TempLeft, $ControlSpace)
  $MyDialogLabel.Name = "MyDialogLabel"
  $TempWidth = [Math]::Ceiling($MessageWidth * $TempFont.Width)
  $TempHeight = [Math]::Ceiling(($Message.Length * $TempFont.Width) / $TempWidth)
  $MyDialogLabel.Size = New-Object -TypeName System.Drawing.Size($TempWidth, [Math]::Max(($TempHeight * $TempFont.Height), $MyDialogPictureBox.Height))
  $MyDialogLabel.Text = $Message
  $MyDialogLabel.TextAlign = $MessageAlignment
  $MyDialogLabel.Width = $TempFont.Width * $MessageWidth
  #endregion
  
  switch ($ResponseButtons)
  {
    "OK" { $ButtonValues = @("OK"); Break }
    "OKCancel" { $ButtonValues = @("OK", "Cancel"); Break }
    "AbortRetryIgnore" { $ButtonValues = @("Abort", "Retry", "Ignore"); Break }
    "YesNoCancel" { $ButtonValues = @("Yes", "No", "Cancel"); Break }
    "YesNo" { $ButtonValues = @("Yes", "No"); Break }
    "RetryCancel" { $ButtonValues = @("Retry", "Cancel"); Break }
  }
  
  $ButtonCount = $ButtonValues.Count
  $TempWidth = [Math]::Floor(($MyDialogLabel.Right - ($ControlSpace * $ButtonCount)) / $ButtonCount)
  $TempMod = ($MyDialogLabel.Right - ($ControlSpace * $ButtonCount)) % $ButtonCount
  $TempLeft = $ControlSpace
  
  For ($Count = 0; $Count -lt $ButtonCount; $Count++)
  {
    #region $MyDialogButton = System.Windows.Forms.Button
    Write-Verbose -Message "Creating Form Control `$MyDialogButton"
    $MyDialogButton = New-Object -TypeName System.Windows.Forms.Button
    $MyDialogPanel.Controls.Add($MyDialogButton)
    $MyDialogButton.AutoSize = $True
    $MyDialogButton.BackColor = $ButtonBackgroundColor
    $MyDialogButton.DialogResult = $ButtonValues[$Count]
    $MyDialogButton.Font = $TempFont.Bold
    $MyDialogButton.ForeColor = $ButtonForegroundColor
    $MyDialogButton.Name = "MyDialogButton$Count"
    $MyDialogButton.Text = $ButtonValues[$Count]
    if ($Count -eq 1 -and $ButtonCount -eq 2)
    {
      $TempLeft += $TempMod
    }
    $MyDialogButton.Location = New-Object -TypeName System.Drawing.Point($TempLeft, ($MyDialogLabel.Bottom + $ControlSpace))
    if ($Count -eq 1 -and $ButtonCount -eq 3)
    {
      $MyDialogButton.Width = $TempWidth + $TempMod
    }
    else
    {
      $MyDialogButton.Width = $TempWidth
    }
    #endregion
    $TempLeft = $MyDialogButton.Right + $ControlSpace
  }
  $MyDialogPanel.Controls["MyDialogButton$(($DefaultButton - 1) % $ButtonCount)"].Select()
  
  $MyDialogPanel.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDialogButton.Right + $ControlSpace), ($MyDialogButton.Bottom + $ControlSpace))
  
  #endregion
  
  $MyDialogForm.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDialogPanel.Right + $BorderSpace), ($MyDialogPanel.Bottom + $BorderSpace))
  
  #endregion
  
  $MyDialogForm.ShowDialog()
  
  Write-Verbose -Message "Exit Function Get-MyResponseDialog"
}
#endregion


