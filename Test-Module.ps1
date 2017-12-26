<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.145
	 Created on:   	11/08/2017 06:17 PM
	 Created by:   	Ken Sweet
	 Organization: 	Chaotic Thoughts
	 Filename:     	Test-Module.ps1
	===========================================================================
	.DESCRIPTION
	The Test-Module.ps1 script lets you test the functions and other features of
	your module in your PowerShell Studio module project. It's part of your project,
	but it is not included in your module.

	In this test script, import the module (be careful to import the correct version)
	and write commands that test the module features. You can include Pester
	tests, too.

	To run the script, click Run or Run in Console. Or, when working on any file
	in the project, click Home\Run or Home\Run in Console, or in the Project pane, 
	right-click the project name, and then click Run Project.
#>

$VerbosePreference = "Continue"

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

[System.Windows.Forms.Application]::EnableVisualStyles()

#Explicitly import the module for testing
Import-Module -Name "$PWD\MyDialogs.psm1" -Verbose

#$Host.EnterNestedPrompt()

#Show-MyAboutDialog -ScriptBlock { Write-Host -Object "Easter Egg Script" } -Width 20
#Show-MyAboutDialog -NoTitle -ScriptBlock { Write-Host -Object "Easter Egg Script" }

Get-MyItemDialog
Get-MyItemListDialog

Get-MyNamedItemDialog -Value ([Ordered]@{ "One" = 1; "Two" = 2; "Three" = 3; "Four" = 4; "Five" = 5; "Six" = 6; "Seven" = 7; "Eight" = 8; }) -ShowReset


$Error

$Host.EnterNestedPrompt()
