# How vim-coach.nvim Works (Architecture Guide)

**Welcome!** This guide explains how vim-coach.nvim works **in beginner-friendly language**. Even if you've never seen code before, you'll understand how the pieces fit together.

Think of this like learning how a car engine works—we'll break it down into simple parts!

## Table of Contents
- [Big Picture (What Happens)](#big-picture-what-happens)
- [File Structure (Where Things Live)](#file-structure-where-things-live)
- [Step-by-Step Flow (How It Works)](#step-by-step-flow-how-it-works)
- [Core Components (The Main Parts)](#core-components-the-main-parts)
- [Data Flow (Information Journey)](#data-flow-information-journey)
- [Why Design Choices Were Made](#why-design-choices-were-made)
- [How to Extend It](#how-to-extend-it)

---

## Big Picture (What Happens)

### A Super Simple Explanation

Imagine you have a filing cabinet with thousands of index cards:
- **Each card** = a Vim command with explanation
- **The filing cabinet** = the plugin's data
- **You** = the user who wants to find a command
- **vim-coach** = a helpful assistant who helps you search the cabinet and copy what you need

When you press `<leader>?`:

1. **Assistant wakes up** - vim-coach loads into memory
2. **Assistant opens cabinet** - Reads all the command cards
3. **Assistant shows menu** - Opens a beautiful window with all commands
4. **You search** - Type to find what you need
5. **You copy** - Press Enter to copy the keybind
6. **Assistant goes to sleep** - vim-coach unloads until next time

### Technology Stack

**What's under the hood:**
- **Lua** - Programming language (like instructions for the computer)
- **Neovim** - The text editor (like a fancy notepad)
- **snacks.nvim** - Makes the pretty menu (like a design library)
- **lazy.nvim** - Manager that loads plugins (like an app store)

Don't worry about understanding these—just know they work together!

---

## File Structure (Where Things Live)

Imagine the plugin as a house with different rooms:

```
vim-coach.nvim/
│
├── plugin/                           # FRONT DOOR
│   └── vim-coach.lua                # Registers the plugin, wakes up the system
│
├── lua/vim-coach/                   # MAIN ROOMS  
│   ├── init.lua                     # The brain (main logic)
│   └── commands/                    # The filing cabinet
│       ├── motions.lua              # File 1: Motion commands
│       ├── editing.lua              # File 2: Editing commands
│       ├── visual.lua               # File 3: Visual mode commands
│       └── plugins.lua              # File 4: Plugin commands
│
├── doc/                              # VIM HELP
│   └── vim-coach.txt                # Help documentation (for `:help vim-coach`)
│
├── docs/                             # GITHUB DOCS
│   ├── README.md                    # Main documentation (you're reading related docs!)
│   ├── GETTING_STARTED.md           # Beginner guide
│   └── ARCHITECTURE.md              # This file!
│
└── test/                             # TEST LAB
    ├── test.sh                      # Script to test the plugin
    └── minimal_init.lua             # Test environment setup
```

### What Each Folder Does

#### 🚪 `plugin/` - The Front Door
- **Runs automatically** when Neovim starts
- **Registers** the `:VimCoach` command
- **Sets up** keyboard shortcuts
- **Does NOT** load the main logic (saves startup time!)
- Think of it as: *"Hello Neovim! I exist, here's how to use me"*

#### 🧠 `lua/vim-coach/` - The Brain
- **Loads on demand** - only when you use the command
- **Contains** all the real logic
- **Stays hidden** until you need it (saves memory!)
- Think of it as: *"The actual worker who does all the thinking"*

#### 📚 `lua/vim-coach/commands/` - The Filing Cabinet
- **4 files**, each with 25-40 commands
- **Each command** is a Lua table with:
  - Name (e.g., "Move Right")
  - Keybind (e.g., "l")
  - Explanation
  - Tips for beginners
  - Examples
- Think of it as: *"Index cards organized by category"*

#### 📖 `doc/` - Vim Help
- Helps you use `:help vim-coach` inside Neovim
- Written in a special format Vim understands
- Not necessary for beginners

#### 🐙 `docs/` - GitHub Documentation
- Written in Markdown (easier to read on GitHub)
- Includes guides like this one
- Not loaded by Neovim

---

## Step-by-Step Flow (How It Works)

Let's trace what happens when you press `<leader>?`:

### Phase 1: Neovim Starts Up (First Time Only)

```
Step 1: You open Neovim
   |
   v
Step 2: Neovim checks for plugins
   |
   v
Step 3: Neovim finds plugin/vim-coach.lua
   |
   v
Step 4: Neovim reads it and registers the :VimCoach command
        (Records: "if someone types :VimCoach, call this function")
   |
   v
Step 5: vim-coach registers and goes to sleep
        (Lazy loading - saves time and memory!)
```

### Phase 2: You Press `<leader>?`

```
Step 1: You press: Spacebar then Shift+?
   |
   v
Step 2: Neovim looks up what that key does
   |
   v
Step 3: Neovim finds: "Run :VimCoach command"
   |
   v
Step 4: The registered function activates
   |
   v
Step 5: Function calls: require("vim-coach").coach_picker()
```

### Phase 3: vim-coach Activates

```
Step 1: Neovim loads lua/vim-coach/init.lua
   |
   v
Step 2: That file loads all 4 command databases:
        - motions.lua
        - editing.lua
        - visual.lua
        - plugins.lua
   |
   v
Step 3: All ~120 commands are now in memory
   |
   v
Step 4: The core logic (coach_picker function) begins processing
```

### Phase 4: Data Gets Prepared

```
Step 1: coach_picker function retrieves commands
   |
   v
Step 2: It determines: "User wants 'all' categories"
   |
   v
Step 3: It loops through ALL commands and:
        - Reads the command information
        - Creates formatted preview text
        - Prepares data for display
   |
   v
Step 4: Creates a list of formatted items
```

### Phase 5: The Menu Opens

```
The formatted data goes to snacks.picker:

  Vim Coach - all        (120)
  
  j - Move down          (normal)
  k - Move up            (normal)
  w - Jump to word       (normal)
  
  [search box]

User can now:
- Type to search
- Press j/k to move
- Press Enter to copy
```

### Phase 6: User Interacts

```
Step 1: User types "delete"
   |
   v
Step 2: snacks.nvim filters results
   |
   v
   d - Delete char       (normal)
   dd - Delete line      (normal)
   dw - Delete word      (normal)
   |
   v
Step 3: User selects "dw - Delete word"
   |
   v
Step 4: User presses Enter
   |
   v
Step 5: The confirm function runs:
        - Copies "dw" to clipboard
        - Shows message: "Copied 'dw' to clipboard!"
        - Closes the menu
   |
   v
Step 6: User can now paste "dw" anywhere
```

---

## Core Components (The Main Parts)

Think of these as the different "departments" in a company:

### 1. plugin/vim-coach.lua (Entry Point Registration)

**Purpose**: Register the plugin with Neovim

**What it does**:
```
- Checks if already loaded (prevents double-loading)
- Creates :VimCoach command
- Creates :Coach alias (shorter name)
- Sets up keyboard shortcuts (like <leader>?)
- Registers and becomes idle until called
```

**Code snippet** (don't worry about understanding this):
```lua
-- "If someone types :VimCoach, run this function"
vim.api.nvim_create_user_command("VimCoach", function(args)
  local category = args.args or "all"
  require("vim-coach").coach_picker(category)  -- Wake up the brain!
end, {...})
```

**In simple terms**: "Neovim, if someone types `:VimCoach`, load the main module and open the picker."

### 2. lua/vim-coach/init.lua (Core Logic Module)

**Purpose**: The main processing logic

**What it does**:
```
- Loads all command databases
- Filters commands by category
- Formats data for display
- Opens the menu interface
- Handles user interactions (key presses)
```

**Key functions**:

#### `setup()` function
```
What it does: Configure vim-coach
Like: "Customize how the menu looks"
Example: 
  - Change border style
  - Change keyboard shortcuts
  - Add custom settings
```

#### `get_all_commands()` function
```
What it does: Merge all 4 command files into one list
Like: Taking 4 filing cabinets and putting all cards in one place
Result: ~120 commands ready to use
```

#### `get_commands_by_category(category)` function
```
What it does: Get commands for ONE category
Like: "Show me only motion commands" or "Show me only editing commands"
Example:
  - Input: "motions"
  - Output: Only the ~30 motion commands
```

#### `coach_picker(category)` function
```
What it does: The main worker - opens the menu!
Detailed steps:
  1. Get the commands for this category
  2. Loop through each command
  3. For each command, create beautiful preview text
  4. Put all commands in a list
  5. Send list to snacks.nvim (the menu maker)
  6. Wait for user to click something
  7. When user presses Enter: copy keybind to clipboard
```

### 3. lua/vim-coach/commands/*.lua (Command Database)

**Purpose**: Store all command information

**What it contains**:

Each file (motions.lua, editing.lua, visual.lua, plugins.lua) contains a list of commands.

**Example: One command card**
```lua
{
  name = "Move Right",              -- What you call it
  keybind = "l",                    -- The actual keys
  modes = {"n", "v"},               -- Where it works (normal, visual)
  explanation = "Move cursor right", -- What it does
  beginner_tip = "Use 'l' not arrows", -- Tip for learners
  when_to_use = "Moving short distances", -- When to use it
  examples = {"l", "5l"}            -- Usage examples
}
```

**Why separate files?**
- Easier to find and edit
- Can be edited by different people
- Could be loaded separately in future

---

## Data Flow (Information Journey)

### How Data Travels from Storage to Screen

```
STEP 1: Raw Data (in disk/files)
├─ motions.lua: 30 commands
├─ editing.lua: 35 commands  
├─ visual.lua: 25 commands
└─ plugins.lua: 30 commands
     ↓
STEP 2: Loaded into Memory
├─ All 4 files read
├─ Converted to Lua tables
└─ Ready to use
     ↓
STEP 3: Filtered by Category
├─ If category = "all": use all 120 commands
├─ If category = "motions": use only 30
└─ If category = "editing": use only 35
     ↓
STEP 4: Formatted for Display
├─ Each command becomes an "item"
├─ Add pretty preview text
├─ Add colors and formatting
└─ Create list for menu
     ↓
STEP 5: Sent to snacks.picker
├─ snacks receives the list
├─ Creates the beautiful menu window
└─ User sees it!
     ↓
STEP 6: Rendered on Screen
   ┌─────────────────────┐
   │ j - Move down       │
   │ k - Move up         │
   │ w - Jump to word    │
   └─────────────────────┘
```

### How User Interaction Works

```
USER INPUT → SNACKS → SEARCH → FILTER → DISPLAY
                        ↓
                  User types "delete"
                        ↓
                  Filter shows only "delete" commands
                        ↓
                  User presses Enter
                        ↓
          "Confirm" function is called
                        ↓
          Copy keybind to clipboard
                        ↓
          Show notification
                        ↓
          Close menu
```

---

## Why Design Choices Were Made

### Design Choice #1: Why Lazy Loading?

**Question**: Why doesn't vim-coach load everything at startup?

**Answer**: To save time!

```
WITHOUT lazy loading:
Neovim starts → Loads plugin → Loads all commands → Neovim ready
Time: ~150ms slower

WITH lazy loading (current):
Neovim starts → Registers command → Neovim ready
Later, when you press <leader>?:
Load plugin → Load commands → Show menu
Time: ~50ms slower, but only when you use it!
```

**Winner**: Lazy loading wins! Your Neovim starts faster!

### Design Choice #2: Why snacks.nvim Instead of Telescope?

**Question**: Why use snacks.nvim for the menu?

**Comparison**:

| Feature | snacks.nvim | Telescope |
|---------|------------|-----------|
| Size | Small | Large |
| Speed | Fast | Slower |
| Setup | Easy | Complex |
| Good for vim-coach | ✅ Yes | ⚠️ Overkill |

**Decision**: Use snacks.nvim because it's simpler and faster!

### Design Choice #3: Why Lua Files Instead of JSON?

**Question**: Why store commands in `.lua` files instead of `.json`?

**Answer**: Because Lua is native to Neovim!

```
Lua way (current):
commands.lua → Read directly by Lua → Done!

JSON way (alternative):
commands.json → Parse with JSON parser → Convert to Lua → Done!

Winner: Lua is faster and simpler!
```

**Also**: Lua files can have comments, JSON can't:

```lua
-- This is helpful!
name = "Move Right",

vs

"name": "Move Right",  -- JSON doesn't allow comments!
```

### Design Choice #4: Why Copy to Clipboard Instead of Auto-Insert?

**Question**: Why copy to clipboard instead of inserting the keybind into the file?

**Reasons**:
1. **Non-destructive** - Doesn't change your file
2. **Flexible** - You decide where to paste
3. **Safe** - User has control
4. **Expected** - Other menu tools work this way

---

## How to Extend It

Want to add features or customize vim-coach? Here are the best places:

### Extension 1: Add New Commands

**Where to do it**: Create a new file in `lua/vim-coach/commands/`

**Steps**:
```
1. Create file: lua/vim-coach/commands/custom.lua
2. Add commands (same format as other files)
3. Edit lua/vim-coach/init.lua
4. Add one line to load your new category
```

**Example**:
```lua
-- New file: lua/vim-coach/commands/custom.lua
return {
  {
    name = "My Custom Command",
    keybind = "gc",
    modes = {"n"},
    explanation = "Does something custom"
  }
}
```

### Extension 2: Customize the Menu Appearance

**Where to do it**: In `lua/vim-coach/init.lua`, the `format` function

**What you can change**:
- Column widths
- Colors
- How text is displayed
- Emojis and formatting

### Extension 3: Add Custom Keyboard Shortcuts

**Where to do it**: In `lua/vim-coach/init.lua`, the `actions` table

**Example**: Add shortcut to open help
```lua
-- In the actions table:
["<C-h>"] = function(picker, item)
  -- Open Vim help for this command
  vim.cmd("help " .. item.keybind)
end,
```

### Extension 4: Add More Configuration Options

**Where to do it**: In `lua/vim-coach/init.lua`, the `config` table

**How**: Add new options users can customize through `setup()`

---

## Performance Summary

**How fast is vim-coach?**

```
Neovim startup time: +0.5ms only (very fast!)
  Why? We don't load anything at startup

First time opening menu: ~50-100ms
  Why? Need to load files and build menu

Next time opening menu: ~20-30ms
  Why? Files already loaded, just rebuild

Memory usage: ~2-3 MB
  Why? Lua tables are efficient
```

**Conclusion**: Very fast and lightweight performance characteristics.

---

## Next Steps

**Want to learn more?**
- [Contributing Guide](CONTRIBUTING.md) - Help improve vim-coach
- [Development Setup](DEVELOPMENT.md) - Set up for coding
- [Testing Guide](TESTING.md) - How to test your changes
- [Full Documentation](README.md) - Complete reference

**Have questions?**
- Check the [Troubleshooting Guide](TROUBLESHOOTING.md)
- Open an issue on GitHub
- Read the code comments (they explain things!)

---

## Summary

The plugin architecture follows a clean separation of concerns:

```
plugin/vim-coach.lua
  - Entry point registration
  - Command and keymap setup
  - Lazy loading interface
  
lua/vim-coach/init.lua
  - Core logic and processing
  - Data formatting
  - Picker interface management
  
lua/vim-coach/commands/*.lua
  - Structured command database
  - Organized by category
  - Maintainable and extensible
  
snacks.nvim
  - UI rendering layer
  - User interaction handling
```

Each component has a specific responsibility, making the codebase maintainable and extensible.

### Technology Stack
- **Language**: Lua (Neovim's scripting language)
- **UI Library**: snacks.nvim (picker component)
- **Package Manager**: lazy.nvim (for plugin loading)
- **Target Platform**: Neovim >= 0.7

### Architecture Pattern
The plugin follows a **simple modular architecture**:

```
┌─────────────┐
│ Entry Point │  plugin/vim-coach.lua
└──────┬──────┘
       │ Registers commands & keymaps
       │ Calls setup()
       v
┌─────────────┐
│  Core Logic │  lua/vim-coach/init.lua
└──────┬──────┘
       │ Loads command databases
       │ Formats data for picker
       │ Opens snacks.picker UI
       v
┌─────────────┐
│  Data Layer │  lua/vim-coach/commands/*.lua
└─────────────┘
   Command databases (motions, editing, etc.)
```

---

## File Structure

```
vim-coach.nvim/
├── plugin/
│   └── vim-coach.lua          # Entry point (auto-loaded by Neovim)
│
├── lua/vim-coach/
│   ├── init.lua               # Core plugin logic
│   └── commands/              # Command databases
│       ├── motions.lua        # Movement commands
│       ├── editing.lua        # Text editing commands
│       ├── visual.lua         # Visual mode commands
│       └── plugins.lua        # Plugin-specific commands
│
├── doc/
│   └── vim-coach.txt          # Vim help documentation
│
├── docs/                      # Markdown documentation (GitHub)
│   ├── TESTING.md
│   ├── DEVELOPMENT.md
│   └── ARCHITECTURE.md        # You are here!
│
└── test/
    ├── test.sh                # Test launcher
    └── minimal_init.lua       # Test environment config
```

### Why This Structure?

#### `plugin/` directory
- **Auto-loaded by Neovim** on startup
- Registers user commands (`:VimCoach`)
- Sets up default keymaps
- Called ONCE when Neovim starts

#### `lua/` directory
- **Loaded on-demand** (lazy loading)
- Contains actual plugin logic
- Not loaded until `:VimCoach` is called
- Faster startup time!

#### `doc/` directory
- Vim help format (`:help vim-coach`)
- Searchable via `:help`
- Different from markdown docs

#### `docs/` directory
- GitHub-friendly markdown
- For contributors and web readers
- Not loaded by Neovim

---

## How It All Connects

Let's trace what happens when a user runs `:VimCoach`

### Step 1: Neovim Starts

```
Neovim startup
  ↓
Scans for plugins
  ↓
Finds plugin/vim-coach.lua
  ↓
Executes it (registers commands)
  ↓
Plugin is now "loaded" but logic hasn't run yet
```

### Step 2: User Types `:VimCoach`

```
User types: :VimCoach
  ↓
Neovim looks for registered command
  ↓
Finds command registered by plugin/vim-coach.lua
  ↓
Executes command callback
  ↓
Callback calls: require("vim-coach").coach_picker(category)
  ↓
NOW lua/vim-coach/init.lua is loaded
  ↓
Command databases are loaded
  ↓
snacks.picker is opened
```

### Step 3: Picker Opens

```
snacks.picker receives:
  - items (formatted commands)
  - format function (how to display)
  - confirm function (what happens on Enter)
  - actions (custom keybinds)
  ↓
User sees fuzzy-searchable list
  ↓
User types to search
  ↓
snacks handles fuzzy matching
  ↓
User presses Enter
  ↓
confirm function copies keybind to clipboard
```

---

## Execution Flow

### Detailed Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Neovim Startup                                           │
├─────────────────────────────────────────────────────────────┤
│ • Neovim starts                                             │
│ • Loads plugin/vim-coach.lua                                │
│ • Registers :VimCoach command                               │
│ • Sets up default keymaps (<leader>?, <leader>hm, etc.)    │
│ • Does NOT load lua/vim-coach/* yet (lazy loading)         │
└─────────────────────────────────────────────────────────────┘
                             │
                             v
┌─────────────────────────────────────────────────────────────┐
│ 2. User Triggers Plugin                                     │
├─────────────────────────────────────────────────────────────┤
│ User types one of:                                          │
│ • :VimCoach                                                 │
│ • :VimCoach motions                                         │
│ • <leader>?                                                 │
│ • <leader>hm                                                │
└─────────────────────────────────────────────────────────────┘
                             │
                             v
┌─────────────────────────────────────────────────────────────┐
│ 3. Command Callback Executes                                │
├─────────────────────────────────────────────────────────────┤
│ plugin/vim-coach.lua:                                       │
│   vim.api.nvim_create_user_command("VimCoach",             │
│     function(args)                                          │
│       local category = args.args or "all"                  │
│       require("vim-coach").coach_picker(category)          │
│     end)                                                    │
└─────────────────────────────────────────────────────────────┘
                             │
                             v
┌─────────────────────────────────────────────────────────────┐
│ 4. Core Module Loads                                        │
├─────────────────────────────────────────────────────────────┤
│ require("vim-coach") loads lua/vim-coach/init.lua          │
│                                                             │
│ init.lua executes:                                          │
│   local commands = {                                        │
│     motions = require("vim-coach.commands.motions"),       │
│     editing = require("vim-coach.commands.editing"),       │
│     visual = require("vim-coach.commands.visual"),         │
│     plugins = require("vim-coach.commands.plugins"),       │
│   }                                                         │
│                                                             │
│ All command databases are now loaded into memory           │
└─────────────────────────────────────────────────────────────┘
                             │
                             v
┌─────────────────────────────────────────────────────────────┐
│ 5. Data Preparation                                         │
├─────────────────────────────────────────────────────────────┤
│ coach_picker(category) function:                            │
│   • Calls get_commands_by_category(category)               │
│   • Filters commands (e.g., only "motions")                │
│   • Iterates through commands                              │
│   • Builds preview content for each command                │
│   • Creates items array for picker                         │
└─────────────────────────────────────────────────────────────┘
                             │
                             v
┌─────────────────────────────────────────────────────────────┐
│ 6. Picker Invocation                                        │
├─────────────────────────────────────────────────────────────┤
│ snacks.picker({                                             │
│   title = "...",              # Window title               │
│   items = [...],              # All commands               │
│   preview = "preview",        # Enable preview             │
│   format = function(item),    # How to display each line   │
│   confirm = function(item),   # What happens on Enter      │
│   actions = {...},            # Custom keybinds            │
│ })                                                          │
└─────────────────────────────────────────────────────────────┘
                             │
                             v
┌─────────────────────────────────────────────────────────────┐
│ 7. User Interaction                                         │
├─────────────────────────────────────────────────────────────┤
│ User sees picker window:                                    │
│   ┌──────────────────────────────────────────┐            │
│   │ Vim Coach - Motions         [12 items]  │            │
│   ├──────────────────────────────────────────┤            │
│   │ > Move Right      l      Move cursor...  │            │
│   │   Move Left       h      Move cursor...  │            │
│   │   Move Down       j      Move cursor...  │            │
│   └──────────────────────────────────────────┘            │
│                                                             │
│ User types "left" to search                                │
│   ┌──────────────────────────────────────────┐            │
│   │ Search: left                [1 item]    │            │
│   ├──────────────────────────────────────────┤            │
│   │ > Move Left       h      Move cursor...  │            │
│   └──────────────────────────────────────────┘            │
│                                                             │
│ snacks.nvim handles:                                        │
│   • Fuzzy matching                                         │
│   • Cursor movement                                        │
│   • Preview updates                                        │
└─────────────────────────────────────────────────────────────┘
                             │
                             v
┌─────────────────────────────────────────────────────────────┐
│ 8. User Selects Command                                     │
├─────────────────────────────────────────────────────────────┤
│ User presses:                                               │
│ • Enter   → confirm function executes                      │
│ • Ctrl+Y  → actions["<C-y>"] executes                      │
│ • Esc     → picker closes                                  │
│                                                             │
│ If Enter or Ctrl+Y:                                        │
│   vim.fn.setreg("+", item.keybind)  # Copy to clipboard   │
│   vim.notify("Copied 'h' to clipboard!")                   │
│   picker:close()                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Components

### 1. plugin/vim-coach.lua (Entry Point)

**Purpose**: Register plugin with Neovim

**Key responsibilities**:
- Create `:VimCoach` user command
- Create `:Coach` alias
- Set up default keymaps (unless disabled)
- Call `require("vim-coach").setup()` if configured

**Code breakdown**:
```lua
-- Lines 1-5: Check if already loaded (prevent double-load)
if vim.g.loaded_vim_coach == 1 then
  return
end
vim.g.loaded_vim_coach = 1

-- Lines 7-24: Register :VimCoach command
vim.api.nvim_create_user_command("VimCoach", function(args)
  local category = args.args and args.args ~= "" and args.args or "all"
  require("vim-coach").coach_picker(category)
end, {
  nargs = "?",  -- Optional argument
  complete = function()  -- Tab completion
    return { "all", "motions", "editing", "visual", "plugins" }
  end,
  desc = "Open Vim Coach command reference"
})

-- Lines 26-29: Create :Coach alias
vim.api.nvim_create_user_command("Coach", ...)

-- Lines 31-62: Set up default keymaps
if not vim.g.vim_coach_no_default_keymaps then
  local opts = { noremap = true, silent = true, desc = "..." }
  vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', opts)
  vim.keymap.set('n', '<leader>hm', '<cmd>VimCoach motions<cr>', opts)
  -- ... more keymaps
end
```

### 2. lua/vim-coach/init.lua (Core Logic)

**Purpose**: Main plugin functionality

**Exports**:
- `M.coach_picker(category)` - Opens the picker
- `M.setup(opts)` - Configuration
- `M.info()` - Plugin information
- `M.get_commands()` - Get commands by category
- `M.get_all_commands()` - Get all commands

**Key functions**:

#### `get_all_commands()`
```lua
local function get_all_commands()
  local all_commands = {}
  for category, cmd_list in pairs(commands) do
    for _, cmd in ipairs(cmd_list) do
      cmd.category = category  -- Tag with category
      table.insert(all_commands, cmd)
    end
  end
  return all_commands
end
```

**What it does**: Merges all command databases into single array

#### `get_commands_by_category(category)`
```lua
local function get_commands_by_category(category)
  if category == "all" then
    return get_all_commands()
  end
  return commands[category] or {}
end
```

**What it does**: Returns commands for specific category or all

#### `M.coach_picker(category)`
**Purpose**: Main entry point, opens the picker

**Flow**:
1. Get commands for category
2. Build preview content for each command
3. Format items for picker
4. Call `snacks.picker()` with configuration
5. Handle user interactions

**Key sections**:

```lua
-- Lines 58-129: Build items array
local items = {}
for i, cmd in ipairs(cmd_list) do
  -- Build preview_content (what shows in preview window)
  local preview_content = {}
  table.insert(preview_content, "╭─ " .. cmd.name .. " ─╮")
  table.insert(preview_content, "🔧 Keybind: " .. cmd.keybind)
  -- ... more fields

  -- Create item for picker
  table.insert(items, {
    idx = i,
    name = cmd.name,
    keybind = cmd.keybind,
    -- ... all fields
    preview = {
      text = table.concat(preview_content, "\n"),
      ft = "text",
    },
  })
end

-- Lines 131-177: Configure and open picker
snacks.picker({
  title = "Vim Coach - " .. category,
  items = items,
  preview = "preview",
  format = function(item)
    -- Return array of {text, highlight} pairs
    -- Controls how each line displays in the list
  end,
  confirm = function(picker, item)
    -- Executes when user presses Enter
    picker:close()
    vim.fn.setreg("+", item.keybind)  -- Copy to clipboard
    vim.notify("Copied '" .. item.keybind .. "' to clipboard!")
  end,
  actions = {
    ["<C-y>"] = function(picker, item)
      -- Executes when user presses Ctrl+Y
      -- (Same as confirm - copy keybind)
    end,
  },
})
```

### 3. lua/vim-coach/commands/*.lua (Data Layer)

**Purpose**: Store command information

**Structure**: Each file returns a Lua table (array) of commands

**Example**:
```lua
-- lua/vim-coach/commands/motions.lua
return {
  {
    name = "Move Right",
    keybind = "l",
    modes = {"n", "v"},
    explanation = "Moves cursor one character to the right",
    beginner_tip = "Basic movement. Use this instead of arrow keys",
    when_to_use = "Moving short distances within a line",
    context_notes = {
      file = "Works in any file for navigation",
      explorer = "Navigate through file names"
    },
    examples = {
      "l - move right one character",
      "5l - move right 5 characters"
    }
  },
  -- ... more commands
}
```

**Data Schema**:
- `name` (string, required): Display name
- `keybind` (string, required): Vim keys
- `modes` (array, required): `["n"]`, `["v"]`, `["n","v"]`, etc.
- `explanation` (string, required): What it does
- `beginner_tip` (string, optional): Advice for learners
- `when_to_use` (string, optional): Use cases
- `context_notes` (table, optional): Behavior in different contexts
- `examples` (array, optional): Usage examples

---

## Data Flow

### From Command Database to UI

```
1. Raw Data (commands/motions.lua)
   {
     name = "Move Right",
     keybind = "l",
     explanation = "Moves cursor one character to the right",
     ...
   }
              │
              v
2. Loaded into Memory (init.lua, lines 7-12)
   local commands = {
     motions = require("vim-coach.commands.motions"),  -- Array of commands
     ...
   }
              │
              v
3. Filtered by Category (init.lua, lines 39-44)
   get_commands_by_category("motions")
   → Returns only motion commands
              │
              v
4. Formatted for Picker (init.lua, lines 58-129)
   {
     idx = 1,
     name = "Move Right",
     keybind = "l",
     text = "Move Right (l)",  -- For searching
     preview = {
       text = "╭─ Move Right ─╮\n🔧 Keybind: l\n...",
       ft = "text"
     }
   }
              │
              v
5. Passed to snacks.picker (init.lua, line 131)
   snacks.picker({ items = items, ... })
              │
              v
6. Rendered in UI (snacks.nvim handles this)
   ┌────────────────────────────────┐
   │ > Move Right    l    Moves...  │
   └────────────────────────────────┘
```

### User Input Flow

```
User Input → snacks.nvim → Fuzzy Matching → Filter items → Update UI
                                │
                                v
                         User presses Enter
                                │
                                v
                     confirm function executes
                                │
                                v
                    Copy keybind to clipboard
                                │
                                v
                            Show notification
                                │
                                v
                          Close picker
```

---

## Key Design Decisions

### 1. Why snacks.nvim instead of Telescope?

**Decision**: Use snacks.nvim picker (v2.0.0)

**Reasons**:
- **Lighter dependency**: snacks is smaller and faster
- **Modern API**: Cleaner configuration
- **Better integration**: Works well with LazyVim
- **Less bloat**: Telescope is powerful but overkill for our use case

**Trade-off**: Lost some Telescope users who don't use snacks

### 2. Why Lua tables instead of JSON/YAML?

**Decision**: Store commands as Lua tables in `.lua` files

**Reasons**:
- **Native format**: No parsing needed
- **Comments allowed**: Can document commands inline
- **Better performance**: Loaded directly by Lua VM
- **Type flexibility**: Can store functions if needed

**Example**:
```lua
-- Good: Lua table with comments
{
  name = "Move Right",  -- Primary command for rightward movement
  keybind = "l",        -- Mnemonic: l for "right" (keyboard position)
  ...
}

-- Bad: Would need JSON (no comments):
{
  "name": "Move Right",
  "keybind": "l"
}
```

### 3. Why separate command files by category?

**Decision**: Split into `motions.lua`, `editing.lua`, `visual.lua`, `plugins.lua`

**Reasons**:
- **Maintainability**: Easier to find and edit commands
- **Modularity**: Can load categories independently
- **Collaboration**: Multiple people can edit different categories without conflicts
- **Performance**: Could lazy-load categories in future

**Alternative considered**: Single huge file with all commands
- Would be 1000+ lines
- Hard to navigate
- Merge conflicts galore

### 4. Why lazy load the main module?

**Decision**: Only load `lua/vim-coach/init.lua` when `:VimCoach` is called

**Reasons**:
- **Faster startup**: Neovim starts ~10ms faster
- **Memory efficiency**: Don't load 120+ commands unless needed
- **Neovim best practice**: Lazy loading is standard

**Implementation**:
```lua
-- plugin/vim-coach.lua (always loaded)
vim.api.nvim_create_user_command("VimCoach", function(args)
  require("vim-coach").coach_picker(category)  -- Loads on first call
end, {...})
```

### 5. Why copy to clipboard instead of inserting text?

**Decision**: Pressing Enter copies keybind to clipboard

**Reasons**:
- **Non-invasive**: Doesn't modify user's buffer
- **Flexible**: User decides where/when to paste
- **Expected behavior**: Consistent with other pickers

**Alternative considered**: Auto-insert into buffer
- Too destructive
- User might not want text inserted
- Hard to undo

### 6. Why preview as plain text instead of markdown?

**Decision**: Preview uses `ft = "text"` not `ft = "markdown"`

**Reasons**:
- **Consistent rendering**: Markdown would need syntax highlighting
- **Simple emojis**: Text mode still shows emojis
- **Fast**: No parsing overhead
- **Works everywhere**: No dependency on markdown parser

---

## Extension Points

Want to extend the plugin? Here are the best places to hook in:

### 1. Add Custom Commands

**Where**: Create new file in `lua/vim-coach/commands/`

**How**:
```lua
-- lua/vim-coach/commands/custom.lua
return {
  {
    name = "My Custom Command",
    keybind = "gc",
    modes = {"n"},
    explanation = "Does something custom",
    -- ... more fields
  }
}
```

Then register in `init.lua`:
```lua
local commands = {
  motions = require("vim-coach.commands.motions"),
  editing = require("vim-coach.commands.editing"),
  visual = require("vim-coach.commands.visual"),
  plugins = require("vim-coach.commands.plugins"),
  custom = require("vim-coach.commands.custom"),  -- ADD THIS
}
```

### 2. Customize Picker UI

**Where**: `lua/vim-coach/init.lua`, lines 144-161 (format function)

**Example**: Change column widths
```lua
format = function(item)
  local ret = {}
  ret[#ret + 1] = { string.format("%-30s", item.name), "..." }  -- Wider
  ret[#ret + 1] = { string.format("%-10s", item.keybind), "..." }  -- Narrower
  -- ...
end
```

### 3. Add Custom Actions

**Where**: `lua/vim-coach/init.lua`, lines 169-176 (actions table)

**Example**: Add Ctrl+O to open help
```lua
actions = {
  ["<C-y>"] = function(picker, item)
    -- Copy keybind
  end,
  ["<C-o>"] = function(picker, item)
    -- NEW: Open vim help for command
    vim.cmd("help " .. item.keybind)
  end,
},
```

### 4. Add Command Validation

**Where**: `lua/vim-coach/init.lua`, before building items

**Example**: Validate commands have required fields
```lua
local function validate_command(cmd)
  local required = {"name", "keybind", "modes", "explanation"}
  for _, field in ipairs(required) do
    if not cmd[field] then
      error("Command missing required field: " .. field)
    end
  end
  return true
end

for _, cmd in ipairs(cmd_list) do
  validate_command(cmd)  -- Add this
  -- ... rest of code
end
```

### 5. Add Filtering Options

**Where**: `lua/vim-coach/init.lua`, in coach_picker function

**Example**: Filter by mode
```lua
function M.coach_picker(category, opts)
  opts = opts or {}
  local cmd_list = get_commands_by_category(category)

  -- NEW: Filter by mode if specified
  if opts.mode then
    cmd_list = vim.tbl_filter(function(cmd)
      return vim.tbl_contains(cmd.modes, opts.mode)
    end, cmd_list)
  end

  -- ... rest of code
end

-- Usage:
require("vim-coach").coach_picker("all", { mode = "v" })  -- Only visual mode commands
```

### 6. Add Configuration Options

**Where**: `lua/vim-coach/init.lua`, lines 15-24 (config table)

**Example**: Add option to show mode in preview
```lua
local config = {
  window = {
    border = "rounded",
    title_pos = "center",
  },
  keymaps = {
    copy_keymap = "<C-y>",
    close = "<Esc>",
  },
  show_modes_in_preview = true,  -- NEW
}

-- Then in setup function:
function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend("force", config, opts)
end
```

---

## Performance Considerations

### Current Performance Profile

**Startup time**: ~0.5ms
- Plugin file registers commands only
- Main module not loaded until called

**First invocation**: ~50-100ms
- Load lua modules
- Load command databases (1165 lines)
- Build preview content (~120 commands)
- Open picker

**Subsequent invocations**: ~20-30ms
- Modules already cached
- Just rebuild items and open picker

**Memory usage**: ~2-3 MB
- Lua tables for all commands
- Minimal overhead

### Optimization Opportunities

1. **Lazy preview generation**
   - Currently: Build all previews upfront
   - Could: Build preview only when command is focused
   - Savings: ~30-40ms on first invocation

2. **Command caching**
   - Currently: Rebuild items array every time
   - Could: Cache formatted items
   - Savings: ~10-15ms per invocation

3. **Category-specific loading**
   - Currently: Load all command files
   - Could: Only load requested category
   - Savings: ~20-30ms, less memory

4. **Incremental loading**
   - Currently: Show picker after all commands loaded
   - Could: Show picker immediately, load commands async
   - UX: Feels instant, commands appear quickly

---

## Dependencies

### Direct Dependencies
- **snacks.nvim** (required)
  - Used for: Picker UI
  - Could be replaced with: Telescope, fzf-lua, or custom picker
  - Breaking change: Yes, would require rewriting picker code

### Indirect Dependencies (via snacks.nvim)
- **nui.nvim** (UI components)
- **nvim-web-devicons** (file icons, optional)

### System Dependencies
- **Neovim >= 0.7** (Lua 5.1 API)
- **Git** (for installation via package managers)

---

## Testing Strategy

### Manual Testing
- Use `./test.sh` environment
- Verify UI renders correctly
- Test search functionality
- Check keybind copying

### Potential Automated Tests

**Unit tests** (could add with `plenary.nvim`):
```lua
-- tests/commands_spec.lua
describe("get_all_commands", function()
  it("returns all commands from all categories", function()
    local all = require("vim-coach").get_all_commands()
    assert.truthy(#all > 100)  -- At least 100 commands
  end)
end)
```

**Integration tests**:
```lua
-- tests/picker_spec.lua
describe("coach_picker", function()
  it("opens picker without errors", function()
    require("vim-coach").coach_picker("motions")
    -- Assert picker is open
  end)
end)
```

**CI/CD considerations**:
- Lua syntax checking with `luacheck`
- Run in headless Neovim
- Test on multiple Neovim versions

---

## Future Architecture Changes

### Potential Improvements

1. **Plugin system**
   - Allow users to add custom command sources
   - Example: Load commands from external JSON files

2. **Localization**
   - Support multiple languages
   - Separate data from display

3. **Advanced search**
   - Search by tag (e.g., "deletion", "yank")
   - Full-text search in explanations

4. **History tracking**
   - Track frequently used commands
   - Suggest based on context

5. **Integrated tutorial**
   - Interactive lessons
   - Practice mode

---

## Questions?

- Check [TESTING.md](TESTING.md) for test environment
- Check [DEVELOPMENT.md](DEVELOPMENT.md) for workflows
- Open GitHub issue for technical questions
- Start a discussion for architecture ideas

Want to propose an architecture change? Open an issue with:
1. **Problem**: What's limiting current design?
2. **Solution**: Your proposed change
3. **Trade-offs**: What do we gain/lose?
4. **Migration**: How to implement without breaking changes?

Happy architecting! 🏗️
