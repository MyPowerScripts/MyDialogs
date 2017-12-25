
#region function Get-MyItemListDialog
function Get-MyItemListDialog()
{
  <#
    .SYNOPSIS
      Prompts User to Enter a list of Text Values
    .DESCRIPTION
      Prompts User to Enter a list of Text Values
    .PARAMETER Title
      Name of the Dialog
    .PARAMETER NoTitle
      Hide Dialog Title Bar
    .PARAMETER GroupName
      Name of Return Control Group
    .PARAMETER Value
      Initial Default list of Values
    .PARAMETER MaxLength
      Maximum Length of Text Value
    .PARAMETER ValueWidth
      Width of Value Input TextBox
    .PARAMETER ValueHeight
      Hight of Value Input TextBox
    .PARAMETER ValidateKeyPress
      Regular Expression to validate KeyPress
    .PARAMETER ValidateValue
      Regular Expression to validate Returned Values
  
      Requires Named Group called "Return"
  
      "[^\s]?(?<Return>.+)[`$\s]?"
      "(?<Return>[\w\.]+)"
      "[^\s]?(?<Return>[\w\.]+)[`$,;\s]?"
  
    .PARAMETER AllowDuplicates
      Allow Duplicate Values to be Returned
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
      Get-MyItemListDialog -Value "String"
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding(DefaultParameterSetName = "StandAlone")]
  param (
    [Parameter(ParameterSetName = "Dialog")]
    [Parameter(ParameterSetName = "DialogVN")]
    [Parameter(ParameterSetName = "StandAlone")]
    [Parameter(ParameterSetName = "StandAloneVN")]
    [String]$Title = "Get-MyItemListDialog",
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTVN")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "StandAloneNTVN")]
    [Switch]$NoTitle,
    [String]$GroupName = "Get MyItem Value",
    [String[]]$Value,
    [ValidateRange(1, 65534)]
    [Int]$MaxLength = 32767,
    [ValidateRange(25, 100)]
    [Int]$ValueWidth = 35,
    [ValidateRange(4, 25)]
    [Int]$ValueHeight = 10,
    [String]$ValidateKeyPress = ".",
    [String]$ValidateValue = "(?<Return>[.]+)",
    [Switch]$AllowDuplicates,
    [Switch]$ShowReset,
    [Switch]$NoCancel,
    [Parameter(ParameterSetName = "StandAlone")]
    [Parameter(ParameterSetName = "StandAloneNT")]
    [Parameter(ParameterSetName = "StandAloneVN")]
    [Parameter(ParameterSetName = "StandAloneNTVN")]
    [Switch]$TopMost,
    [Parameter(Mandatory = $True, ParameterSetName = "Dialog")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNT")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogVN")]
    [Parameter(Mandatory = $True, ParameterSetName = "DialogNTVN")]
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
  Write-Verbose -Message "Enter Function Get-MyItemListDialog"
  
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
    $MyDialogForm.TopMost = $TopMost.IsPresent
  }
  $MyDialogForm.ShowIcon = $False
  $MyDialogForm.Tag = $Tag
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
  # Location of First Control New-Object -TypeName System.Drawing.Point($ControlSpace, ([System.Math]::Ceiling($MyDialogReturnGroupBox.CreateGraphics().MeasureString($MyDialogReturnGroupBox.Text, $MyDialogReturnGroupBox.Font).Height + ($ControlSpace / 2))))
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
  
  #region $MyDialogValueTextBox = System.Windows.Forms.TextBox
  Write-Verbose -Message "Creating Form Control `$MyDialogValueTextBox"
  $MyDialogValueTextBox = New-Object -TypeName System.Windows.Forms.TextBox
  $MyDialogReturnGroupBox.Controls.Add($MyDialogValueTextBox)
  $MyDialogValueTextBox.AcceptsReturn = $MultiLine
  $MyDialogValueTextBox.BackColor = $TextBackgroundColor
  $MyDialogValueTextBox.Font = $TempFont.Regular
  $MyDialogValueTextBox.ForeColor = $TextForegroundColor
  $MyDialogValueTextBox.Location = New-Object -TypeName System.Drawing.Point($ControlSpace, $TempFont.Height)
  $MyDialogValueTextBox.MaxLength = $MaxLength
  $MyDialogValueTextBox.Multiline = $True
  $MyDialogValueTextBox.Name = "MyDialogValueTextBox"
  $MyDialogValueTextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
  $MyDialogValueTextBox.SelectedText = ""
  $MyDialogValueTextBox.SelectionLength = 0
  $MyDialogValueTextBox.SelectionStart = 0
  $MyDialogValueTextBox.Size = New-Object -TypeName System.Drawing.Size(([Math]::Ceiling($ValueWidth * $TempFont.Width)), ($MyDialogValueTextBox.Height + ($TempFont.Height * ($ValueHeight - 1))))
  $MyDialogValueTextBox.Text = $Value -join "`r`n"
  $MyDialogValueTextBox.Tag = $MyDialogValueTextBox.Text
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
      [Object]$EventArg
    )
    Write-Verbose -Message "Enter KeyPress Event for `$MyDialogValueTextBox"
    
    if ((-not ([RegEx]::Match($EventArg.KeyChar, $ValidateKeyPress)).Success) -and ([INT]($EventArg.KeyChar) -ne 8))
    {
      $EventArg.Handled = $True
    }
    
    Write-Verbose -Message "Exit KeyPress Event for `$MyDialogValueTextBox"
  }
  #endregion
  if ($PSBoundParameters.ContainsKey("ValidateKeyPress"))
  {
    $MyDialogValueTextBox.add_KeyPress({ Start-MyDialogValueTextBoxKeyPress -Sender $This -EventArg $PSItem })
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
    
    if (-not [String]::IsNullOrEmpty($MyDialogValueTextBox.Text))
    {
      if (($Match = [RegEx]::Matches($MyDialogValueTextBox.Text, $ValidateValue)).Count)
      {
        $MyDialogValueTextBox.Tag = @($Match | Where-Object -FilterScript { $PSItem.Groups["Return"].Success } | ForEach-Object -Process { $PSItem.Groups["Return"].Value })
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
      
      $MyDialogValueTextBox.Text = $MyDialogValueTextBox.Tag
      
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
    if ($AllowDuplicates.IsPresent)
    {
      $ReturnValue.Value = $MyDialogValueTextBox.Tag
    }
    else
    {
      $ReturnValue.Value = @($MyDialogValueTextBox.Tag | Select-Object -Unique)
    }
  }
  $ReturnValue
  
  Write-Verbose -Message "Exit Function Get-MyItemListDialog"
}
#endregion
