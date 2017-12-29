
#region function Show-MyAboutDialog
function Show-MyAboutDialog()
{
  <#
    .SYNOPSIS
      Function to do something specific
    .DESCRIPTION
      Function to do something specific
    .PARAMETER  Title
      Title Bar Text of the Help-About Dialog
    .PARAMETER NoTitle
      Hide Help-About Dialog Title Bar
    .PARAMETER Image
      Base64 Encoded Image to show on the Help-About Dialog
    .PARAMETER Message
      Message to show on the Help-About Dialog
    .PARAMETER Width
      Width of Help-About Dialog Text
    .PARAMETER TextAlignment
      Alignment of the About-Help Text
    .PARAMETER TopMost
      Display Help-About Dialog as the Top Most Window
    .PARAMETER ScriptBlock
      Easter Egg ScriptBlock to Execute when user DoubleClicks on the Image
    .PARAMETER Owner
      Parent Calling Application Form
    .PARAMETER ControlSpace
      Space between Form Controls
    .PARAMETER FontFamily
      Help-About Dialog Text Font Family
    .PARAMETER FontSize
      Help-About Dialog Text Font Size
    .PARAMETER BackgroundColor
      Help-About Dialog Form BackgroundColor
    .PARAMETER ForegroundColor
      Help-About Dialog Form ForegroundColor
    .PARAMETER ButtonBackgroundColor
      Help-About Dialog Button BackgroundColor
    .PARAMETER ButtonForegroundColor
      Help-About Dialog Button ForegroundColor
    .PARAMETER LabelForegroundColor
      Help-About Dialog Label ForegroundColor
    .EXAMPLE
      Show-MyAboutDialog -Title "Help-About" -Message "Application Name`n`r`n`rVersion`n`r`n`rby`n`r`n`rAuthor"
    .EXAMPLE
      Show-MyAboutDialog -NoTitle -Message "Application Name`n`r`n`rVersion`n`r`n`rby`n`r`n`rAuthor" -Owner $CallingForm
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "StandAlone")]
  param (
    [Parameter(ParameterSetName = "Dialog")]
    [Parameter(ParameterSetName = "StandAlone")]
    [String]$Title = "Help-About",
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNT")]
    [Switch]$NoTitle,
    [String]$Image,
    [String]$Message = "Application Name`n`r`n`rVersion`n`r`n`rby`n`r`n`rAuthor",
    [ValidateRange(20, 60)]
    [Int]$Width = 30,
    [System.Drawing.ContentAlignment]$TextAlignment = [System.Drawing.ContentAlignment]::MiddleCenter,
    [Parameter(ParameterSetName = "StandAlone")]
    [Parameter(ParameterSetName = "StandAloneNT")]
    [Switch]$TopMost,
    [ScriptBlock]$ScriptBlock,
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
  Write-Verbose -Message "Enter Function Show-MyAboutDialog"
  
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
  $MyDialogForm.BackColor = $BackgroundColor
  $MyDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $MyDialogForm.Font = $TempFont.Bold
  $MyDialogForm.ForeColor = $ForegroundColor
  if ($NoTitle)
  {
    $MyDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
  }
  else
  {
    $MyDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
  }
  $MyDialogForm.KeyPreview = $True
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
  $MyDialogForm.add_KeyDown({ Start-MyDialogFormKeyDown -Sender $This -EventArg $PSItem })
  
  #region ******** $MyDialogForm Controls ********
  
  #region $MyDialogPictureBox = System.Windows.Forms.PictureBox
  Write-Verbose -Message "Creating Form Control `$MyDialogPictureBox"
  $MyDialogPictureBox = New-Object -TypeName System.Windows.Forms.PictureBox
  $MyDialogForm.Controls.Add($MyDialogPictureBox)
  $MyDialogPictureBox.AutoSize = $True
  $MyDialogPictureBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  if ($PSBoundParameters.ContainsKey("Image"))
  {
    $MyDialogPictureBox.Image = [System.Drawing.Image]([System.Convert]::FromBase64String($Image))
  }
  else
  {
    #region Set Default about Image
    $MyDialogPictureBox.Image = [System.Drawing.Image]([System.Convert]::FromBase64String(@"
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
W3tbO0gWC3to1GFREUBVUAYAAAAqr448CaH8TfCl9oPiTRtK8QaHqUflXmnalaR3VrdJkHbJFICrDIBwQela1FaSSkrS1ueZGpKMueLs1rfrfufH/iP/AIIG/si+KfEUmqXXwb0uK5kfzClnrOp2duDnPEENysQH
sFxjjGK+g/gD+y58Of2V/DEmj/DnwV4c8G6fcFTcJpdkkL3bKCFaaQDfKwBIDSMxwetd7RWdOlCmrU0l6Kx6GMzrMMXBUsVXnOK2UpSkvubYV8xftCf8EbP2bf2qvjFqnj/x78OP7e8Xa0YTe3//AAkGqWvneTEk
Mf7uG5SNcRxovyqM4yckkn6doqnCLkpNarZ9vQywOZYvBTdTB1ZU5NWbjJxbV07NprS6Tt3SGxoIo1VeFUYA9qdRRVHElZWQUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQA
UUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAH/2Q==
"@))
    #endregion    
  }
  $MyDialogPictureBox.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, $ControlSpace)
  $MyDialogPictureBox.MinimumSize = $MyDialogPictureBox.Image.Size
  $MyDialogPictureBox.Name = "MyDialogPictureBox"
  $MyDialogPictureBox.Size = $MyDialogPictureBox.Image.Size
  $MyDialogPictureBox.Text = "MyDialogPictureBox"
  #endregion
  
  #region function Start-MyDialogPictureBoxDoubleClick
  function Start-MyDialogPictureBoxDoubleClick()
  {
  <#
    .SYNOPSIS
      DoubleClick event for the MyDialogPictureBox Control
    .DESCRIPTION
      DoubleClick event for the MyDialogPictureBox Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDialogPictureBoxDoubleClick -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter DoubleClick Event for `$MyDialogPictureBox"
    
    Try
    {
      $ScriptBlock.Invoke()
      
      [System.GC]::Collect()
      [System.GC]::WaitForPendingFinalizers()
    }
    Catch
    {
    }
    
    Write-Verbose -Message "Exit DoubleClick Event for `$MyDialogPictureBox"
  }
  #endregion
  if ($PSBoundParameters.ContainsKey("ScriptBlock"))
  {
    $MyDialogPictureBox.add_DoubleClick({ Start-MyDialogPictureBoxDoubleClick -Sender $This -EventArg $PSItem })
  }
  
  #region $MyDialogLabel = System.Windows.Forms.Label
  Write-Verbose -Message "Creating Form Control `$MyDialogLabel"
  $MyDialogLabel = New-Object -TypeName System.Windows.Forms.Label
  $MyDialogForm.Controls.Add($MyDialogLabel)
  $MyDialogLabel.AutoSize = $False
  $MyDialogLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $MyDialogLabel.Font = $TempFont.Regular
  $MyDialogLabel.ForeColor = $LabelForegroundColor
  $MyDialogLabel.Location = New-Object -TypeName System.Drawing.Point(($MyDialogPictureBox.Right + $ControlSpace), $ControlSpace)
  $MyDialogLabel.Name = "MyDialogLabel"
  $MyDialogLabel.Text = $Message
  $MyDialogLabel.TextAlign = $TextAlignment
  $MyDialogLabel.Width = $TempFont.Width * $Width
  #endregion
  
  #region $MyDialog01Button = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDialog01Button"
  $MyDialog01Button = New-Object -TypeName System.Windows.Forms.Button
  $MyDialogForm.Controls.Add($MyDialog01Button)
  $MyDialog01Button.AutoSize = $True
  $MyDialog01Button.BackColor = $ButtonBackgroundColor
  $MyDialog01Button.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $MyDialog01Button.Font = New-Object -TypeName System.Drawing.Font($FontFamily, $FontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
  $MyDialog01Button.ForeColor = $ButtonForegroundColor
  $MyDialog01Button.Name = "MyDialog01Button"
  $MyDialog01Button.Text = "OK"
  if ($MyDialogPictureBox.Height -lt (($MyDialog01Button.Height + $ControlSpace) * 4))
  {
    $MyDialog01Button.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, ($MyDialogPictureBox.Bottom + $ControlSpace))
  }
  else
  {
    $MyDialog01Button.Location = New-Object -TypeName System.Drawing.Point(($MyDialogPictureBox.Right + $ControlSpace), ($MyDialogPictureBox.Bottom - $MyDialog01Button.Height))
  }
  $MyDialog01Button.Width = $MyDialogLabel.Right - $MyDialog01Button.Left
  #endregion
  
  $MyDialogLabel.Height = $MyDialogPictureBox.Height - ($MyDialog01Button.Height + $ControlSpace)
  
  $MyDialogForm.ClientSize = New-Object -TypeName System.Drawing.Size(($($MyDialogForm.Controls[$MyDialogForm.Controls.Count - 1]).Right + $ControlSpace), ($($MyDialogForm.Controls[$MyDialogForm.Controls.Count - 1]).Bottom + $ControlSpace))
  
  #endregion
  
  [Void]$MyDialogForm.ShowDialog()
  
  Write-Verbose -Message "Exit Function Show-MyAboutDialog"
}
#endregion
