<#
.SYNOPSIS
	Changes the Roblox cursor to the selected cursor.
	Creates a Winform as a GUI.
.PARAMETER $ICON
    The program icon to be placed in the top left of the Winform.
.PARAMETER $BRAND
	The banner image the top of the Winform.
.INPUTS
    Cursors under .\RESOURCES\CURSORS
.OUTPUTS
	Overwrites Roblox cursor (At Roblox installed path)
.NOTES
    Created by Morrisapps (Corey Morris).
#>

##################################################################################################################################
#---------------------------------------------------------[Global Variables]------------------------------------------------------
##################################################################################################################################

###Arguments from Main Menu###
param (
    $ICON,
	$BRAND
)

#The path to the Roblox cursor folder
$ROBLOXCURSORFOLDER = ""
#The new selected cursor
$NEWCURSORLOCATION = ""

##################################################################################################################################
#---------------------------------------------------------[Initialization]--------------------------------------------------------
##################################################################################################################################

Add-Type -AssemblyName System.Windows.Forms
Add-Type -Assembly System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
Import-Module -Name PSReadline

$ProgressPreference = 'SilentlyContinue'

##################################################################################################################################
#---------------------------------------------------------[GUI]-------------------------------------------------------------------
##################################################################################################################################

#This section contains the GUI elements of the GUI also known as "Form"

[System.Windows.Forms.Application]::EnableVisualStyles()
#Change Cursor Form
$formChangeCursor                        = New-Object system.Windows.Forms.Form
$formChangeCursor.ClientSize             = New-Object System.Drawing.Point(470, 430)
$formChangeCursor.text                   = "Change Cursor"
$formChangeCursor.Icon                   = $ICON
$formChangeCursor.TopMost                = $false
$formChangeCursor.BackColor              = 'White'
$formChangeCursor.AutoScaleDimensions    = '6, 13'
$formChangeCursor.AutoScaleMode 		  = 'Font'
$formChangeCursor.MaximizeBox            = $false
$formChangeCursor.MinimizeBox            = $false
$formChangeCursor.FormBorderStyle 		  = 'FixedSingle'

#Brand Image
$pictureboxBrand                     = New-Object system.Windows.Forms.PictureBox
$pictureboxBrand.width               = 350
$pictureboxBrand.height              = 58
$pictureboxBrand.location            = New-Object System.Drawing.Point(0,0)
$pictureboxBrand.image               = $BRAND
$pictureboxBrand.SizeMode 			 = 1

#Tool Label
$labelTool = New-Object 'System.Windows.Forms.Label'
$labelTool.Font = 'Segoe UI, 14.25pt, style=Bold'
$labelTool.Location = '0, 50'
$labelTool.Size = '637, 35'
$labelTool.Text = 'Change Cursor Tool'
$labelTool.TextAlign = 'MiddleLeft'

#Warning Label
$labelWarning = New-Object 'System.Windows.Forms.Label'
$labelWarning.Font = 'Segoe UI, 8.25pt, style=Bold, Italic'
$labelWarning.ForeColor = 'Red'
$labelWarning.Location = '12, 83'
$labelWarning.Size = '600, 75'
$labelWarning.Text = '* This tool will replace your cursor for Roblox.
* You can add more cursors under the CURSORS folder in RESOURCES if you want.
* You can revert back to the default cursor as well.
* After Roblox updates, the cursor will go back to default
* Run this tool again to get your cursor back.'

#Cursor Label
$labelCursor = New-Object 'System.Windows.Forms.Label'
$labelCursor.Font = 'Segoe UI, 8.25pt, style=Bold'
$labelCursor.Location = '2, 327'
$labelCursor.Size = '56, 25'
$labelCursor.Text = 'Cursor:'
$labelCursor.TextAlign = 'MiddleRight'

#Cursor ComboBox
$comboboxCursor = New-Object 'System.Windows.Forms.ComboBox'
$comboboxCursor.BackColor = 'Info'
$comboboxCursor.DropDownStyle = 'DropDownList'
$comboboxCursor.ForeColor = 'Maroon'
$comboboxCursor.Location = '63, 330'
$comboboxCursor.Size = '370, 21'
[void]$comboboxCursor.Items.Add('Please Select...')
$comboboxCursor.SelectedIndex = 0

#Current Cursor GUI Image
$pictureboxCurrentCursor                     = New-Object system.Windows.Forms.PictureBox
$pictureboxCurrentCursor.width               = 130
$pictureboxCurrentCursor.height              = 130
$pictureboxCurrentCursor.location            = New-Object System.Drawing.Point(15,15)
$pictureboxCurrentCursor.SizeMode			 = 4

#Current Name Group
$groupboxCurrentName = New-Object 'System.Windows.Forms.GroupBox'
	#Add all controls within group
	$groupboxCurrentName.Controls.Add($pictureboxCurrentCursor)
$groupboxCurrentName.Font = 'Segoe UI, 9.75pt, style=Bold'
$groupboxCurrentName.Location = '53, 160'
$groupboxCurrentName.Size = '151, 151'
$groupboxCurrentName.Text = 'Current Cursor'

#new Cursor GUI Image
$pictureboxnewCursor                     = New-Object system.Windows.Forms.PictureBox
$pictureboxnewCursor.width               = 130
$pictureboxnewCursor.height              = 130
$pictureboxnewCursor.location            = New-Object System.Drawing.Point(15,15)
$pictureboxnewCursor.SizeMode			 = 4

#New Cursor Group
$groupboxNewCursor = New-Object 'System.Windows.Forms.GroupBox'
	#Add all controls within group
	$groupboxNewCursor.Controls.Add($pictureboxNewCursor)
$groupboxNewCursor.Font = 'Segoe UI, 9.75pt, style=Bold'
$groupboxNewCursor.Location = '250, 160'
$groupboxNewCursor.Size = '151, 151'
$groupboxNewCursor.Text = 'New Cursor'

#Cancel Button
$buttonCancel = New-Object 'System.Windows.Forms.Button'
$buttonCancel.BackColor = '255, 192, 192'
$buttonCancel.Font = 'Segoe UI, 8.25pt, style=Bold'
$buttonCancel.Location = '13, 370'
$buttonCancel.Size = '128, 40'
$buttonCancel.Text = 'Cancel'
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

#Download Button
$buttonDownload = New-Object 'System.Windows.Forms.Button'
$buttonDownload.BackColor = '160, 200, 255'
$buttonDownload.Font = 'Segoe UI, 8.25pt, style=Bold'
$buttonDownload.Location = '172, 370'
$buttonDownload.Size = '128, 40'
$buttonDownload.Text = 'Download                    Cursors'

#Downloading Label
$labelDownloading = New-Object 'System.Windows.Forms.Label'
$labelDownloading.Font = 'Segoe UI, 25pt, style=Bold'
$labelDownloading.Location = '13,80'
$labelDownloading.Size = '450,280'
$labelDownloading.AutoSize = $false;
$labelDownloading.Visible = $false
$labelDownloading.TextAlign = 'TopCenter'
$labelDownloading.Text = [System.Environment]::NewLine+'osuskinner.com cursors'+[System.Environment]::NewLine+[System.Environment]::NewLine+'Downloading...               Please wait!'

#Change Cursor Button
$buttonChangeCursor = New-Object 'System.Windows.Forms.Button'
$buttonChangeCursor.BackColor = '192, 255, 192'
$buttonChangeCursor.Font = 'Segoe UI, 8.25pt, style=Bold'
$buttonChangeCursor.ForeColor = '0, 0, 192'
$buttonChangeCursor.Location = '327, 370'
$buttonChangeCursor.Size = '128, 40'
$buttonChangeCursor.Text = 'Change Cursor'

#Add all Control objects to the Form
$formChangeCursor.Controls.Add($labelTest)
$formChangeCursor.Controls.Add($labelDownloading)
$formChangeCursor.Controls.Add($buttonChangeCursor)
$formChangeCursor.Controls.Add($buttonDownload)
$formChangeCursor.Controls.Add($buttonCancel)
$formChangeCursor.Controls.Add($labelWarning)
$formChangeCursor.Controls.Add($labelCursor)
$formChangeCursor.Controls.Add($comboboxCursor)
$formChangeCursor.Controls.Add($groupboxCurrentName)
$formChangeCursor.Controls.Add($groupboxNewCursor)
$formChangeCursor.Controls.Add($labelTool)
$formChangeCursor.Controls.Add($pictureboxBrand)

##################################################################################################################################
#-----------------------------------------------------------[Functions]-----------------------------------------------------------
##################################################################################################################################

#######Get-CurrentRobloxCursor#######
Function Get-CurrentRobloxCursor{
	<#
	.SYNOPSIS
		Gets the current roblox cursor and places it into $pictureboxCurrentCursor
	.INPUTS
		The Roblox cursor from the current version folder location of Roblox
	.OUTPUTS
		Copies current cursor to .\RESOURCES\CURSORS\Current
	#>
	#Get most recent roblox version
	$RobloxVersionFolder = Get-ChildItem "$($env:LOCALAPPDATA)\Roblox\Versions" `
	| Where-Object {$_.Name -like "version-*" -and $_.PSIsContainer} | Sort-Object LastWriteTime | Select-Object -last 1
	$global:ROBLOXCURSORFOLDER = "C:"+($RobloxVersionFolder.PSPATH).Split("::")[3]+"\content\textures\Cursors\KeyboardMouse"
	$RobloxCurrentCursor = ".\RESOURCES\CURSORS\Current\ArrowFarCursor.png"
	Copy-Item $global:ROBLOXCURSORFOLDER"\ArrowFarCursor.png" -Destination $RobloxCurrentCursor -force
	#Set current cursor into $pictureCurrentCursor
	$pictureboxCurrentCursor.image = [System.Drawing.Image]::FromFile($RobloxCurrentCursor)
}
#----------------------------------------------------------------------------------------

#######Get-osuskinnerCursors#######
Function Get-osuskinnerCursors{
	<#
	.SYNOPSIS
		Gets cursors from osuskinner.com
	.OUTPUTS
		Downloads cursors to .\RESOURCES\CURSORS\osuskinner\
	.NOTES
		osuskinner has several pages of cursors. 
		This functions loops through all pages to get cursors.
	#>
	#Retrieves web information from main cursor page
	$osuCursorMainPage = Invoke-WebRequest -Uri https://osuskinner.com/interface/cursor -UseBasicParsing

	#Gets the total pages of cursors
	ForEach ($link in $osuCursorMainPage.Links){
		If ($link -Like "*/interface/cursor?p=*"){
			[Array]$pages += ($link -Replace ".*interface/cursor\?p=") -Replace "}.*"
		}
	}
	$pageMaximum = ($pages | Measure-Object -Maximum).Maximum

	#Loops through each cursor page
	For ($i = 0; $i -lt $pageMaximum; $i++){
		#Retrieve page
		$osuCursorPage = Invoke-WebRequest -Uri https://osuskinner.com/interface/cursor?p=$i -UseBasicParsing
		#Retrieves cursors from current page
		ForEach ($cursor in $osuCursorPage.Images.Src){
			$savePath = ".\RESOURCES\CURSORS\osuskinner\"+((Split-Path $cursor -leaf) -Replace "_thumb_small")
			If (-Not(Test-Path $savePath)){
				$wc = New-Object System.Net.WebClient
				Try {
					$wc.DownloadFile("https://osuskinner.com/$cursor", "$savePath")
				} Catch {
					#Ignore
				}
			}
		}
	}
}
#----------------------------------------------------------------------------------------

#######Set-ComboboxCursor#######
Function Set-ComboboxCursor{
	<#
	.SYNOPSIS
		Gets local saved cursors then sets $comboxCursor with each cursor name.
	.INPUTS
		Cursors under .\RESOURCES\CURSORS\
	#>

	#Clears $comboCursor to ensure to duplicates
	$comboboxCursor.Items.Clear()

	$cursors = @()
	#Retrieves every folder and file under \RESOURCES\CURSORS as arrays
	$cursors += Get-ChildItem ".\RESOURCES\CURSORS\" | `
	Where-Object {$_.Name -notlike "_*" -and $_.Name -ne "Current" -and $_.Name -ne "osuskinner" -and $_.PSIsContainer} | Sort-Object
	$cursors += Get-ChildItem ".\RESOURCES\CURSORS\" | `
	Where-Object {$_.Name -notlike "_*" -and $_.Name -ne "Current"  -and $_.Name -ne "osuskinner" -and ($_.Name -Like "*.png" -or $_.Name -Like "*.jpg")} | Sort-Object
	$cursors += Get-ChildItem ".\RESOURCES\CURSORS\osuskinner\" | `
	Where-Object {$_.Name -notlike "_*" -and (-Not($_.PSIsContainer)) -and ($_.Name -Like "*.png" -or $_.Name -Like "*.jpg")}

	#Appends each element in $cursors to $comboboxCursor as list items
	$cursors | ForEach-Object {If ($null -ne $_.Name){[void] $comboboxCursor.Items.Add($_.Name)}}
}
#----------------------------------------------------------------------------------------

##################################################################################################################################
#-----------------------------------------------------------[Event Handlers]------------------------------------------------------
##################################################################################################################################

#Package ComboBox - When cursor is selected displays the cusror in $pictureboxnewCursor
$comboboxCursor.add_SelectedIndexChanged({
	if ($this.SelectedItem -ne "Please Select..."){
		If (Test-Path -Path ".\RESOURCES\CURSORS\$($this.SelectedItem)" -PathType Container){
			$global:NEWCURSORLOCATION = ".\RESOURCES\CURSORS\"+$this.SelectedItem+"\cursor.png"
		} Elseif (Test-Path -Path ".\RESOURCES\CURSORS\$($this.SelectedItem)" -PathType Leaf) {
			$global:NEWCURSORLOCATION = ".\RESOURCES\CURSORS\"+$this.SelectedItem
		} Else {
			$global:NEWCURSORLOCATION = ".\RESOURCES\CURSORS\osuskinner\"+$this.SelectedItem
		}
		$pictureboxNewCursor.image = [System.Drawing.Image]::FromFile($global:NEWCURSORLOCATION)
	}else {
		$pictureboxNewCursor.image = $null
	}
})

#When Change Cursor is clicked sets the current Roblox cursor to the selected new cursor
$buttonChangeCursor.Add_Click({
	$errorCode = 0
	try {
		Copy-Item $global:NEWCURSORLOCATION -Destination $global:ROBLOXCURSORFOLDER"\ArrowFarCursor.png" -force
		Copy-Item $global:NEWCURSORLOCATION -Destination $global:ROBLOXCURSORFOLDER"\advCursor-default.png" -force
		Copy-Item $global:NEWCURSORLOCATION -Destination $global:ROBLOXCURSORFOLDER"\advCursor-white.png" -force
		Copy-Item $global:NEWCURSORLOCATION -Destination $global:ROBLOXCURSORFOLDER"\ArrowCursorDecalDrag.png" -force
		Copy-Item $global:NEWCURSORLOCATION -Destination $global:ROBLOXCURSORFOLDER"\ArrowCursor.png" -force
	}catch {
		$errorCode = 1
	}

	if ($errorCode -ne 0){
		[System.Windows.MessageBox]::Show("Could not change the cursor!","Failure","OK","Error")
	}else {
		[System.Windows.MessageBox]::Show("The cursor is now on Roblox!`n`nRemember to run this tool again if the cursor goes back to default.","Success","OK","Information")
	}
	$formChangeCursor.Close()
})

#When Download is clicked, gets cursors from osuskinner.com and updates $comboboxCursor with them as items.
$buttonDownload.Add_Click({

	#Shows Downloading label and disables buttons
	$buttonCancel.Enabled = $false
	$buttonDownload.Enabled = $false
	$buttonChangeCursor.Enabled = $false
	$labelDownloading.Visible = $true

	#Gets cursors from osuskinner.com
	Get-osuskinnerCursors

	#Set cursors into Combobox
	Set-ComboboxCursor

	[System.Windows.Forms.Application]::DoEvents() 
	
	#Hides Downloading label and enables buttons
	$labelDownloading.Visible = $false
	$buttonCancel.Enabled = $true
	$buttonDownload.Enabled = $true
	$buttonChangeCursor.Enabled = $true
})

##################################################################################################################################
#---------------------------------------------------------[Script]----------------------------------------------------------------
##################################################################################################################################
#This section runs after the program has fully initialized

#Gets cursors from osuskinner.com
#Get-osuskinnerCursors

#Set cursors into Combobox
Set-ComboboxCursor

#Calls Get-CurrentRobloxCursor to get the current roblox cursor
Get-CurrentRobloxCursor

#Displays the GUI
$null = $formChangeCursor.ShowDialog()

#Disposes Current Cursor so that the cursor image does not lock
$pictureboxCurrentCursor.image.Dispose()