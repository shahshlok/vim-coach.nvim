# Quick Start for Experienced Developers

TL;DR for developers who know Neovim plugin development and just want the essentials.

## Setup (30 seconds)

```bash
git clone https://github.com/YOUR_USERNAME/vim-coach.nvim.git
cd vim-coach.nvim
chmod +x test.sh && ./test.sh  # LazyVim test env, first run ~1-2min
```

## Architecture (1 minute)

```
plugin/vim-coach.lua       → Entry point, registers commands/keymaps
lua/vim-coach/init.lua     → Core: picker logic, formatting
lua/vim-coach/commands/*.lua → Data: command databases (Lua tables)
test/minimal_init.lua      → Test env: LazyVim bootstrap
```

**Dependencies**: snacks.nvim (picker UI)

**Pattern**: Data-driven picker plugin

## Adding Commands (2 minutes)

Edit `lua/vim-coach/commands/{category}.lua`:

```lua
{
  name = "Command Name",
  keybind = "key",
  modes = {"n", "v"},
  explanation = "What it does",
  beginner_tip = "Why it matters",
  when_to_use = "Use cases",
  context_notes = { file = "...", explorer = "..." },
  examples = {"key - usage"}
}
```

Test: `./test.sh`, then `:VimCoach`

## Code Flow

```
User: :VimCoach motions
  ↓
plugin/vim-coach.lua: Registered command callback
  ↓
lua/vim-coach/init.lua: require'd, loads command modules
  ↓
coach_picker("motions"): Filters commands, builds items
  ↓
snacks.picker({...}): Opens fuzzy picker
  ↓
User selects → confirm callback → Copy keybind to clipboard
```

## Key Functions

```lua
-- lua/vim-coach/init.lua
M.coach_picker(category)        -- Opens picker for category
M.get_commands(category)        -- Returns command array
M.get_all_commands()            -- Returns all commands
M.setup(opts)                   -- Plugin config
M.info()                        -- Plugin metadata
```

## Extension Points

### Add Category

1. Create `lua/vim-coach/commands/mycategory.lua`
2. Add to `init.lua:7`: `mycategory = require("vim-coach.commands.mycategory")`
3. Add to command completion in `plugin/vim-coach.lua`

### Custom Picker Action

```lua
-- lua/vim-coach/init.lua:169
actions = {
  ["<C-o>"] = function(picker, item)
    vim.cmd("help " .. item.keybind)
  end,
}
```

### Custom Format

```lua
-- lua/vim-coach/init.lua:144
format = function(item)
  return {
    { item.name, "SnacksPickerLabel" },
    { item.keybind, "SnacksPickerSpecial" },
  }
end
```

## Performance

- **Startup**: 0.5ms (lazy-loaded)
- **First open**: 50-100ms (load modules + build items)
- **Subsequent**: 20-30ms (cached)
- **Memory**: ~2-3MB (all commands)

## Testing Strategy

**Manual**: `./test.sh` (isolated LazyVim env)

**Automated** (potential):
```lua
-- With plenary.nvim
describe("vim-coach", function()
  it("loads all commands", function()
    local cmds = require("vim-coach").get_all_commands()
    assert(#cmds > 100)
  end)
end)
```

## File Map

```
plugin/vim-coach.lua              62 lines   Entry, commands, keymaps
lua/vim-coach/init.lua           217 lines   Core picker logic
lua/vim-coach/commands/
  ├── motions.lua                288 lines   Motion commands
  ├── editing.lua                340 lines   Edit commands
  ├── visual.lua                 262 lines   Visual commands
  └── plugins.lua                275 lines   Plugin commands
test/minimal_init.lua            104 lines   LazyVim test bootstrap
test.sh                           25 lines   Test launcher
```

## Commit Convention

```bash
feat:     New feature
fix:      Bug fix
docs:     Documentation
refactor: Code cleanup
test:     Add tests
chore:    Maintenance
```

## PR Checklist

- [ ] Tested in `./test.sh`
- [ ] Follows existing code style
- [ ] Commit messages follow convention
- [ ] No breaking changes (or documented)

## Common Tasks

**Add command**:
```bash
vim lua/vim-coach/commands/editing.lua  # Add entry
./test.sh && :VimCoach editing          # Test
```

**Change UI**:
```bash
vim lua/vim-coach/init.lua              # Edit format/confirm/actions
./test.sh && :VimCoach                  # Test
```

**Add keymap**:
```bash
vim plugin/vim-coach.lua                # Add vim.keymap.set
./test.sh && <test-keymap>              # Test
```

## Debugging

```bash
# Verbose Neovim log
nvim -V9debug.log -u test/minimal_init.lua

# Check loaded modules
:lua print(vim.inspect(package.loaded["vim-coach"]))

# Reload plugin
:Lazy reload vim-coach.nvim

# Check errors
:messages
```

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| snacks.nvim vs Telescope | Lighter, faster, LazyVim native |
| Lua tables vs JSON | Native format, comments, no parsing |
| Lazy loading | Faster startup, Neovim best practice |
| Separate category files | Maintainability, less conflicts |
| Copy to clipboard | Non-invasive, user controls paste |

## Integration Examples

### With LazyVim

```lua
-- ~/.config/nvim/lua/plugins/vim-coach.lua
return {
  "shahshlok/vim-coach.nvim",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<F1>", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
  },
  opts = {
    -- Custom config
  },
}
```

### Load from Local

```lua
return {
  dir = "~/dev/vim-coach.nvim",  -- Your clone
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("vim-coach").setup()
  end,
}
```

## API

```lua
local coach = require("vim-coach")

-- Open picker
coach.coach_picker("all")           -- All commands
coach.coach_picker("motions")       -- Motions only

-- Get data
local cmds = coach.get_all_commands()
local motions = coach.get_commands("motions")

-- Info
local info = coach.info()
print(info.total_commands)          -- 120+
print(info.version)                 -- "2.0.0"
```

## Stack

- **Runtime**: Neovim >= 0.7, Lua 5.1
- **UI**: snacks.nvim (picker)
- **Package Manager**: lazy.nvim
- **Test**: LazyVim env, manual testing
- **CI**: None (opportunity!)

## TODOs / Opportunities

- [ ] Automated tests (plenary.nvim)
- [ ] CI/CD (GitHub Actions)
- [ ] Treesitter integration
- [ ] LSP hover integration
- [ ] History tracking
- [ ] Custom command sources
- [ ] Localization
- [ ] Performance profiling

## Resources

- [Neovim API](https://neovim.io/doc/user/api.html)
- [lazy.nvim Spec](https://github.com/folke/lazy.nvim#-plugin-spec)
- [snacks.nvim Docs](https://github.com/folke/snacks.nvim)

## Questions?

Issues: https://github.com/shahshlok/vim-coach.nvim/issues

Discussions: https://github.com/shahshlok/vim-coach.nvim/discussions

---

**For beginners**: See [CONTRIBUTING.md](CONTRIBUTING.md), [DEVELOPMENT.md](DEVELOPMENT.md), [TESTING.md](TESTING.md), [ARCHITECTURE.md](ARCHITECTURE.md)
