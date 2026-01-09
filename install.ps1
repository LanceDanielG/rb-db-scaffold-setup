# Windows PowerShell Installer for Ruby DB Scaffolder

$CommandName = "rb-db-setup"
$InstallDir = "$HOME\.rb-db-tools"
$SourceDir = $PSScriptRoot

echo "--- Ruby DB Scaffolder Windows Installer ---"

# 1. Create installation directory
if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
    echo "Created: $InstallDir"
}

# 2. Copy files
Copy-Item "$SourceDir\setup_db_tools.rb" "$InstallDir\"
Copy-Item "$SourceDir\rb-db-setup.bat" "$InstallDir\"
echo "Installed files to: $InstallDir"

# 3. Add to User PATH
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    $NewPath = "$UserPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    echo "Added $InstallDir to User PATH."
    echo "NOTE: You may need to restart your terminal (PowerShell/CMD) for changes to take effect."
} else {
    echo "$InstallDir is already in your PATH."
}

echo "---"
echo "Installation successful!"
echo "You can now run '$CommandName' from ANY folder."
