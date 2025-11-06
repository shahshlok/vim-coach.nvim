# Development Workflow Guide

A practical guide for developing vim-coach.nvim, from making your first change to submitting a pull request.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Common Tasks](#common-tasks)
- [Testing Your Changes](#testing-your-changes)
- [Code Style](#code-style)
- [Submitting Changes](#submitting-changes)

---

## Prerequisites

### Required
- **Git** - Version control
- **Neovim >= 0.7** - For testing
- **Text editor** - Any editor (VS Code, Zed, Vim, etc.)

### Recommended (but not required)
- **Basic Lua knowledge** - Helpful but not necessary for simple changes
- **LazyVim setup** - To test in your actual environment

### No Experience? No Problem!
This guide assumes you're new to:
- Neovim plugin development
- Lua programming
- Open source contribution

We'll walk through everything step by step!

---

## Getting Started

### 1. Fork and Clone

```bash
# Fork the repository on GitHub (click "Fork" button)

# Clone YOUR fork
git clone https://github.com/YOUR_USERNAME/vim-coach.nvim.git
cd vim-coach.nvim
```

### 2. Create a Branch

```bash
# Create a feature branch tied to the issue number
git checkout -b 42_add_macro_commands

# Or for bug fixes:
git checkout -b 87_fix_search_crash
```

> Branch names **must** follow `issueNumber_branch_title` (e.g. `10_add_testing_env`). Open an issue before branching so the number is ready.

### 3. Set Up Testing

```bash
# Make test script executable
chmod +x test.sh

# Run it (first time takes 1-2 minutes)
./test.sh
```

You're now ready to develop! 🎉

---

## Development Workflow

### The Quick Version

```bash
# 1. Edit code
vim lua/vim-coach/commands/motions.lua

# 2. Test changes
./test.sh

# 3. Try your changes in Neovim
:VimCoach

# 4. Quit and iterate
# Press 'q' in test environment

# 5. Repeat steps 1-4 until satisfied
```

### The Detailed Version

#### Step 1: Understand What You Want to Change

**Before writing code**, answer:
- What feature am I adding?
- What bug am I fixing?
- Which files need to change?

**Example**: "I want to add the `qa` command for recording macros"

Files to edit:
- `lua/vim-coach/commands/editing.lua` (add the command)

#### Step 2: Find the Right File

```
vim-coach.nvim/
├── lua/vim-coach/
│   ├── init.lua              # Core logic (picker, formatting)
│   └── commands/
│       ├── motions.lua       # Movement commands (h,j,k,l,w,b,etc)
│       ├── editing.lua       # Text editing (i,a,d,c,y,p,etc)
│       ├── visual.lua        # Visual mode (v,V,Ctrl-v,etc)
│       └── plugins.lua       # Plugin commands (Telescope,etc)
└── plugin/
    └── vim-coach.lua         # Entry point, registers commands
```

**Quick guide:**
- Adding a command? → `lua/vim-coach/commands/*.lua`
- Changing UI/picker? → `lua/vim-coach/init.lua`
- Changing default keymaps? → `plugin/vim-coach.lua`

#### Step 3: Make Your Changes

**Example: Adding a new command**

Edit `lua/vim-coach/commands/editing.lua`:

```lua
return {
  -- ... existing commands ...

  -- Add this new entry:
  {
    name = "Start Recording Macro",
    keybind = "qa",
    modes = {"n"},
    explanation = "Starts recording a macro into register 'a'. Press q again to stop recording.",
    beginner_tip = "Macros let you record a sequence of commands and replay them. Super powerful for repetitive tasks!",
    when_to_use = "When you need to repeat the same series of edits multiple times",
    context_notes = {
      file = "Records all commands until you press q again",
      explorer = "Works but rarely useful in file explorers",
    },
    examples = {
      "qa - start recording to register a",
      "q - stop recording",
      "@a - replay macro from register a",
      "5@a - replay macro 5 times"
    }
  },

  -- ... more commands ...
}
```

**Key fields explained:**
- `name` - Human-readable command name
- `keybind` - Actual Vim keys (what user types)
- `modes` - `"n"` (normal), `"v"` (visual), `"i"` (insert)
- `explanation` - Clear description of what it does
- `beginner_tip` - Helpful advice for learners
- `when_to_use` - Practical use cases
- `context_notes` - Behavior in different contexts
- `examples` - Practical usage examples

#### Step 4: Test Your Changes

```bash
./test.sh
```

Inside Neovim:
```
:VimCoach editing    # Open editing commands
# Search for "macro" or "qa"
# Verify your new command appears
# Check the preview looks good
```

#### Step 5: Iterate

Found an issue? Exit (`:qa!` or `q`), edit the file, run `./test.sh` again!

**Common iteration cycles:**
- Fix typos in explanation
- Add more examples
- Adjust formatting
- Test keybind copying works

#### Step 6: Test Edge Cases

```bash
./test.sh
```

Try these scenarios:
- Search for your command by name
- Search by keybind
- Press `Enter` to copy keybind
- Press `Ctrl+Y` to copy keybind
- Check preview text wraps nicely
- Try with different categories

---

## Common Tasks

### Adding a New Command

**Location**: `lua/vim-coach/commands/{category}.lua`

**Template**:
```lua
{
  name = "Command Name",
  keybind = "key",
  modes = {"n", "v"},  -- n=normal, v=visual, i=insert
  explanation = "Clear, concise explanation of what this does",
  beginner_tip = "Why beginners should care about this command",
  when_to_use = "Specific scenarios where this is useful",
  context_notes = {
    file = "How it behaves in regular files",
    explorer = "How it behaves in file explorers",
  },
  examples = {
    "key - basic usage",
    "5key - with count prefix",
    "key$ - combined with motion",
  }
}
```

**Steps**:
1. Open the appropriate command file
2. Find similar command for reference
3. Copy-paste and modify
4. Test with `./test.sh`

### Updating an Existing Command

**Example**: Add more examples to the `dd` command

1. Find the command:
```bash
# Search for it
grep -r "dd" lua/vim-coach/commands/
```

2. Edit the file:
```lua
{
  name = "Delete Line",
  keybind = "dd",
  -- ... existing fields ...
  examples = {
    "dd - delete current line",
    "5dd - delete 5 lines",
    "dG - delete from here to end of file",  -- NEW!
  }
}
```

3. Test:
```bash
./test.sh
:VimCoach editing  # Verify the change
```

### Changing the Picker UI

**Location**: `lua/vim-coach/init.lua`

**Example**: Change how commands are displayed

Find the `format` function (around line 144):
```lua
format = function(item)
  local ret = {}

  -- Change column widths:
  ret[#ret + 1] = { string.format("%-30s", item.name), "SnacksPickerLabel" }  -- Wider name
  ret[#ret + 1] = { string.format("%-15s", item.keybind), "SnacksPickerSpecial" }  -- Wider keybind

  -- ... rest of function
end
```

### Adding a New Category

**Example**: Add "window management" commands

**Step 1**: Create new command file
```bash
touch lua/vim-coach/commands/windows.lua
```

**Step 2**: Add commands
```lua
-- lua/vim-coach/commands/windows.lua
return {
  {
    name = "Split Window Horizontally",
    keybind = ":split",
    modes = {"n"},
    explanation = "Splits the current window horizontally",
    -- ... more fields
  },
  -- ... more commands
}
```

**Step 3**: Register in init.lua

Edit `lua/vim-coach/init.lua` around line 7:
```lua
local commands = {
  motions = require("vim-coach.commands.motions"),
  editing = require("vim-coach.commands.editing"),
  visual = require("vim-coach.commands.visual"),
  plugins = require("vim-coach.commands.plugins"),
  windows = require("vim-coach.commands.windows"),  -- ADD THIS
}
```

**Step 4**: Add command and keymap

Edit `plugin/vim-coach.lua`:
```lua
-- Add command
vim.api.nvim_create_user_command("VimCoach", function(args)
  local category = args.args
  if category == "" then category = "all" end
  require("vim-coach").coach_picker(category)
end, {
  nargs = "?",
  complete = function()
    return { "all", "motions", "editing", "visual", "plugins", "windows" }  -- Add "windows"
  end,
})

-- Add keymap
vim.keymap.set('n', '<leader>hw', '<cmd>VimCoach windows<cr>', { desc = 'Vim Coach - Windows' })
```

**Step 5**: Test
```bash
./test.sh
:VimCoach windows  # Try your new category!
```

### Changing Default Keymaps

**Location**: `plugin/vim-coach.lua`

**Example**: Change `<leader>?` to `<F1>`

```lua
-- Before:
vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', opts)

-- After:
vim.keymap.set('n', '<F1>', '<cmd>VimCoach<cr>', opts)
```

Test:
```bash
./test.sh
# Press F1 instead of <leader>?
```

---

## Testing Your Changes

### Quick Test (30 seconds)

```bash
./test.sh
:VimCoach  # Try your changes
:qa!       # Quit
```

### Thorough Test (5 minutes)

```bash
./test.sh
```

Inside Neovim, test:
1. **All categories**:
   - `:VimCoach` (all)
   - `:VimCoach motions`
   - `:VimCoach editing`
   - `:VimCoach visual`
   - `:VimCoach plugins`

2. **Search functionality**:
   - Search by command name
   - Search by keybind
   - Fuzzy search (typos)

3. **Preview display**:
   - Check text wrapping
   - Verify all fields show up
   - Check emoji rendering

4. **Keybind copying**:
   - Press `Enter` on a command
   - Press `Ctrl+Y` on a command
   - Verify clipboard has keybind

5. **Keymaps**:
   - `<leader>?` - all commands
   - `<leader>hm` - motions
   - `<leader>he` - editing
   - `<leader>hv` - visual
   - `<leader>hp` - plugins

### Test in Your Real Neovim

Want to test in your actual LazyVim setup?

**Option 1**: Install from local directory

Add to `~/.config/nvim/lua/plugins/vim-coach.lua`:
```lua
return {
  dir = "~/path/to/vim-coach.nvim",  -- Your local clone
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("vim-coach").setup()
  end,
}
```

**Option 2**: Test specific functions

```bash
nvim -c "lua require('vim-coach').info()"
```

---

## Code Style

### Lua Conventions

Follow existing code style:

**Indentation**: 2 spaces (not tabs)
```lua
-- Good
if condition then
  do_something()
end

-- Bad (4 spaces)
if condition then
    do_something()
end
```

**String quotes**: Use double quotes for strings
```lua
-- Good
local name = "vim-coach"

-- Acceptable (when needed)
local with_quotes = 'He said "hello"'
```

**Table formatting**: Trailing commas for multi-line
```lua
-- Good
local my_table = {
  field1 = "value1",
  field2 = "value2",  -- Trailing comma
}

-- Bad
local my_table = {
  field1 = "value1",
  field2 = "value2"  -- No trailing comma
}
```

**Comments**: Use `--` for comments
```lua
-- Good: Single-line comment

--[[
Good: Multi-line comment
spanning several lines
]]
```

### Command Data Format

Be consistent with existing commands:

```lua
{
  name = "Start with capital letter, use title case",
  keybind = "lowercase, exact Vim notation",
  modes = {"n", "v"},  -- Array of mode strings
  explanation = "Full sentence ending with period.",
  beginner_tip = "Helpful advice, complete sentence.",
  when_to_use = "Scenario description, complete sentence.",
  context_notes = {
    file = "Description of behavior",
    explorer = "Description of behavior",
  },
  examples = {
    "key - clear description",
    "5key - with count",
  }
}
```

### Commit Messages

Format: `<type>: <subject>`

**Types**:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Formatting
- `refactor:` - Code restructuring
- `test:` - Adding tests
- `chore:` - Maintenance

**Examples**:
```bash
git commit -m "feat: add macro recording commands"
git commit -m "fix: prevent crash when searching empty string"
git commit -m "docs: improve installation instructions"
git commit -m "refactor: simplify picker formatting logic"
```

**Good commit message**:
```
feat: add window management commands

- Added 10 new commands for window splits
- Created new 'windows' category
- Added <leader>hw keymap
- Updated documentation
```

**Bad commit message**:
```
update stuff
fixed things
changes
```

---

## Submitting Changes

### Before You Submit

**Checklist**:
- [ ] Tested in `./test.sh` environment
- [ ] All commands have required fields
- [ ] No typos or grammar errors
- [ ] Code follows style guide
- [ ] Commit messages are clear

### Creating a Pull Request

```bash
# 1. Make sure you're on your branch
git branch  # Should show your feature branch

# 2. Commit your changes
git add .
git commit -m "feat: add macro commands"

# 3. Push to YOUR fork
git push origin add-macro-commands

# 4. Go to GitHub
# Open: https://github.com/YOUR_USERNAME/vim-coach.nvim
# Click "Compare & pull request"

# 5. Fill out PR template
# - Describe your changes
# - Reference any related issues
# - Add screenshots if UI changed

# 6. Submit!
```

### PR Description Template

```markdown
## Description
Brief summary of changes.

## Changes Made
- Added X commands to Y category
- Fixed Z bug in picker
- Updated documentation

## Testing
- [x] Tested with ./test.sh
- [x] Verified all commands display correctly
- [x] Checked keybind copying works

## Screenshots (if applicable)
[Attach screenshots here]

## Closes
Closes #123  (if this fixes an issue)
```

---

## Tips for New Contributors

### 1. Start Small
Don't try to add 50 commands at once. Start with:
- Add 1-2 commands
- Fix a typo
- Improve documentation

### 2. Copy Existing Code
Find similar code and adapt it. No shame in copying!

### 3. Ask Questions
Stuck? Open a discussion or issue. We're friendly!

### 4. Test Often
Run `./test.sh` after every change. Catch bugs early!

### 5. Read Error Messages
Lua errors are usually clear:
```
Error: lua/vim-coach/commands/editing.lua:15: unexpected symbol near ','
```
→ Check line 15 for syntax error (extra comma, missing quote, etc.)

### 6. Use Git Branches
One feature per branch. Makes reviews easier!

---

## Common Errors and Fixes

### Error: "module 'vim-coach' not found"

**Cause**: Plugin not loaded correctly

**Fix**:
```bash
rm -rf ~/.cache/nvim/vim-coach-test/
./test.sh  # Fresh install
```

### Error: "attempt to index nil value"

**Cause**: Missing field in command definition

**Fix**: Check all commands have required fields:
```lua
{
  name = "...",      -- Required
  keybind = "...",   -- Required
  modes = {...},     -- Required
  explanation = "...", -- Required
  -- Optional fields can be nil
}
```

### Error: Syntax error near line X

**Cause**: Typo in Lua code

**Common issues**:
```lua
-- Missing comma
{
  name = "Test"  -- Missing comma here!
  keybind = "x"
}

-- Extra comma
{
  name = "Test",
  keybind = "x",
},  -- Extra comma in middle of table!
{
  name = "Test2",
}

-- Unmatched quotes
{
  name = "Test  -- Missing closing quote
}
```

### Changes Not Appearing

**Cause**: Neovim cached old code

**Fix**:
```bash
# Exit test environment
:qa!

# Restart
./test.sh

# Or reload inside test environment:
:Lazy reload vim-coach.nvim
```

---

## Advanced Development

### Enable Lua LSP (Language Server)

Get autocomplete and error checking!

**For Neovim users**:
```lua
-- In your config:
require('lspconfig').lua_ls.setup{
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }  -- Recognize vim global
      }
    }
  }
}
```

**For VS Code users**:
- Install "Lua" extension by sumneko
- Install "Neovim LSP" extension

### Run Lua Code Directly

```bash
# Test a function:
nvim -u test/minimal_init.lua -c "lua print(require('vim-coach').info())"

# Check syntax:
luacheck lua/vim-coach/
```

### Profile Performance

```lua
-- Add to test/minimal_init.lua:
vim.defer_fn(function()
  print(vim.inspect(require('vim-coach').info()))
end, 1000)
```

---

## Resources

- [Lua in Neovim Guide](https://github.com/nanotee/nvim-lua-guide)
- [LazyVim Docs](https://lazyvim.org)
- [Neovim API Docs](https://neovim.io/doc/user/api.html)
- [Learn Lua in Y Minutes](https://learnxinyminutes.com/docs/lua/)

---

## Need Help?

- Check [TESTING.md](TESTING.md) for test environment details
- Check [ARCHITECTURE.md](ARCHITECTURE.md) for code structure
- Open a GitHub issue
- Start a discussion

Happy coding! 💻
