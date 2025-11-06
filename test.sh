#!/bin/bash
# Launch Neovim with isolated test configuration for vim-coach.nvim
# This won't affect your main Neovim setup

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}vim-coach.nvim Test Environment${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo "Launching Neovim with isolated config..."
echo "Your main Neovim config is NOT affected."
echo ""

# Launch nvim with the minimal test config
# -u specifies the init file to use
# --noplugin prevents loading plugins from your main config
nvim -u "$(dirname "$0")/test/minimal_init.lua" "$@"
