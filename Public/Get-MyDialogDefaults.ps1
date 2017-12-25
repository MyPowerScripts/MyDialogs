
#region function Get-MyDialogDefaults
function Get-MyDialogDefaults()
{
  <#
    .SYNOPSIS
      Get default Dialog Form Font and Colors
    .DESCRIPTION
      Get default Dialog Form Font and Colors
    .EXAMPLE
      $Defaults = Get-MyDialogDefaults
    .NOTES
      Original Function By Ken Sweet
    .LINK
  #>
  [CmdletBinding()]
  param (
  )
  Write-Verbose -Message "Enter Function Get-MyDialogDefaults"
  
  [PSCustomObject]$Script:MyDialogDefaults
  
  Write-Verbose -Message "Exit Function Get-MyDialogDefaults"
}
#endregion

