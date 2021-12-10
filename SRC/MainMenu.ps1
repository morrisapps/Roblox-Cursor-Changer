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

###Arguments from Start###
$VERSION = $args[0]

######Images######
$brand = [System.Drawing.Image]::FromFile(".\RESOURCES\ICONS\brand.png")
$icon = New-Object system.drawing.icon(".\RESOURCES\ICONS\Logo.ico")
$defaultIcon = [System.Drawing.Image]::FromFile(".\RESOURCES\ICONS\default.png")
$changeIcon = [System.Drawing.Image]::FromFile(".\RESOURCES\ICONS\change.png")

##################################################################################################################################
#---------------------------------------------------------[GUI]-------------------------------------------------------------------
##################################################################################################################################

#This section contains the GUI elements of the Main Menu also known as "Form"

[System.Windows.Forms.Application]::EnableVisualStyles()

#MainMenu Form
$formMainMenu                        = New-Object system.Windows.Forms.Form
$formMainMenu.ClientSize             = New-Object System.Drawing.Point(386,341)
$formMainMenu.text                   = "Curser Changer for Roblox"
$formMainMenu.TopMost                = $false
$formMainMenu.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$formMainMenu.FormBorderStyle        = 'FixedDialog'
$formMainMenu.Icon                   = $icon
$formMainMenu.MaximizeBox            = $false
$formMainMenu.MinimizeBox            = $false
$formMainMenu.FormBorderStyle 	     = 'FixedSingle'

#Brand Image
$pictureBrand                     = New-Object system.Windows.Forms.PictureBox
$pictureBrand.width               = 300
$pictureBrand.height              = 30
$pictureBrand.location            = New-Object System.Drawing.Point(15,5)
$pictureBrand.image               = $brand
$pictureBrand.SizeMode            = 4

######Labels######
#Version Label
$labelVersion                    = New-Object system.Windows.Forms.Label
$labelVersion.text               = "v"+$VERSION
$labelVersion.width              = 100
$labelVersion.height             = 20
$labelVersion.location           = New-Object System.Drawing.Point(0,321)
$labelVersion.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("PaleGoldenRod")
$labelVersion.Font               = New-Object System.Drawing.Font('Segoe UI',8,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Italic))
$labelVersion.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml("#565656")
$labelVersion.TextAlign          = "MiddleLeft"
$labelVersion.Padding			= "10,0,0,0"

#Status Label
$labelStatus                    = New-Object system.Windows.Forms.Label
$labelStatus.text               = "MorrisApps | GitHub: https://github.com/morrisapps"
$labelStatus.width              = 399
$labelStatus.height             = 20
$labelStatus.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("PaleGoldenRod")
$labelStatus.ForeColor          = "0, 0, 192"
$labelStatus.location           = New-Object System.Drawing.Point(-5,321)
$labelStatus.Font               = New-Object System.Drawing.Font('Segoe UI',8.25,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Italic))
$labelStatus.TextAlign          = "MiddleRight"
$labelStatus.Padding			= "0,0,10,0"

######Buttons######
#Default Cursor Button
$buttonDefaultCursor                       = New-Object system.Windows.Forms.Button
$buttonDefaultCursor.text                  = " Default Cursor"
$buttonDefaultCursor.Size 					= '250, 40'
$buttonDefaultCursor.location              = New-Object System.Drawing.Point(70,60)
$buttonDefaultCursor.Font                  = New-Object System.Drawing.Font('Segoe UI',8.25,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$buttonDefaultCursor.BackColor 				= '255, 192, 192'
$buttonDefaultCursor.ForeColor 				= '0, 0, 192'
$buttonDefaultCursor.Image                 = $defaultIcon
$buttonDefaultCursor.TextImageRelation     = "ImageBeforeText"
$buttonDefaultCursor.ImageAlign            = "MiddleRight"    
$buttonDefaultCursor.TextAlign             = "MiddleLeft"

#New Cursor Button
$buttonNewCursor                    = New-Object system.Windows.Forms.Button
$buttonNewCursor.text               = " Change Cursor"
$buttonNewCursor.Size 				= '250, 40'
$buttonNewCursor.location           = New-Object System.Drawing.Point(70,110)
$buttonNewCursor.Font               = New-Object System.Drawing.Font('Segoe UI',8.25,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$buttonNewCursor.BackColor 			= '192, 255, 192'
$buttonNewCursor.ForeColor 			= '0, 0, 192'
$buttonNewCursor.Image              = $changeIcon
$buttonNewCursor.TextImageRelation  = "ImageBeforeText"
$buttonNewCursor.ImageAlign         = "MiddleRight"    
$buttonNewCursor.TextAlign          = "MiddleLeft"

#Quit Button
$buttonQuit                         = New-Object system.Windows.Forms.Button
$buttonQuit.text                    = "Quit"
$buttonQuit.width                   = 332
$buttonQuit.height                  = 30
$buttonQuit.location                = New-Object System.Drawing.Point(28,260)
$buttonQuit.Font                    = New-Object System.Drawing.Font('Segoe UI',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$buttonQuit.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("ControlLight")
$buttonQuit.DialogResult            = [System.Windows.Forms.DialogResult]::Cancel


#Adds all controls to the form
$formMainMenu.controls.AddRange(@($pictureBrand,$labelVersion,$labelStatus,$buttonDefaultCursor,$buttonNewCursor,$buttonQuit))

##################################################################################################################################
#-----------------------------------------------------------[Functions]-----------------------------------------------------------
##################################################################################################################################

#######DefaultCursor#######
#Sets the Roblox cursor to the default cursor
function DefaultCursor {	
	$errorCode = 0
	try {
		#Get most recent roblox version
		$RobloxVersionFolder = gci "$($env:LOCALAPPDATA)\Roblox\Versions" | ? {$_.Name -like "version-*" -and $_.PSIsContainer} | Sort-Object LastWriteTime | Select-Object -last 1
		$robloxCursorFolder = "C:"+($RobloxVersionFolder.PSPATH).Split("::")[3]+"\content\textures\Cursors\KeyboardMouse"
		#Default cursors
		$defaultCursor1 = ".\RESOURCES\CURSORS\Default\ArrowCursor.png"
		$defaultCursor2 = ".\RESOURCES\CURSORS\Default\ArrowFarCursor.png"
		$defaultCursor3 = ".\RESOURCES\CURSORS\Default\IBeamCursor.png"
		$defaultCursor4 = ".\RESOURCES\CURSORS\Default\advCursor-default.png"
		$defaultCursor5 = ".\RESOURCES\CURSORS\Default\advCursor-white.png"
		$defaultCursor6 = ".\RESOURCES\CURSORS\Default\ArrowCursorDecalDrag.png"
		#Copy cursors
		Copy-Item $defaultCursor1 -Destination $robloxCursorFolder"\ArrowCursor.png" -force
		Copy-Item $defaultCursor2 -Destination $robloxCursorFolder"\ArrowFarCursor.png" -force
		Copy-Item $defaultCursor3 -Destination $robloxCursorFolder"\IBeamCursor.png" -force
		Copy-Item $defaultCursor4 -Destination $robloxCursorFolder"\advCursor-default.png" -force
		Copy-Item $defaultCursor5 -Destination $robloxCursorFolder"\advCursor-white.png" -force
		Copy-Item $defaultCursor6 -Destination $robloxCursorFolder"\ArrowCursorDecalDrag.png" -force
	}catch {
		$errorCode = 1
	}
	if ($errorCode -ne 0){
		[System.Windows.MessageBox]::Show("Could not change the cursor!","Failure","OK","Error")
	}else {
		[System.Windows.MessageBox]::Show("The cursor is now on Roblox!`n`nRemember to run this tool again if the cursor goes back to default.","Success","OK","Information")
	}

}
#----------------------------------------------------------------------------------------


##################################################################################################################################
#-----------------------------------------------------------[Event Handlers]------------------------------------------------------
##################################################################################################################################

#Fetch Tool clicked handler that launches the GUI Fetch.ps1
$buttonDefaultCursor.Add_Click({ DefaultCursor })

#New Cursor Tool clicked handler that launches the ChangeCursor.ps1
$buttonNewCursor.Add_Click({ ./SRC/TOOLS/ChangeCursor.ps1 $icon $brand})


##################################################################################################################################
#---------------------------------------------------------[Script]----------------------------------------------------------------
##################################################################################################################################
#This section runs after the program has fully initialized

#ShowDialog is assigned to result so that it suppresses messages after this form is closed.
$result = $formMainMenu.ShowDialog()