###################
# forgottenspiral #
###################

# Ensure that you have set up the folder paths correctly and have 7z/git installed in your system/user path.

# Set up workspace folders before proceeding.
$workspace_folder = "$env:USERPROFILE\Documents\STALKER-PROJECTS\SOC-PROJECT"
$release_folder = "$workspace_folder\SOC_RELEASE"
$project_folder = "$workspace_folder\SOC-MAIN-PROJECT"

# Define the location where MrSeyker's InGameCC mod adapted for use with ZRP is stored.
$ingame_cc_mod_folder = "$workspace_folder\CC_for_ZRP\gamedata"

# Navigate to the release folder.
Set-Location $release_folder

# Specify the patch version for the release.
$patch_version = "v0.3"

# Begin release process.
Write-Host "====================" -ForegroundColor Green
Write-Host "Starting..." -ForegroundColor Green
Write-Host "====================" -ForegroundColor Green

# Specify the folder where all the final files will be stored.
$final_folder = "Mini-update_$patch_version-for_InGameCC_for_ZRP_v1.07_R5RC"

# Create the folder for the files if it doesn't already exist.
If (Test-Path -Path "$final_folder") {
	Write-host "$final_folder already exists." -ForegroundColor Green
}
Else {
	New-Item "$final_folder" -ItemType Directory -Force
	Write-host "$final_folder created successfully." -ForegroundColor Green
}
Write-Host "====================" -ForegroundColor Green

# Determine if copying is enabled or disabled.
$enable_copying = "yes"

If ($enable_copying -eq "yes") {
	Write-Host "Copying is enabled." -ForegroundColor Green
	Write-Host "====================" -ForegroundColor Green

	If (Test-Path -Path "$ingame_cc_mod_folder") {

		# Copy the files from MrSeyker's InGameCC mod adapted for use with ZRP to the final folder.
		Copy-Item -Path $ingame_cc_mod_folder -Destination $final_folder -Recurse -Force

		# Change folder permissions to prevent accidental modification of the original files.
		Get-ChildItem -Path $final_folder -Recurse -File | ForEach-Object { $_.IsReadOnly = $False }
		Write-Host "Unset Read-Only." -ForegroundColor Green
		Write-Host "====================" -ForegroundColor Green

		# Remove the outlined fonts.
		If (Test-Path -Path "$final_folder\gamedata\textures\ui\ui_font_*.*") {
			Remove-Item -Path "$final_folder\gamedata\textures\ui\ui_font_graff_*.ini"
			Remove-Item -Path "$final_folder\gamedata\textures\ui\ui_font_graff_*.dds"
			Write-host "Fonts were deleted successfully." -ForegroundColor Green
		}
		Else {
			Write-host "Fonts don't exist." -ForegroundColor Green
		}
		Write-Host "====================" -ForegroundColor Green

		# Remove the Spanish language folder.
		If (Test-Path -Path "$final_folder\gamedata\config\text\esp") {
			Remove-Item -Path "$final_folder\gamedata\config\text\esp" -Recurse -Force
			Write-host "esp folder deleted successfully." -ForegroundColor Green
		}
		Else {
			Write-host "esp folder doesn't exist." -ForegroundColor Green
		}
		Write-Host "====================" -ForegroundColor Green
	}
	Else {
		Write-Host "MrSeyker's adapted mod folder doesn't exist." -ForegroundColor Yellow
	}
	Write-Host "====================" -ForegroundColor Green
}
Else {
	Write-Host "Copying is disabled." -ForegroundColor Yellow
	Write-Host "====================" -ForegroundColor Yellow
}

# Determine if releasing is enabled or disabled.
$enable_release = "yes"

If ($enable_release -eq "yes") {
	Write-Host "Releasing is enabled." -ForegroundColor Green
	Write-Host "====================" -ForegroundColor Green

	# Clone the project folder to a temporary directory.
	git clone $project_folder "$final_folder-temporal"

	# Remove unnecessary files from the temporal folder.
	Remove-Item -Path "$final_folder-temporal\.git" -Recurse -Force
	Remove-Item -Path "$final_folder-temporal\.gitignore" -Recurse -Force
	Remove-Item -Path "$final_folder-temporal\.gitattributes" -Recurse -Force
	Remove-Item -Path "$final_folder-temporal\CHANGELOG.md" -Recurse -Force
	Remove-Item -Path "$final_folder-temporal\README.md" -Recurse -Force
	Remove-Item -Path "$final_folder-temporal\Release.ps1" -Recurse -Force

	# Copy and overwrite the files from the MrSeyker's InGameCC mod adapted for use with ZRP.
	Copy-Item -Path "$final_folder-temporal\*" -Destination $final_folder -Recurse -Force

	# Remove the temporal folder.
	Remove-Item -Path "$final_folder-temporal" -Recurse -Force

	# Copy script files for use with ZRP Modifier.
	Copy-Item "$final_folder\gamedata\scripts\closecaption.script" -Destination "$final_folder\gamedata\scripts\optional\closecaption.script.ingamecc" -Force
	Copy-Item "$final_folder\gamedata\scripts\closecaption.script" -Destination "$final_folder\gamedata\scripts\optional\closecaption.script.ncc" -Force
	Write-Host "====================" -ForegroundColor Green

	Copy-Item "$final_folder\gamedata\scripts\sound_theme.script" -Destination "$final_folder\gamedata\scripts\optional\sound_theme.script.ingamecc" -Force
	Copy-Item "$final_folder\gamedata\scripts\sound_theme.script" -Destination "$final_folder\gamedata\scripts\optional\sound_theme.script.ncc" -Force
	Write-Host "====================" -ForegroundColor Green

	Copy-Item "$final_folder\gamedata\scripts\xr_sound.script" -Destination "$final_folder\gamedata\scripts\optional\xr_sound.script.ingamecc" -Force
	Copy-Item "$final_folder\gamedata\scripts\xr_sound.script" -Destination "$final_folder\gamedata\scripts\optional\xr_sound.script.ncc" -Force
	Copy-Item "$final_folder\gamedata\scripts\xr_sound.script" -Destination "$final_folder\gamedata\scripts\optional\xr_sound.script.ncc_simple" -Force
	Write-Host "====================" -ForegroundColor Green

	# Optional patch for the Monolith's voice in Russian.
	$optional_folder = "$final_folder\optional\Russian voice for the Monolith\gamedata\scripts\optional"

	If (Test-Path -Path "$optional_folder") {
		Write-host "Optional folder already exists." -ForegroundColor Yellow
	}
	Else {
		# Create a new folder for the optional files.
		New-Item "$optional_folder" -ItemType Directory -Force
		# Copy the script files for use with ZRP Modifier for the Monolith's voice in Russian.
		Copy-Item "$final_folder\optional\Russian voice for the Monolith\gamedata\scripts\sound_theme.script" -Destination "$final_folder\optional\Russian voice for the Monolith\gamedata\scripts\optional\sound_theme.script.ingamecc" -Force
		Copy-Item "$final_folder\optional\Russian voice for the Monolith\gamedata\scripts\sound_theme.script" -Destination "$final_folder\optional\Russian voice for the Monolith\gamedata\scripts\optional\sound_theme.script.ncc" -Force
		Write-Host "====================" -ForegroundColor Green
		Write-host "Optional folder created and files copied successfully." -ForegroundColor Green
	}
	Write-Host "====================" -ForegroundColor Green

	# Delete unnecessary or debug files manually.

	# Copy the Instructions and Additional Notes file.
	Copy-Item "$release_folder\Instructions_and_Additional_Notes.txt" -Destination "$final_folder\Instructions_and_Additional_Notes_$patch_version.txt" -Force
	Write-Host "====================" -ForegroundColor Green

	# Copy the Readme and Changelog file.
	Copy-Item "$release_folder\Readme_and_Changelog.txt" -Destination "$final_folder\Readme_and_Changelog_$patch_version.txt" -Force
	Write-Host "====================" -ForegroundColor Green
}
Else {
	Write-Host "Releasing is disabled." -ForegroundColor Yellow
	Write-Host "====================" -ForegroundColor Yellow
}

# Compress the final folder with 7z if it doesn't already exist.
If (!(Test-Path -Path "$final_folder.7z")) {
	7z.exe a "$final_folder.7z" "$final_folder\"
	Write-Host "Compressed the final folder successfully." -ForegroundColor Green
	Write-Host "====================" -ForegroundColor Green
}
Else {
	Write-Host "Compressed file is uncreated." -ForegroundColor Yellow
	Write-Host "====================" -ForegroundColor Yellow
}

Write-Host "Complete." -ForegroundColor Green
Write-Host "====================" -ForegroundColor Green

Pause
Exit
