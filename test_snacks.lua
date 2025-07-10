-- Test snacks backend specifically
print("Testing snacks backend...")

return {
  dir = "/Users/Shlok/vim-coach.nvim",
  name = "vim-coach.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("vim-coach").setup({
      picker = "snacks",
    })
    
    -- Test the picker
    vim.schedule(function()
      local info = require("vim-coach").info()
      print("Plugin loaded: " .. info.name .. " v" .. info.version)
      print("Total commands: " .. info.total_commands)
      
      -- Test command loading
      local commands = require("vim-coach").get_commands("editing")
      print("Editing commands loaded: " .. #commands)
      
      print("✓ Snacks backend test complete")
    end)
  end
}