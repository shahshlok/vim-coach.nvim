#!/bin/bash
# Launch Neovim with isolated LazyVim test configuration for vim-coach.nvim
# This won't affect your main Neovim setup

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}vim-coach.nvim Test Environment${NC}"
echo -e "${YELLOW}(LazyVim Edition)${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo "Launching LazyVim with isolated config..."
echo "Your main Neovim config is NOT affected."
echo ""
echo -e "${YELLOW}First run? This will install LazyVim + plugins (~1-2 min)${NC}"
echo ""

# Launch nvim with the minimal test config
# -u specifies the init file to use
# --noplugin prevents loading plugins from your main config
nvim -u "$(dirname "$0")/test/minimal_init.lua" "$@"
