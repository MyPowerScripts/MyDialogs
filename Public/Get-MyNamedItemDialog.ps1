
#region function Get-MyNamedItemDialog
function Get-MyNamedItemDialog()
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
    .PARAMETER GroupName
      Name of Return Control Group
    .PARAMETER ValueNameWidth
      With of ValueName Label. A width of 0 ValueName will autosize
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
    .PARAMETER ShowReset
      Show Reset Value Button
    .PARAMETER NoCancel
      No Cancel Dialog Button
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
      Get-MyNamedItemDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "StandAlone")]
  param (
    [Parameter(ParameterSetName = "Dialog")]
    [Parameter(ParameterSetName = "StandAlone")]
    [String]$Title = "Get-MyNamedItemDialog",
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNT")]
    [Switch]$NoTitle,
    [String]$GroupName = "Get MyItem Value",
    [ValidateRange(0, 50)]
    [Int]$ValueNameWidth = 0,
    [Parameter(Mandatory = $True)]
    [System.Collections.Specialized.OrderedDictionary]$Value,
    [ValidateRange(1, 32767)]
    [Int]$MaxLength = 50,
    [ValidateRange(25, 100)]
    [Int]$ValueWidth = 35,
    [String]$ValidateKeyPress = ".",
    [String]$ValidateValue = "^(?<Return>.+)`$",
    [Switch]$ShowReset,
    [Switch]$NoCancel,
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
    [System.Drawing.Color]$GroupForegroundColor = $Script:MyDialogDefaults.GroupForegroundColor,
    [System.Drawing.Color]$LabelForegroundColor = $Script:MyDialogDefaults.LabelForegroundColor,
    [System.Drawing.Color]$TextBackgroundColor = $Script:MyDialogDefaults.TextBackgroundColor,
    [System.Drawing.Color]$TextForegroundColor = $Script:MyDialogDefaults.TextForegroundColor
  )
  Write-Verbose -Message "Enter Function Get-MyNamedItemDialog"
  
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
    $MyDialogForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow
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
  if (-not $NoCancel.IsPresent)
  {
    $MyDialogForm.add_KeyDown({ Start-MyDialogFormKeyDown -Sender $This -EventArg $PSItem })
  }
  
  #region ******** $MyDialogForm Controls ********
  
  #region $MyDialogReturnGroupBox = System.Windows.Forms.GroupBox
  Write-Verbose -Message "Creating Form Control `$MyDialogReturnGroupBox"
  $MyDialogReturnGroupBox = New-Object -TypeName System.Windows.Forms.GroupBox
  $MyDialogForm.Controls.Add($MyDialogReturnGroupBox)
  #$MyDialogReturnGroupBox.BackColor = $MyDialogColor.BackColor
  $MyDialogReturnGroupBox.Font = $TempFont.Bold
  $MyDialogReturnGroupBox.ForeColor = $GroupForegroundColor
  #$MyDialogReturnGroupBox.Height = 100
  $MyDialogReturnGroupBox.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, $ControlSpace)
  $MyDialogReturnGroupBox.Name = "MyDialogReturnGroupBox"
  #$MyDialogReturnGroupBox.Size = New-Object -TypeName System.Drawing.Size(200, 100)
  #$MyDialogReturnGroupBox.TabIndex = 0
  #$MyDialogReturnGroupBox.TabStop = $False
  #$MyDialogReturnGroupBox.Tag = $Null
  $MyDialogReturnGroupBox.Text = $GroupName
  #$MyDialogReturnGroupBox.Width = 200
  #endregion
  
  #region ******** $MyDialogReturnGroupBox Controls ********
  
  $TempValueNameWidth = [Math]::Max($ValueNameWidth, (($Value.Keys | Sort-Object -Property Length -Descending | Select-Object -ExpandProperty Length -Unique -First 1) + 2))
  
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
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyPress Event for `$MyDialogValueTextBox"
    
    if ((-not ([RegEx]::Match($EventArg.KeyChar, $ValidateKeyPress)).Success) -and (([INT]($EventArg.KeyChar) -ne 8)))
    {
      $EventArg.Handled = $True
    }
    
    Write-Verbose -Message "Exit KeyPress Event for `$MyDialogValueTextBox"
  }
  #endregion
  
  $TempBottom = $TempFont.Height
  ForEach ($Key in $Value.Keys)
  {
    #region $MyDialogValueLabel = System.Windows.Forms.Label
    Write-Verbose -Message "Creating Form Control `$MyDialogValueLabel"
    $MyDialogValueLabel = New-Object -TypeName System.Windows.Forms.Label
    $MyDialogReturnGroupBox.Controls.Add($MyDialogValueLabel)
    $MyDialogValueLabel.AutoSize = $True
    $MyDialogValueLabel.Font = $TempFont.Regular
    $MyDialogValueLabel.ForeColor = $LabelForegroundColor
    $MyDialogValueLabel.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, $TempBottom)
    $MyDialogValueLabel.Name = "MyDialogValueLabel"
    $MyDialogValueLabel.Text = "$($Key):"
    $MyDialogValueLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
    #$MyDialogValueLabel.Width = 100
    #endregion
    $TempHeight = $MyDialogValueLabel.Height
    $MyDialogValueLabel.AutoSize = $False
    $MyDialogValueLabel.Size = New-Object -TypeName System.Drawing.Size(([Math]::Ceiling($TempValueNameWidth * $TempFont.Width)), $TempHeight)
    
    $TempBottom = $MyDialogValueLabel.Bottom + $ControlSpace
    
    #region $MyDialogValueTextBox = System.Windows.Forms.TextBox
    Write-Verbose -Message "Creating Form Control `$MyDialogValueTextBox"
    $MyDialogValueTextBox = New-Object -TypeName System.Windows.Forms.TextBox
    $MyDialogReturnGroupBox.Controls.Add($MyDialogValueTextBox)
    $MyDialogValueTextBox.BackColor = $TextBackgroundColor
    $MyDialogValueTextBox.Font = $TempFont.Regular
    $MyDialogValueTextBox.ForeColor = $TextForegroundColor
    $MyDialogValueTextBox.Location = New-Object -TypeName System.Drawing.Point(($MyDialogValueLabel.Right + $ControlSpace), $MyDialogValueLabel.Top)
    $MyDialogValueTextBox.MaxLength = $MaxLength
    $MyDialogValueTextBox.Name = $Key
    $MyDialogValueTextBox.SelectedText = ""
    $MyDialogValueTextBox.SelectionLength = 0
    $MyDialogValueTextBox.SelectionStart = 0
    $MyDialogValueTextBox.Text = $Value[$Key]
    $MyDialogValueTextBox.Width = [Math]::Ceiling($ValueWidth * $TempFont.Width)
    #endregion
    
    if ($PSBoundParameters.ContainsKey("ValidateKeyPress"))
    {
      $MyDialogValueTextBox.add_KeyPress({ Start-MyDialogValueTextBoxKeyPress -Sender $This -EventArg $PSItem })
    }
  }
    
  $MyDialogReturnGroupBox.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDialogValueTextBox.Right + $ControlSpace), ($MyDialogValueTextBox.Bottom + $ControlSpace))
  
  #endregion
  
  $TempWidth = [Math]::Floor(($MyDialogReturnGroupBox.Width - $ControlSpace) / 3)
  $TempMod = ($MyDialogReturnGroupBox.Width - $ControlSpace) % $TempWidth
  
  #region $MyDialogOKButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDialogOKButton"
  $MyDialogOKButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDialogForm.Controls.Add($MyDialogOKButton)
  $MyDialogOKButton.AutoSize = $True
  $MyDialogOKButton.BackColor = $ButtonBackgroundColor
  $MyDialogOKButton.Font = $TempFont.Bold
  $MyDialogOKButton.ForeColor = $ButtonForegroundColor
  $MyDialogOKButton.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, ($MyDialogReturnGroupBox.Bottom + $ControlSpace))
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
    
    $ReturnValue = [Ordered]@{}
    foreach ($Key in $MyDialogForm.Tag.Keys)
    {
      if (($Match = [RegEx]::Match($MyDialogReturnGroupBox.Controls[$Key].Text, $ValidateValue)).Groups["Return"].Success)
      {
        $ReturnValue.Add($Key, $Match.Groups["Return"].Value)
      }
    }
    
    if (@($ReturnValue.Keys).Count -eq @($MyDialogForm.Tag.Keys).Count)
    {
      $MyDialogForm.Tag = $ReturnValue
      $MyDialogForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
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
    $MyDialogForm.Controls.Add($MyDialogResetButton)
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
      
      ForEach ($Key in $MyDialogForm.Tag.Keys)
      {
        $MyDialogReturnGroupBox.Controls[$Key].Text = $MyDialogForm.Tag[$Key]
      }
      
      Write-Verbose -Message "Exit Click Event for `$MyDialogResetButton"
    }
    #endregion
    $MyDialogResetButton.add_Click({ Start-MyDialogResetButtonClick -Sender $This -EventArg $PSItem })
  }
  
  #region $MyDialogCancelButton = System.Windows.Forms.Button
  Write-Verbose -Message "Creating Form Control `$MyDialogCancelButton"
  $MyDialogCancelButton = New-Object -TypeName System.Windows.Forms.Button
  $MyDialogForm.Controls.Add($MyDialogCancelButton)
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
  
  $MyDialogForm.ClientSize = New-Object -TypeName System.Drawing.Size(($MyDialogCancelButton.Right + $ControlSpace), ($MyDialogCancelButton.Bottom + $ControlSpace))
  
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
  
  Write-Verbose -Message "Exit Function Get-MyNamedItemDialog"
}
#endregion
