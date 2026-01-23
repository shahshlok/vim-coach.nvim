# API Reference

This guide documents all public functions and their usage. It's designed for developers who want to extend or use vim-coach.nvim programmatically.

Table of Contents:
- [Main Module (M)](#main-module)
- [Configuration](#configuration)
- [Loader Module](#loader-module)
- [Command Structure](#command-structure)
- [Usage Examples](#usage-examples)
- [Advanced Usage](#advanced-usage)

---

## Main Module

The main module is accessed via `require("vim-coach")`.

### M.coach_picker(category)

Opens the command picker interface.

**Parameters:**
- `category` (string, optional): Filter to specific category
  - Valid values: "all", "motions", "editing", "visual", "plugins"
  - Default: "all"

**Returns:** nil

**Example:**
```lua
local coach = require("vim-coach")

-- Open picker with all commands
coach.coach_picker()

-- Open picker with only motion commands
coach.coach_picker("motions")

-- Open picker with editing commands
coach.coach_picker("editing")
```

**What it does:**
1. Validates the category
2. Loads commands for that category
3. Opens snacks.picker with formatted items
4. Waits for user interaction

---

### M.setup(opts)

Configure vim-coach.nvim with custom options.

**Parameters:**
- `opts` (table, optional): Configuration table

**Returns:** nil

**Configuration options:**

```lua
{
  window = {
    border = "rounded",      -- Border style
    title_pos = "center",    -- Title position
  },
  keymaps = {
    copy_keymap = "<C-y>",   -- Key to copy keybind
    close = "<Esc>",         -- Key to close picker
  },
  preview = {
    wrap = true,             -- Enable word wrapping
    linebreak = true,        -- Break long lines
    breakindent = true,      -- Maintain indentation
  },
}
```

**Example:**
```lua
require("vim-coach").setup({
  window = {
    border = "double",
    title_pos = "left",
  },
  keymaps = {
    copy_keymap = "<C-c>",
    close = "<Esc>",
  },
})
```

**Validation:**
- All options are optional
- Invalid types will raise an error
- Unknown options are ignored

---

### M.get_all_commands()

Get all commands from all categories.

**Parameters:** None

**Returns:** array of command tables

**Example:**
```lua
local coach = require("vim-coach")
local all_commands = coach.get_all_commands()

for _, cmd in ipairs(all_commands) do
  print(cmd.name .. " (" .. cmd.keybind .. ")")
end
```

**Output:**
```
Move Right (l)
Move Left (h)
Move Down (j)
...
```

---

### M.get_commands(category)

Get commands from a specific category.

**Parameters:**
- `category` (string): Category name ("all", "motions", "editing", "visual", "plugins")

**Returns:** array of command tables

**Example:**
```lua
local coach = require("vim-coach")
local motions = coach.get_commands("motions")

print("Motion commands: " .. #motions)

for _, cmd in ipairs(motions) do
  if cmd.beginner_tip then
    print(cmd.name .. ": " .. cmd.beginner_tip)
  end
end
```

---

### M.info()

Get plugin metadata and information.

**Parameters:** None

**Returns:** table with plugin information

**Example:**
```lua
local coach = require("vim-coach")
local info = coach.info()

print("Plugin: " .. info.name)
print("Version: " .. info.version)
print("Commands: " .. info.total_commands)
print("Picker: " .. info.picker)
```

**Output:**
```
Plugin: vim-coach.nvim
Version: 2.0.1
Commands: 120
Picker: snacks.nvim
```

---

## Configuration

The configuration module handles all settings. Access it via `require("vim-coach.config")`.

### config.setup(opts)

Configure the plugin (called automatically by M.setup).

**Parameters:**
- `opts` (table, optional): Configuration options (see M.setup)

**Returns:** nil

**Example:**
```lua
local config = require("vim-coach.config")
config.setup({ window = { border = "round" } })
```

---

### config.get()

Get current configuration.

**Parameters:** None

**Returns:** table with current configuration

**Example:**
```lua
local config = require("vim-coach.config")
local current = config.get()

print("Border style: " .. current.window.border)
print("Copy key: " .. current.keymaps.copy_keymap)
```

---

### config.get_defaults()

Get default configuration (without user modifications).

**Parameters:** None

**Returns:** table with default configuration

**Example:**
```lua
local config = require("vim-coach.config")
local defaults = config.get_defaults()

-- Check if user modified window border
if config.get().window.border ~= defaults.window.border then
  print("User customized border")
end
```

---

## Loader Module

The loader module handles command database loading. Access it via `require("vim-coach.core.loader")`.

### loader.get_all_commands()

Get all commands from all categories (with caching).

**Parameters:** None

**Returns:** array of command tables

**Example:**
```lua
local loader = require("vim-coach.core.loader")
local all_commands = loader.get_all_commands()
print("Total commands: " .. #all_commands)
```

---

### loader.get_by_category(category)

Get commands from a specific category.

**Parameters:**
- `category` (string): "all", "motions", "editing", "visual", or "plugins"

**Returns:** array of command tables

**Example:**
```lua
local loader = require("vim-coach.core.loader")
local editing = loader.get_by_category("editing")
print("Editing commands: " .. #editing)
```

---

### loader.get_categories()

Get list of available categories.

**Parameters:** None

**Returns:** array of category names

**Example:**
```lua
local loader = require("vim-coach.core.loader")
local categories = loader.get_categories()

for _, cat in ipairs(categories) do
  print("- " .. cat)
end
```

**Output:**
```
- all
- motions
- editing
- visual
- plugins
```

---

### loader.clear_cache()

Clear the command cache (forces reload on next call).

**Parameters:** None

**Returns:** nil

**Useful for:**
- Testing
- Reloading commands at runtime
- Freeing memory

**Example:**
```lua
local loader = require("vim-coach.core.loader")

-- Load commands
local commands = loader.get_all_commands()

-- Do something...

-- Clear cache to force reload
loader.clear_cache()

-- Next call will reload from files
local commands_again = loader.get_all_commands()
```

---

## Command Structure

Understanding the command data structure is important for extending vim-coach.

### Command Table

Each command is a Lua table with the following structure:

```lua
{
  name = "Move Right",                          -- Command display name
  keybind = "l",                                -- Keyboard keys
  modes = {"n", "v"},                           -- Modes where it works
  explanation = "Moves cursor one character right",
  beginner_tip = "Use 'l' instead of arrow keys",
  when_to_use = "For moving short distances",
  examples = {
    "l           -- move one character",
    "5l          -- move five characters",
  },
  context_notes = {
    file = "Works in any file",
    editor = "Does not work in insert mode",
  },
  category = "motions",                         -- Added by loader
}
```

### Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | Yes | Display name of the command |
| keybind | string | Yes | Keyboard keys to press |
| modes | array | Yes | Which modes ("n"=normal, "v"=visual, "i"=insert) |
| explanation | string | Yes | What the command does |
| beginner_tip | string | No | Helpful tip for beginners |
| when_to_use | string | No | Practical use cases |
| examples | array | No | Array of usage examples |
| context_notes | table | No | Context-specific information |
| category | string | Added | Category (added by loader) |

### Mode Abbreviations

- "n" - Normal mode (default Vim mode)
- "v" - Visual mode (selecting text)
- "i" - Insert mode (typing)
- "c" - Command-line mode (typing commands)
- "x" - Visual block mode
- "o" - Operator-pending mode

---

## Usage Examples

### Example 1: List All Motion Commands

```lua
local coach = require("vim-coach")
local motions = coach.get_commands("motions")

print("Available motion commands:")
for _, cmd in ipairs(motions) do
  print("  " .. cmd.keybind .. "  -  " .. cmd.name)
end
```

**Output:**
```
Available motion commands:
  j  -  Move Down
  k  -  Move Up
  h  -  Move Left
  l  -  Move Right
  w  -  Jump to Next Word
  ...
```

---

### Example 2: Find Commands by Category Count

```lua
local coach = require("vim-coach")

for _, category in ipairs(coach.info().categories) do
  local commands = coach.get_commands(category)
  print(category .. ": " .. #commands .. " commands")
end
```

**Output:**
```
all: 120 commands
motions: 25 commands
editing: 35 commands
visual: 30 commands
plugins: 30 commands
```

---

### Example 3: Search for Commands by Name Pattern

```lua
local coach = require("vim-coach")

local function search_commands(pattern)
  local all_commands = coach.get_all_commands()
  local results = {}
  
  for _, cmd in ipairs(all_commands) do
    -- Case-insensitive search in command name
    if string.find(cmd.name:lower(), pattern:lower()) then
      table.insert(results, cmd)
    end
  end
  
  return results
end

-- Search for "delete" commands
local delete_commands = search_commands("delete")
for _, cmd in ipairs(delete_commands) do
  print(cmd.keybind .. " - " .. cmd.name)
end
```

**Output:**
```
d - Delete (with motion)
dd - Delete Line
dw - Delete Word
```

---

### Example 4: Display Command Details

```lua
local coach = require("vim-coach")

local function display_command(keybind)
  local all_commands = coach.get_all_commands()
  
  for _, cmd in ipairs(all_commands) do
    if cmd.keybind == keybind then
      print("Command: " .. cmd.name)
      print("Keybind: " .. cmd.keybind)
      print("Explanation: " .. cmd.explanation)
      
      if cmd.beginner_tip then
        print("Tip: " .. cmd.beginner_tip)
      end
      
      if cmd.examples then
        print("Examples:")
        for _, ex in ipairs(cmd.examples) do
          print("  - " .. ex)
        end
      end
      
      return true
    end
  end
  
  print("Command not found: " .. keybind)
  return false
end

-- Display details for "dw"
display_command("dw")
```

**Output:**
```
Command: Delete Word
Keybind: dw
Explanation: Delete from cursor to end of word
Tip: Delete multiple words with 3dw
Examples:
  - dw - delete one word
  - 3dw - delete three words
```

---

### Example 5: Create a Custom Command Searcher

```lua
local coach = require("vim-coach")

-- Create a custom command to search by explanation
vim.api.nvim_create_user_command("CoachSearch", function(opts)
  local search_text = opts.args
  local all_commands = coach.get_all_commands()
  
  print("Search results for: " .. search_text)
  local count = 0
  
  for _, cmd in ipairs(all_commands) do
    local explanation = cmd.explanation:lower()
    if string.find(explanation, search_text:lower()) then
      print(cmd.keybind .. " - " .. cmd.name)
      count = count + 1
    end
  end
  
  print("Found " .. count .. " results")
end, { nargs = 1 })

-- Usage in Neovim:
-- :CoachSearch delete
-- :CoachSearch jump
```

---

## Advanced Usage

### Extending with Custom Commands

See the [Contributing Guide](CONTRIBUTING.md) for adding custom commands.

### Customizing the Picker

See the [Architecture Guide](ARCHITECTURE.md) for extending the UI.

### Troubleshooting API Issues

See the [Troubleshooting Guide](TROUBLESHOOTING.md).

---

## Common Patterns

### Pattern 1: Getting Commands of a Specific Type

```lua
local coach = require("vim-coach")
local all_commands = coach.get_all_commands()

-- Get all commands that work in visual mode
local visual_commands = vim.tbl_filter(function(cmd)
  return vim.tbl_contains(cmd.modes, "v")
end, all_commands)

print("Visual mode commands: " .. #visual_commands)
```

### Pattern 2: Grouping Commands by Category

```lua
local coach = require("vim-coach")
local all_commands = coach.get_all_commands()

local by_category = {}
for _, cmd in ipairs(all_commands) do
  if not by_category[cmd.category] then
    by_category[cmd.category] = {}
  end
  table.insert(by_category[cmd.category], cmd)
end

for category, commands in pairs(by_category) do
  print(category .. ": " .. #commands .. " commands")
end
```

### Pattern 3: Finding Commands Without Examples

```lua
local coach = require("vim-coach")
local all_commands = coach.get_all_commands()

-- Find commands that need more documentation
local needs_examples = vim.tbl_filter(function(cmd)
  return not cmd.examples or #cmd.examples == 0
end, all_commands)

print("Commands needing examples: " .. #needs_examples)
```

---

## Questions?

- Check the [Getting Started Guide](GETTING_STARTED.md) for basics
- Read the [Architecture Guide](ARCHITECTURE.md) for deeper understanding
- See [Contributing Guide](CONTRIBUTING.md) for modification help
- Open an issue if you find a problem
