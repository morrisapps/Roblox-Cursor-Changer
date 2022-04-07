##################################################################################################################################
#---------------------------------------------------------[Initialization]--------------------------------------------------------
##################################################################################################################################

Add-Type -AssemblyName System.Windows.Forms
Add-Type -Assembly System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
Import-Module -Name PSReadline

##################################################################################################################################
#---------------------------------------------------------[Global Variables]------------------------------------------------------
##################################################################################################################################

###Arguments from Main Menu###
$icon = $args[0]
$brand = $args[1]

#Retrieves every folder and file under \RESOURCES\CURSORS as arrays
$CURSORS = Get-ChildItem ".\RESOURCES\CURSORS\" | ? {$_.Name -notlike "_*" -and $_.Name -ne "Current" -and $_.PSIsContainer} | Sort-Object
$CURSORS += Get-ChildItem ".\RESOURCES\CURSORS\" | ? {$_.Name -notlike "_*" -and $_.Name -ne "Current" -and ($_.Name -Like "*.png" -or $_.Name -Like "*.jpg")} | Sort-Object
#The path to the Roblox cursor folder
$robloxCursorFolder = ""
#The new selected cursor
$newCursorLocation = ""

##################################################################################################################################
#---------------------------------------------------------[GUI]-------------------------------------------------------------------
##################################################################################################################################

#This section contains the GUI elements of the GUI also known as "Form"

[System.Windows.Forms.Application]::EnableVisualStyles()
#Change Cursor Form
$formChangeCursor                        = New-Object system.Windows.Forms.Form
$formChangeCursor.ClientSize             = New-Object System.Drawing.Point(470, 440)
$formChangeCursor.text                   = "Change Cursor"
$formChangeCursor.Icon                   = $icon
$formChangeCursor.TopMost                = $false
$formChangeCursor.BackColor              = 'White'
$formChangeCursor.AutoScaleDimensions    = '6, 13'
$formChangeCursor.AutoScaleMode 		  = 'Font'
$formChangeCursor.MaximizeBox            = $false
$formChangeCursor.MinimizeBox            = $false
$formChangeCursor.FormBorderStyle 		  = 'FixedSingle'

#Brand Image
$pictureboxBrand                     = New-Object system.Windows.Forms.PictureBox
$pictureboxBrand.width               = 300
$pictureboxBrand.height              = 30
$pictureboxBrand.location            = New-Object System.Drawing.Point(15,5)
$pictureboxBrand.image               = $brand
$pictureboxBrand.SizeMode 			 = 4

#Tool Label
$labelTool = New-Object 'System.Windows.Forms.Label'
$labelTool.Font = 'Segoe UI, 14.25pt, style=Bold'
$labelTool.Location = '0, 30'
$labelTool.Size = '637, 35'
$labelTool.Text = 'Change Cursor Tool'
$labelTool.TextAlign = 'MiddleLeft'

#Warning Label
$labelWarning = New-Object 'System.Windows.Forms.Label'
$labelWarning.Font = 'Segoe UI, 8.25pt, style=Bold, Italic'
$labelWarning.ForeColor = 'Red'
$labelWarning.Location = '12, 63'
$labelWarning.Size = '600, 75'
$labelWarning.Text = '* This tool will replace your cursor for Roblox.
* You can add more cursors under the CURSORS folder in RESOURCES if you want.
* You can revert back to the default cursor as well.
* After Roblox updates, the cursor will go back to default
* Run this tool again to get your cursor back.'

#Cursor Label
$labelCursor = New-Object 'System.Windows.Forms.Label'
$labelCursor.Font = 'Segoe UI, 8.25pt, style=Bold'
$labelCursor.Location = '2, 307'
$labelCursor.Size = '56, 25'
$labelCursor.Text = 'Cursor:'
$labelCursor.TextAlign = 'MiddleRight'

#Cursor ComboBox
$comboboxCursor = New-Object 'System.Windows.Forms.ComboBox'
$comboboxCursor.BackColor = 'Info'
$comboboxCursor.DropDownStyle = 'DropDownList'
$comboboxCursor.ForeColor = 'Maroon'
$comboboxCursor.Location = '63, 310'
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
$groupboxCurrentName.Location = '53, 140'
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
$groupboxNewCursor.Location = '250, 140'
$groupboxNewCursor.Size = '151, 151'
$groupboxNewCursor.Text = 'New Cursor'

#Cancel Button
$buttonCancel = New-Object 'System.Windows.Forms.Button'
$buttonCancel.BackColor = '255, 192, 192'
$buttonCancel.Font = 'Segoe UI, 8.25pt, style=Bold'
$buttonCancel.Location = '13, 370'
$buttonCancel.Size = '148, 40'
$buttonCancel.Text = 'Cancel'
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

#Change Cursor Button
$buttonChangeCursor = New-Object 'System.Windows.Forms.Button'
$buttonChangeCursor.BackColor = '192, 255, 192'
$buttonChangeCursor.Font = 'Segoe UI, 8.25pt, style=Bold'
$buttonChangeCursor.ForeColor = '0, 0, 192'
$buttonChangeCursor.Location = '307, 370'
$buttonChangeCursor.Size = '148, 40'
$buttonChangeCursor.Text = 'Change Cursor'

#Add all Control objects to the Form
$formChangeCursor.Controls.Add($buttonChangeCursor)
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

#######RetrieveCurrentRobloxCursor#######
#Gets the current roblox cursor and places it into $pictureboxCurrentCursor
function RetrieveCurrentRobloxCursor{	
	#Get most recent roblox version
	$RobloxVersionFolder = gci "$($env:LOCALAPPDATA)\Roblox\Versions" | ? {$_.Name -like "version-*" -and $_.PSIsContainer} | Sort-Object LastWriteTime | Select-Object -last 1
	$global:robloxCursorFolder = "C:"+($RobloxVersionFolder.PSPATH).Split("::")[3]+"\content\textures\Cursors\KeyboardMouse"
	$RobloxCurrentCursor = ".\RESOURCES\CURSORS\Current\ArrowFarCursor.png"
	Copy-Item $global:robloxCursorFolder"\ArrowFarCursor.png" -Destination $RobloxCurrentCursor -force
	
	$pictureboxCurrentCursor.image = [System.Drawing.Image]::FromFile($RobloxCurrentCursor)
}
#----------------------------------------------------------------------------------------

##################################################################################################################################
#-----------------------------------------------------------[Event Handlers]------------------------------------------------------
##################################################################################################################################

#Package ComboBox - When cursor is selected displays the cusror in $pictureboxnewCursor
$comboboxCursor.add_SelectedIndexChanged({
	if ($this.SelectedItem -ne "Please Select..."){
		If (Test-Path -Path ".\RESOURCES\CURSORS\$($this.SelectedItem)" -PathType Container){
			$global:newCursorLocation = ".\RESOURCES\CURSORS\"+$this.SelectedItem+"\cursor.png"
		} Else {
			$global:newCursorLocation = ".\RESOURCES\CURSORS\"+$this.SelectedItem
		}
		$pictureboxNewCursor.image = [System.Drawing.Image]::FromFile($global:newCursorLocation)
	}else {
		$pictureboxNewCursor.image = $null
	}
})

#When Change Cursor is clicked sets the current Roblox cursor to the selected new cursor
$buttonChangeCursor.Add_Click({
	$errorCode = 0
	try {
		Copy-Item $global:newCursorLocation -Destination $global:robloxCursorFolder"\ArrowFarCursor.png" -force
		Copy-Item $global:newCursorLocation -Destination $global:robloxCursorFolder"\advCursor-default.png" -force
		Copy-Item $global:newCursorLocation -Destination $global:robloxCursorFolder"\advCursor-white.png" -force
		Copy-Item $global:newCursorLocation -Destination $global:robloxCursorFolder"\ArrowCursorDecalDrag.png" -force
		Copy-Item $global:newCursorLocation -Destination $global:robloxCursorFolder"\ArrowCursor.png" -force
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

##################################################################################################################################
#---------------------------------------------------------[Script]----------------------------------------------------------------
##################################################################################################################################
#This section runs after the program has fully initialized

#Appends each element in $CURSORS to $comboboxCursor as list items
$CURSORS | %{[void] $comboboxCursor.Items.Add($_.Name)}

#Calls RetrieveCurrentRobloxCursor to get the current roblox cursor
RetrieveCurrentRobloxCursor

#Displays the GUI
$result = $formChangeCursor.ShowDialog()

#Disposes Current Cursor so that the cursor image does not lock
$pictureboxCurrentCursor.image.Dispose()