-- Test telescope backend specifically
print("Testing telescope backend...")

return {
  dir = "/Users/Shlok/vim-coach.nvim",
  name = "vim-coach.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("vim-coach").setup({
      picker = "telescope",
    })
    
    -- Test the picker
    vim.schedule(function()
      local info = require("vim-coach").info()
      print("Plugin loaded: " .. info.name .. " v" .. info.version)
      print("Total commands: " .. info.total_commands)
      
      -- Test command loading
      local commands = require("vim-coach").get_commands("motions")
      print("Motion commands loaded: " .. #commands)
      
      print("✓ Telescope backend test complete")
    end)
  end
}