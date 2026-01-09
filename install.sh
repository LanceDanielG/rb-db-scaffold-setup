#!/bin/bash

# Configuration
COMMAND_NAME="rb-db-setup"
BIN_DIR="$HOME/.local/bin"
SOURCE_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/setup_db_tools.rb"
TARGET_PATH="$BIN_DIR/$COMMAND_NAME"
SHELL_CONFIG="$HOME/.bashrc"

echo "--- Ruby DB Scaffolder Global Installer ---"

# 1. Create bin directory if it doesn't exist
if [ ! -d "$BIN_DIR" ]; then
    mkdir -p "$BIN_DIR"
    echo "Created: $BIN_DIR"
fi

# 2. Copy and set permissions
cp "$SOURCE_SCRIPT" "$TARGET_PATH"
chmod +x "$TARGET_PATH"
echo "Installed: $TARGET_PATH"

# 3. Add to PATH in .bashrc if not already there
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    if ! grep -q "$BIN_DIR" "$SHELL_CONFIG"; then
        echo -e "\n# Add local bin to PATH\nexport PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_CONFIG"
        echo "Added $BIN_DIR to PATH in $SHELL_CONFIG"
    fi
fi

# 4. Cleanup old alias/function if it exists
if grep -q "$COMMAND_NAME()" "$SHELL_CONFIG"; then
    # Simple way to remove the old function block
    sed -i "/# Ruby DB Scaffolder/,+3d" "$SHELL_CONFIG"
    echo "Cleaned up old version from $SHELL_CONFIG"
fi

echo "---"
echo "Installation successful!"
echo "Please run: source ~/.bashrc"
echo "Then you can run '$COMMAND_NAME' from ANY folder."
