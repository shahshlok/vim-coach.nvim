# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2025-11-06

### Added
- Isolated testing environment for development: `test.sh`, `test/minimal_init.lua`
- Documentation suite for users and contributors: `docs/ARCHITECTURE.md`, `docs/CONTRIBUTING.md`, `docs/DEVELOPMENT.md`, `docs/QUICK_START.md`, `docs/README.md`, `docs/TECHNICAL.md`, `docs/TESTING.md`
- Pull Request template: `.github/PULL_REQUEST_TEMPLATE.md`
- CI workflow to verify branch names: `.github/workflows/ci.yml`
 - Minimal Neovim test config: `test/minimal_init.lua` (no LazyVim)
 - Interactive test runner CLI: `test.sh --lazyvim | --minimal`

### Changed
- README: tightened and simplified to essentials (features, install, usage, minimal config)
- README: restored Neovim/Lua/MIT badges; removed CI badge
- Docs: updated contributing/development to include branch naming scheme
- CI: simplified to keep only branch name check
 - Testing docs: documented dual modes (LazyVim vs Minimal) and updated paths
 - test.sh: converted into a small CLI with mode selection
 - Renamed old `test/minimal_init.lua` to `test/lazyvim_init.lua`; now truly minimal config provided separately
 - Updated docs and README to reflect both modes and CLI usage

### Removed
- Legacy Vim help file: `doc/vim-coach.txt`

### Notes
- Documentation and tooling updates only; no functional plugin changes

## [2.0.0] - 2025-07-10

### Changed
- **BREAKING**: Migrated from Telescope to snacks.picker for fuzzy finding
- Updated dependencies to require snacks.nvim instead of telescope.nvim
- Improved picker interface with modern snacks.picker integration

### Added
- Text wrapping in preview window for better readability
- Enhanced preview content with structured formatting
- Better visual hierarchy in command preview
- Improved UI responsiveness and performance

### Fixed
- Preview content now displays correctly with snacks.picker
- Resolved compatibility issues during picker migration
- Fixed preview window text overflow issues

### Technical
- Refactored preview content generation to work with snacks.picker API
- Updated item structure to use pre-built preview content
- Implemented proper window options for text wrapping

## [1.0.0] - 2025-07-09

### Added
- Initial release of vim-coach.nvim
- Comprehensive command database with 120+ commands
- Telescope integration for fuzzy searching
- Command categories: motions, editing, visual, plugins
- Detailed explanations with beginner tips
- Context-aware help (file vs explorer behavior)
- Copy keybinds to clipboard functionality
- Default keybindings for quick access
- Vim help documentation
- Plugin API for programmatic access

### Features
- `:VimCoach` command with category filtering
- `<leader>?` default keybind for comprehensive help
- Category-specific keybinds (`<leader>hm`, `<leader>he`, etc.)
- Smart search across command names, keybinds, and explanations
- Rich preview with detailed command information
- Configurable window and keymap options

### Documentation
- Comprehensive README with installation and usage
- Vim help file with complete API reference
- Contributing guidelines for community involvement
- MIT License for open source distribution
