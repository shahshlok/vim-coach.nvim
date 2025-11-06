# vim-coach.nvim

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

Interactive, searchable Vim command reference for Neovim. Beginner‑friendly explanations, practical tips, and a clean picker UI powered by `snacks.nvim`.

## Features

- Fast fuzzy search over core motions, editing, visual, and plugin commands
- Clear “what/when/why” explanations with examples
- Copy keybinds directly from the picker (`Enter`/`<C-y>`)
- Context notes where behavior differs
- Works out of the box with sensible defaults

## Install (lazy.nvim)

```lua
{
  "shahshlok/vim-coach.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("vim-coach").setup()
  end,
  keys = {
    { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
  },
}
```

Other plugin managers are supported; see docs below.

## Usage

- `:VimCoach` or `<leader>?` opens the picker
- `:VimCoach [category]` filters to a category: `all | motions | editing | visual | plugins`
- Inside the picker: `Enter` or `<C-y>` copies the keybind; `<Esc>` closes

## Configuration

```lua
require("vim-coach").setup({
  window = { border = "rounded", title_pos = "center" },
  keymaps = { copy_keymap = "<C-y>", close = "<Esc>" },
})

-- Disable default keymaps if you prefer your own
vim.g.vim_coach_no_default_keymaps = 1
```

## Requirements

- Neovim >= 0.7
- `folke/snacks.nvim` (picker UI)

## Docs & Links

- Full docs index: `docs/README.md`
- Contributing guide: `docs/CONTRIBUTING.md`
- Development workflow: `docs/DEVELOPMENT.md`
- Testing guide: `docs/TESTING.md`

## Local Testing

- Run `./test.sh` and choose LazyVim (full distro) or Minimal (barebones)
- Or use flags: `./test.sh --lazyvim` or `./test.sh --minimal`

## Contributing

Issues and PRs are welcome. Start with `docs/CONTRIBUTING.md`. To try changes locally, run `./test.sh`.

## License

MIT — see `LICENSE`.
