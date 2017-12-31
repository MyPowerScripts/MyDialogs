
#region function Get-MyItemDialog
function Get-MyItemDialog()
{
  <#
    .SYNOPSIS
      Prompts User to Enter a Text Value
    .DESCRIPTION
      Prompts User to Enter a Text Value
    .PARAMETER Title
      Name of the Dialog
    .PARAMETER NoTitle
      Hide Dialog Title Bar
    .PARAMETER ShowBorder
      Show Border around Dialog
    .PARAMETER GroupName
      Name of Return Control Group
    .PARAMETER Prompt
    .PARAMETER PromptAlign
      Prompt Text Alignment
    .PARAMETER ValueLabel
      Name of Value
    .PARAMETER ValueLabelWidth
      Width of ValueLabel Label. A width of 0 ValueLabel will autosize
    .PARAMETER Value
      Initial Default Value
    .PARAMETER MaxLength
      Maximum Length of Text Value
    .PARAMETER ValueWidth
      Width of Value Input TextBox
    .PARAMETER ValidateKeyPress
      Regular Expression to validate KeyPress
    .PARAMETER ValidateValue
      Regular Expression to validate Returned Value
  
      Requires Named Group called "Return"
  
      "^(?<Return>.+)`$"
      "^(?<Return>[\w\.]+)`$"
    .PARAMETER Secure
      Obscure Entered Text
    .PARAMETER ShowReset
      Show Reset Value Button
    .PARAMETER NoCancel
      No Cancel Dialog Button
    .PARAMETER NoEscape
      Don't allow the Esc Button to Cencel the Dialog
    .PARAMETER TopMost
      Show Dialog as the TopMost Form
    .PARAMETER Owner
      Parent Calling Form
    .PARAMETER ControlSpace
      Space between Dialog Form Controls
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
    .PARAMETER GroupForegroundColor
      Dialog Group ForegroundColor
    .PARAMETER LabelForegroundColor
      Dialog Label ForegroundColor
    .PARAMETER TextBackgroundColor
      Dialog Textbox BackgroundColor
    .PARAMETER TextForegroundColor
      Dialog Textbox ForegroundColor
    .EXAMPLE
      Get-MyItemDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "StandAlone")]
  param (
    [Parameter(ParameterSetName = "Dialog")]
    [Parameter(ParameterSetName = "StandAlone")]
    [Parameter(ParameterSetName = "DialogVL")]
    [Parameter(ParameterSetName = "StandAloneVL")]
    [Parameter(ParameterSetName = "DialogWP")]
    [Parameter(ParameterSetName = "StandAloneWP")]
    [String]$Title = "Get-MyItemDialog",
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTVL")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNTVL")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTWP")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNTWP")]
    [Switch]$NoTitle,
    [Parameter(ParameterSetName = "DialogNT")]
    [Parameter(ParameterSetName = "StandAloneNT")]
    [Parameter(ParameterSetName = "DialogNTVL")]
    [Parameter(ParameterSetName = "StandAloneNTVL")]
    [Parameter(ParameterSetName = "DialogNTWP")]
    [Parameter(ParameterSetName = "StandAloneNTWP")]
    [Switch]$ShowBorder,
    [String]$GroupName = "Get MyItem Value",
    [Parameter(Mandatory = $True, ParameterSetName = "DialogWP")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneWP")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTWP")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNTWP")]
    [String]$Prompt,
    [Parameter(ParameterSetName = "DialogWP")]
    [Parameter(ParameterSetName = "StandAloneWP")]
    [Parameter(ParameterSetName = "DialogNTWP")]
    [Parameter(ParameterSetName = "StandAloneNTWP")]
    [System.Drawing.ContentAlignment]$PromptAlign = [System.Drawing.ContentAlignment]::TopLeft,
    [Parameter(Mandatory = $True, ParameterSetName = "DialogVL")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneVL")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTVL")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNTVL")]
    [String]$ValueLabel,
    [Parameter(ParameterSetName = "DialogVL")]
    [Parameter(ParameterSetName = "StandAloneVL")]
    [Parameter(ParameterSetName = "DialogNTVL")]
    [Parameter(ParameterSetName = "StandAloneNTVL")]
    [ValidateRange(0, 50)]
    [Int]$ValueLabelWidth = 0,
    [String]$Value,
    [ValidateRange(1, 32767)]
    [Int]$MaxLength = 50,
    [ValidateRange(25, 100)]
    [Int]$ValueWidth = 35,
    [String]$ValidateKeyPress = ".",
    [String]$ValidateValue = "^(?<Return>.+)`$",
    [Switch]$Secure,
    [Switch]$ShowReset,
    [Switch]$NoCancel,
    [Switch]$NoEscape,
    [Parameter(ParameterSetName = "StandAlone")]
    [Parameter(ParameterSetName = "StandAloneNT")]
    [Parameter(ParameterSetName = "StandAloneVL")]
    [Parameter(ParameterSetName = "StandAloneWP")]
    [Parameter(ParameterSetName = "StandAloneNTVL")]
    [Parameter(ParameterSetName = "StandAloneNTWP")]
    [Switch]$TopMost,
    [Parameter(Mandatory = $True, ParameterSetName = "Dialog")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogVL")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogWP")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTVL")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTWP")]
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
    [System.Drawing.Color]$GroupForegroundColor = $Script:MyDialogDefaults.GroupForegroundColor,
    [System.Drawing.Color]$LabelForegroundColor = $Script:MyDialogDefaults.LabelForegroundColor,
    [System.Drawing.Color]$TextBackgroundColor = $Script:MyDialogDefaults.TextBackgroundColor,
    [System.Drawing.Color]$TextForegroundColor = $Script:MyDialogDefaults.TextForegroundColor
  )
  Write-Verbose -Message "Enter Function Get-MyItemDialog"
  
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
  if ($NoTitle.IsPresent)
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
  if ($PSBoundParameters.ContainsKey("Owner"))
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
    $MyDialogForm.TopMost = $TopMost.IsPresent
  }
  $MyDialogForm.ShowIcon = $False
  $MyDialogForm.Tag = $Value
  $MyDialogForm.Text = $Title
  #endregion
  
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
  if ((-not $NoCancel.IsPresent) -or (-not $NoEscape.IsPresent))
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
  
  #region $MyDialogGroupBox = System.Windows.Forms.GroupBox
  Write-Verbose -Message "Creating Form Control `$MyDialogGroupBox"
  $MyDialogGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
  $MyDialogPanel.Controls.Add($MyDialogGroupBox)
  $MyDialogGroupBox.Font = $TempFont.Bold
  $MyDialogGroupBox.ForeColor = $GroupForegroundColor
  $MyDialogGroupBox.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, $ControlSpace)
  $MyDialogGroupBox.Name = "MyDialogGroupBox"
  $MyDialogGroupBox.Text = $GroupName
  #endregion
  
  #region ******** $MyDialogGroupBox Controls ********
  
  if ($PSBoundParameters.ContainsKey("ValueLabel"))
  {
    $TempValueLabelWidth = [Math]::Max($ValueLabelWidth, ($ValueLabel.Length + 2))
  }
  else
  {
    $TempValueLabelWidth = 0
  }
  
  $TempBottom = $TempFont.Height
  if ($PSBoundParameters.ContainsKey("Prompt"))
  {
    #region $MyDialogPromptLabel = System.Windows.Forms.Label
    Write-Verbose -Message "Creating Form Control `$MyDialogPromptLabel"
    $MyDialogPromptLabel = New-Object -TypeName System.Windows.Forms.Label
    $MyDialogGroupBox.Controls.Add($MyDialogPromptLabel)
    $MyDialogPromptLabel.AutoSize = $False
    $MyDialogPromptLabel.Font = $TempFont.Regular
    $MyDialogPromptLabel.ForeColor = $LabelForegroundColor
    $MyDialogPromptLabel.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, ($TempFont.Height + $ControlSpace))
    $MyDialogPromptLabel.Name = "MyDialogPromptLabel"
    $TempWidth = [Math]::Ceiling(($TempValueLabelWidth + $ValueWidth) * $TempFont.Width)
    $TempHeight = [Math]::Ceiling(($Prompt.Length * $TempFont.Width) / $TempWidth)
    $MyDialogPromptLabel.Size = New-Object -TypeName System.Drawing.Size($TempWidth, ($TempHeight * $TempFont.Height))
    $MyDialogPromptLabel.Text = "$($Prompt)"
    $MyDialogPromptLabel.TextAlign = $PromptAlign
    #endregion
    $TempBottom = $MyDialogPromptLabel.Bottom + ($ControlSpace * 2)
  }
  
  $TempLeft = $ControlSpace
  if ($PSBoundParameters.ContainsKey("ValueLabel"))
  {
    #region $MyDialogValueLabel = System.Windows.Forms.Label
    Write-Verbose -Message "Creating Form Control `$MyDialogValueLabel"
    $MyDialogValueLabel = New-Object -TypeName System.Windows.Forms.Label
    $MyDialogGroupBox.Controls.Add($MyDialogValueLabel)
    $MyDialogValueLabel.AutoSize = $True
    $MyDialogValueLabel.Font = $TempFont.Regular
    $MyDialogValueLabel.ForeColor = $LabelForegroundColor
    $MyDialogValueLabel.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, $TempBottom)
    $MyDialogValueLabel.Name = "MyDialogValueLabel"
    $MyDialogValueLabel.Text = "$($ValueLabel):"
    $MyDialogValueLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
    #endregion
    $TempHeight = $MyDialogValueLabel.Height
    $MyDialogValueLabel.AutoSize = $False
    $MyDialogValueLabel.Size = New-Object -TypeName System.Drawing.Size(([Math]::Ceiling($TempValueLabelWidth * $TempFont.Width)), $TempHeight)
    $TempLeft = $MyDialogValueLabel.Right + $ControlSpace
  }
  
  #region $MyDialogValueTextBox = System.Windows.Forms.TextBox
  Write-Verbose -Message "Creating Form Control `$MyDialogValueTextBox"
  $MyDialogValueTextBox = New-Object -TypeName System.Windows.Forms.TextBox
  $MyDialogGroupBox.Controls.Add($MyDialogValueTextBox)
  $MyDialogValueTextBox.BackColor = $TextBackgroundColor
  $MyDialogValueTextBox.Font = $TempFont.Regular
  $MyDialogValueTextBox.ForeColor = $TextForegroundColor
  $MyDialogValueTextBox.Location = New-Object -TypeName System.Drawing.Point($TempLeft, $TempBottom)
  $MyDialogValueTextBox.MaxLength = $MaxLength
  $MyDialogValueTextBox.Name = "MyDialogValueTextBox"
  if ($Secure.IsPresent)
  {
    $MyDialogValueTextBox.PasswordChar = "*"
  }
  $MyDialogValueTextBox.SelectedText = ""
  $MyDialogValueTextBox.SelectionLength = 0
  $MyDialogValueTextBox.SelectionStart = 0
  $MyDialogValueTextBox.Text = $Value
  $MyDialogValueTextBox.Width = [Math]::Ceiling($ValueWidth * $TempFont.Width)
  #endregion
  
  #region function Start-MyDialogValueTextBoxKeyPress
  function Start-MyDialogValueTextBoxKeyPress()
  {
  <#
    .SYNOPSIS
      KeyPress event for the MyDialogValueTextBox Control
    .DESCRIPTION
      KeyPress event for the MyDialogValueTextBox Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDialogValueTextBoxKeyPress -Sender $Sender -EventArg $EventArg
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
    [CmdletBinding()]
    param (
      [parameter(Mandatory = $True)]
      [Object]$Sender,
      [parameter(Mandatory = $True)]
      [Object]$EventArg,
      [Switch]$Validate
    )
    Write-Verbose -Message "Enter KeyPress Event for `$MyDialogValueTextBox"
    
    if ([INT]($EventArg.KeyChar) -eq 13)
    {
      $EventArg.Handled = $True
      Start-MyDialogOKButtonClick -Sender $Sender -EventArg $EventArg
    }
    elseif ($Validate.IsPresent)
    {
      if ((-not ([RegEx]::Match($EventArg.KeyChar, $ValidateKeyPress)).Success) -and (([INT]($EventArg.KeyChar) -ne 8)))
      {
        $EventArg.Handled = $True
      }
    }
    
    Write-Verbose -Message "Exit KeyPress Event for `$MyDialogValueTextBox"
  }
  #endregion
  if ($PSBoundParameters.ContainsKey("ValidateKeyPress"))
  {
    $MyDialogValueTextBox.add_KeyPress({ Start-MyDialogValueTextBoxKeyPress -Sender $This -EventArg $PSItem -Validate })
  }
  else
  {
    $MyDialogValueTextBox.add_KeyPress({ Start-MyDialogValueTextBoxKeyPress -Sender $This -EventArg $PSItem })
  }
  
  $MyDialogGroupBox.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDialogValueTextBox.Right + $ControlSpace), ($MyDialogValueTextBox.Bottom + $ControlSpace))
  
  #endregion
  
  $TempWidth = [Math]::Floor(($MyDialogGroupBox.Width - ($ControlSpace * 2)) / 3)
  $TempMod = ($MyDialogGroupBox.Width - ($ControlSpace * 2)) % 3
  
  #region $MyDialogOKButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDialogOKButton"
  $MyDialogOKButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDialogPanel.Controls.Add($MyDialogOKButton)
  $MyDialogOKButton.AutoSize = $True
  $MyDialogOKButton.BackColor = $ButtonBackgroundColor
  $MyDialogOKButton.Font = $TempFont.Bold
  $MyDialogOKButton.ForeColor = $ButtonForegroundColor
  $MyDialogOKButton.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, ($MyDialogGroupBox.Bottom + $ControlSpace))
  $MyDialogOKButton.Name = "MyDialogOKButton"
  $MyDialogOKButton.Text = "OK"
  $MyDialogOKButton.Width = $TempWidth
  #endregion
  
  #region function Start-MyDialogOKButtonClick
  function Start-MyDialogOKButtonClick()
  {
  <#
    .SYNOPSIS
      Click event for the MyDialogOKButton Control
    .DESCRIPTION
      Click event for the MyDialogOKButton Control
    .PARAMETER Sender
       The Form Control that fired the Event
    .PARAMETER EventArg
       The Event Arguments for the Event
    .EXAMPLE
       Start-MyDialogOKButtonClick -Sender $Sender -EventArg $EventArg
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
    Write-Verbose -Message "Enter Click Event for `$MyDialogOKButton"
    
    if (-not [String]::IsNullOrEmpty($MyDialogValueTextBox.Text))
    {
      if (($Match = [RegEx]::Match($MyDialogValueTextBox.Text, $ValidateValue)).Groups["Return"].Success)
      {
        $MyDialogForm.Tag = $Match.Groups["Return"].Value
        $MyDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
      }
    }
    
    Write-Verbose -Message "Exit Click Event for `$MyDialogOKButton"
  }
  #endregion
  $MyDialogOKButton.add_Click({ Start-MyDialogOKButtonClick -Sender $This -EventArg $PSItem })
  
  if ($ShowReset.IsPresent)
  {
    #region $MyDialogResetButton = System.Windows.Forms.Button
    Write-Verbose -Message "Creating Form Control `$MyDialogResetButton"
    $MyDialogResetButton = New-Object -TypeName System.Windows.Forms.Button
    $MyDialogPanel.Controls.Add($MyDialogResetButton)
    $MyDialogResetButton.AutoSize = $True
    $MyDialogResetButton.BackColor = $ButtonBackgroundColor
    $MyDialogResetButton.Font = $TempFont.Bold
    $MyDialogResetButton.ForeColor = $ButtonForegroundColor
    $MyDialogResetButton.Location = New-Object -TypeName System.Drawing.Point(($MyDialogOKButton.Right + $ControlSpace), $MyDialogOKButton.Top)
    $MyDialogResetButton.Name = "MyDialogResetButton"
    $MyDialogResetButton.Text = "Reset"
    $MyDialogResetButton.Width = $TempWidth + $TempMod
    #endregion
    
    #region function Start-MyDialogResetButtonClick
    function Start-MyDialogResetButtonClick()
    {
    <#
      .SYNOPSIS
        Click event for the MyDialogResetButton Control
      .DESCRIPTION
        Click event for the MyDialogResetButton Control
      .PARAMETER Sender
         The Form Control that fired the Event
      .PARAMETER EventArg
         The Event Arguments for the Event
      .EXAMPLE
         Start-MyDialogResetButtonClick -Sender $Sender -EventArg $EventArg
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
      Write-Verbose -Message "Enter Click Event for `$MyDialogResetButton"
      
      $MyDialogValueTextBox.Text = $MyDialogForm.Tag
      
      Write-Verbose -Message "Exit Click Event for `$MyDialogResetButton"
    }
    #endregion
    $MyDialogResetButton.add_Click({ Start-MyDialogResetButtonClick -Sender $This -EventArg $PSItem })
  }
  
  #region $MyDialogCancelButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDialogCancelButton"
  $MyDialogCancelButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDialogPanel.Controls.Add($MyDialogCancelButton)
  $MyDialogCancelButton.AutoSize = $True
  $MyDialogCancelButton.BackColor = $ButtonBackgroundColor
  $MyDialogCancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $MyDialogCancelButton.Enabled = (-not $NoCancel.IsPresent)
  $MyDialogCancelButton.Font = $TempFont.Bold
  $MyDialogCancelButton.ForeColor = $ButtonForegroundColor
  $MyDialogCancelButton.Location = New-Object -TypeName System.Drawing.Point(((($TempWidth + $ControlSpace) * 2) + $TempMod), $MyDialogOKButton.Top)
  $MyDialogCancelButton.Name = "MyDialogCancelButton"
  $MyDialogCancelButton.Text = "Cancel"
  $MyDialogCancelButton.Width = $MyDialogOKButton.Width
  #endregion
  
  $MyDialogPanel.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDialogCancelButton.Right + $ControlSpace), ($MyDialogCancelButton.Bottom + $ControlSpace))
  
  #endregion
  
  $MyDialogForm.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDialogPanel.Right + $BorderSpace), ($MyDialogPanel.Bottom + $BorderSpace))
  
  #endregion
  
  $ReturnValue = [PSCustomObject]@{
    "ShowDialog" = $MyDialogForm.ShowDialog()
    "Value" = $Null
  }
  if ($ReturnValue.ShowDialog -eq [System.Windows.Forms.DialogResult]::OK)
  {
    $ReturnValue.Value = $MyDialogForm.Tag
  }
  $ReturnValue
  
  Write-Verbose -Message "Exit Function Get-MyItemDialog"
}
#endregion
