#!/bin/bash
# vim-coach.nvim test runner (CLI)
# Launch Neovim in an isolated environment with either LazyVim or a minimal setup.

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

usage() {
  cat <<EOF
vim-coach.nvim test runner

Usage: ./test.sh [--lazyvim | --minimal] [-- <args passed to nvim>]

Options:
  -l, --lazyvim     Launch full LazyVim environment (recommended)
  -m, --minimal     Launch minimal Neovim (snacks.nvim + vim-coach only)
  -h, --help        Show this help

If no option is provided, an interactive prompt will ask you to choose.
EOF
}

mode=""
declare -a pass_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--lazyvim) mode="lazyvim"; shift ;;
    -m|--minimal) mode="minimal"; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; pass_args=("$@"); break ;;
    *) pass_args+=("$1"); shift ;;
  esac
done

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}vim-coach.nvim Test Environment${NC}"
echo -e "${BLUE}=====================================${NC}"
echo "This runs in isolation and won't affect your main config."
echo ""

if [[ -z "${mode}" ]]; then
  echo -e "Choose environment:"
  echo -e "  [1] ${GREEN}LazyVim${NC} (full distro, realistic)"
  echo -e "  [2] ${YELLOW}Minimal${NC} (snacks.nvim + vim-coach)"
  echo -n "Enter choice (1/2) [1]: "
  read -r choice
  case "${choice}" in
    2) mode="minimal" ;;
    ""|1|*) mode="lazyvim" ;;
  esac
fi

init_file=""
if [[ "${mode}" == "lazyvim" ]]; then
  echo -e "Mode: ${GREEN}LazyVim${NC}"
  echo -e "First run may install LazyVim + plugins (~1-2 min)"
  init_file="${script_dir}/test/lazyvim_init.lua"
elif [[ "${mode}" == "minimal" ]]; then
  echo -e "Mode: ${YELLOW}Minimal${NC}"
  echo -e "First run may install lazy.nvim + snacks.nvim (~30s-1m)"
  init_file="${script_dir}/test/minimal_init.lua"
else
  echo -e "${RED}Unknown mode: ${mode}${NC}" >&2
  exit 1
fi

echo ""
# Safe preview of extra args (works even with set -u)
args_preview=""
if [ ${#pass_args[@]:-0} -gt 0 ]; then
  args_preview=" ${pass_args[*]}"
fi
echo -e "Launching: nvim -u ${init_file}${args_preview}"
echo ""

if [ ${#pass_args[@]:-0} -gt 0 ]; then
  exec nvim -u "${init_file}" "${pass_args[@]}"
else
  exec nvim -u "${init_file}"
fi
