# Troubleshooting Guide

Having issues with vim-coach.nvim? This guide covers the most common problems and solutions.

Table of Contents:
- [Installation Issues](#installation-issues)
- [Plugin Not Working](#plugin-not-working)
- [Configuration Issues](#configuration-issues)
- [Performance Issues](#performance-issues)
- [Display Issues](#display-issues)
- [Advanced Troubleshooting](#advanced-troubleshooting)
- [Getting Help](#getting-help)

---

## Installation Issues

### Problem: "vim-coach.nvim requires snacks.nvim"

This error means vim-coach.nvim is installed, but snacks.nvim is not.

**Solution:**
Make sure both plugins are installed. Check your plugin configuration:

```lua
{
  "shahshlok/vim-coach.nvim",
  dependencies = { "folke/snacks.nvim" },  -- This line is important!
  config = function()
    require("vim-coach").setup()
  end,
}
```

The `dependencies` line tells lazy.nvim to automatically install snacks.nvim.

**If using other plugin managers:**
- packer.nvim: Use `requires` instead of `dependencies`
- vim-plug: Install snacks.nvim manually with `:PlugInstall`

---

### Problem: "vim-coach.nvim requires Neovim >= 0.7"

Your Neovim version is too old. vim-coach needs Neovim 0.7 or newer.

**Check your version:**
```
:version
```

Look for "NVIM v0.x.x" at the top.

**Solution:**
Update Neovim to version 0.7 or newer. See https://github.com/neovim/neovim/releases

**Don't want to update?**
You can use an older version of vim-coach from https://github.com/shahshlok/vim-coach.nvim/releases

---

### Problem: Plugin doesn't appear in `:Lazy`

If using lazy.nvim, the plugin should appear in the `:Lazy` menu.

**Solution:**

1. Check your configuration file location:
   - Mac/Linux: `~/.config/nvim/`
   - Windows: `%APPDATA%\nvim\`

2. Verify vim-coach.lua exists in the plugins folder:
   - Mac/Linux: `~/.config/nvim/lua/plugins/vim-coach.lua`
   - Windows: `%APPDATA%\nvim\lua\plugins\vim-coach.lua`

3. Run `:Lazy sync` to install/update all plugins

4. Restart Neovim completely (quit and reopen)

---

## Plugin Not Working

### Problem: `:VimCoach` command not found

The plugin registered correctly at startup, but the command doesn't work.

**Solutions:**

1. **Wait for lazy loading**: Plugin loads on first command. Try once, then again:
   ```
   :VimCoach
   <Enter>
   :VimCoach
   <Enter>
   ```

2. **Verify plugin loaded**: Check `:Lazy` to see if vim-coach is loaded:
   ```
   :Lazy
   ```
   Look for "vim-coach" in the list. It should show "loaded".

3. **Manual load**: Force load the plugin:
   ```
   :Lazy load vim-coach.nvim
   :VimCoach
   ```

4. **Check dependencies**: Verify snacks.nvim is also loaded:
   ```
   :Lazy
   ```
   Look for both "vim-coach.nvim" and "snacks.nvim" with status "loaded".

---

### Problem: Keyboard shortcut doesn't work

The shortcut (e.g., `<leader>?`) doesn't open vim-coach.

**Solutions:**

1. **Check your <leader> key**: By default, it's space. Try:
   ```
   Space + ?
   ```
   (Hold spacebar, then press Shift+/)

2. **Verify shortcut isn't overridden**: Another plugin or setting might use the same key.
   ```
   :map <leader>?
   ```
   This shows what `<leader>?` does.

3. **Use command instead**: Try the command instead of keyboard shortcut:
   ```
   :VimCoach
   ```

4. **Re-enable default keymaps**: If you disabled them, re-enable:
   ```lua
   -- In your config, remove or comment out:
   vim.g.vim_coach_no_default_keymaps = 1
   ```

---

### Problem: Picker doesn't open when I type `:VimCoach`

The command executes but nothing happens.

**Solutions:**

1. **Wait a moment**: Plugin might be loading files. Wait 1-2 seconds and try again.

2. **Check for errors**: Look for error messages:
   ```
   :messages
   ```

3. **Try manually**:
   ```
   :lua require("vim-coach").coach_picker()
   ```

4. **Verify snacks.picker works**: Test snacks separately:
   ```
   :lua require("snacks").picker({ items = { "test" } })
   ```

---

## Configuration Issues

### Problem: Custom configuration doesn't work

You added options to `setup()` but they have no effect.

**Solutions:**

1. **Verify setup() is called**: Check your config file:
   ```lua
   require("vim-coach").setup({
     window = { border = "double" }
   })
   ```

2. **Check for typos**: Valid options are:
   - `window.border`
   - `window.title_pos`
   - `keymaps.copy_keymap`
   - `keymaps.close`
   - `preview.*` options

3. **Restart Neovim**: Configuration changes require full restart:
   ```
   :quit
   nvim
   ```

4. **Try default setup**: Remove all options to test:
   ```lua
   require("vim-coach").setup()
   ```

---

### Problem: Wrong border style displayed

Your configured border style doesn't appear.

**Valid border values:**
- "none" - No border
- "single" - Single line
- "double" - Double line
- "rounded" - Rounded corners
- "solid" - Thick line

**Example:**
```lua
require("vim-coach").setup({
  window = { border = "solid" }
})
```

---

### Problem: Keybind copy shortcut doesn't work

Pressing your configured key doesn't copy the keybind.

**Solutions:**

1. **Inside the picker**: The key only works INSIDE the picker window (when it's open).

2. **Verify key is valid**: Some keys might conflict or be reserved.

3. **Try default key**: Test with Ctrl+Y:
   ```lua
   require("vim-coach").setup({
     keymaps = { copy_keymap = "<C-y>" }
   })
   ```

4. **Check for conflicts**: Search if another plugin uses the same key:
   ```
   :map <C-y>
   ```

---

## Performance Issues

### Problem: Picker is slow to open

Opening the picker takes a long time (> 1 second).

**Solutions:**

1. **First time vs subsequent times**: First call loads files (~100ms). Subsequent calls should be faster (~20ms).

2. **Check disk speed**: If disk is very slow, loading takes longer. Not much you can do here.

3. **Clear cache**: In case cache is corrupted:
   ```
   :lua require("vim-coach.core.loader").clear_cache()
   :VimCoach
   ```

4. **Check system resources**: If system is very busy, everything is slow.

---

### Problem: Neovim startup is slower than before

Adding vim-coach.nvim made Neovim startup slower.

**Solutions:**

1. **Lazy loading is working**: Plugin should add only ~0.5ms. If more, something's wrong.

2. **Check startup time**:
   ```
   nvim --startuptime startup.log
   :quit
   cat startup.log | grep vim-coach
   ```

3. **Ensure lazy loading**: Check configuration:
   ```lua
   {
     "shahshlok/vim-coach.nvim",
     dependencies = { "folke/snacks.nvim" },
     -- Important: only load when key is pressed
     keys = { { "<leader>?", "<cmd>VimCoach<cr>" } },
     config = function()
       require("vim-coach").setup()
     end,
   }
   ```

---

## Display Issues

### Problem: Text in picker is cut off or misaligned

Command names or keybinds are truncated.

**Solutions:**

1. **Widen terminal**: Make your terminal window wider.

2. **The truncation is expected**: Explanations are cut at 50 characters in the list. Press Enter to see full text in preview.

3. **Adjust formatter**: Advanced users can edit `lua/vim-coach/ui/formatter.lua` to change column widths.

---

### Problem: Preview shows strange characters

Preview text shows boxes or unusual characters instead of icons.

**Solutions:**

1. **Font issue**: Your terminal font doesn't support these icons (emojis).

2. **Update font**: Use a font that supports emojis:
   - Mac: Try "Noto Color Emoji"
   - Linux: Install "fonts-noto-color-emoji"
   - Windows: Windows Terminal uses built-in emoji support

3. **Disable icons** (workaround): Edit `lua/vim-coach/constants.lua` and remove emojis:
   ```lua
   M.ICONS = {
     keybind = "",
     category = "",
     modes = "",
     -- etc.
   }
   ```

---

### Problem: Colors look wrong

The picker colors don't match your theme.

**Solutions:**

1. **Use compatible theme**: vim-coach uses standard Neovim highlights:
   - `SnacksPickerLabel` - Command names
   - `SnacksPickerSpecial` - Keybinds
   - `SnacksPickerComment` - Explanations

2. **Your theme supports these**: Most themes define these highlights.

3. **Check theme documentation**: See if your theme supports snacks.nvim.

4. **Try different theme**: Test with a popular theme:
   - `tokyonight`
   - `catppuccin`
   - `gruvbox`

---

## Advanced Troubleshooting

### Enable debug logging

For in-depth debugging:

```lua
-- Add to your init.lua
vim.loglevel = vim.log.levels.DEBUG

require("vim-coach").setup()
```

Then check log:
```
:messages
```

---

### Manually test components

Test individual parts:

```lua
-- Test loader
local loader = require("vim-coach.core.loader")
local cmds = loader.get_all_commands()
print("Loaded " .. #cmds .. " commands")

-- Test picker
local picker = require("vim-coach.ui.picker")
picker.open("motions")

-- Test config
local config = require("vim-coach.config")
print(vim.inspect(config.get()))
```

---

### Check system information

Gather diagnostic information:

```lua
-- In Neovim:
:Lazy
:version
:echo &termguicolors
:echo &encoding
```

Share this when reporting issues.

---

### Reset to defaults

Remove all customization:

```lua
-- Remove from your config:
require("vim-coach").setup({...})

-- Use only:
require("vim-coach").setup()
```

Then test if issue persists.

---

## Getting Help

If you can't find a solution:

1. **Check documentation:**
   - [README.md](../README.md) - Overview
   - [GETTING_STARTED.md](GETTING_STARTED.md) - Installation help
   - [ARCHITECTURE.md](ARCHITECTURE.md) - How it works
   - [API_REFERENCE.md](API_REFERENCE.md) - Available functions

2. **Search issues:**
   - Open https://github.com/shahshlok/vim-coach.nvim/issues
   - Use search to find similar problems

3. **Check discussions:**
   - https://github.com/shahshlok/vim-coach.nvim/discussions

4. **Open new issue:**
   - Include:
     - Your Neovim version (`:version`)
     - vim-coach.nvim version (`:Lazy` menu)
     - snacks.nvim version
     - Error message (`:messages`)
     - Your configuration
     - Steps to reproduce the problem

5. **Request feature:**
   - If it's not a bug, use Discussions instead of Issues

---

## Common Questions

### Q: Why isn't my plugin manager installing snacks.nvim?

A: Make sure the `dependencies` line is in your config. Different plugin managers use different names:
- lazy.nvim: `dependencies`
- packer.nvim: `requires`
- dein.vim: Manual install needed

### Q: Can I use vim-coach with other plugin managers?

A: Yes, but you need to manually install snacks.nvim. vim-coach works with:
- lazy.nvim (easiest)
- packer.nvim
- vim-plug
- dein.vim
- Any plugin manager that supports standard Neovim plugin layout

### Q: Does vim-coach slow down Neovim?

A: No. It adds ~0.5ms to startup time (plugin registration only). Actual logic loads on first use (~50ms), then ~20ms on subsequent uses.

### Q: Can I disable default keymaps?

A: Yes:
```lua
vim.g.vim_coach_no_default_keymaps = 1
require("vim-coach").setup()
```

Then manually set the keymaps you want.

### Q: How do I uninstall vim-coach?

A: Remove the plugin configuration from your init.lua and run `:Lazy sync`.

---

## Still having issues?

If none of these solutions work, please open an issue with:
1. Your Neovim version
2. The full error message
3. Your vim-coach configuration
4. Output of `:Lazy`
5. Steps to reproduce

We'll help you get it working!
