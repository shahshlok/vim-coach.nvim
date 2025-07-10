-- Test error handling when no backend is available
print("Testing no backend scenario...")

-- Mock vim.notify to capture messages
local messages = {}
local original_notify = vim.notify
vim.notify = function(msg, level)
  table.insert(messages, {msg = msg, level = level})
  print("NOTIFY: " .. msg)
end

-- Add path
package.path = package.path .. ";" .. "/Users/Shlok/vim-coach.nvim/lua/?.lua"
package.path = package.path .. ";" .. "/Users/Shlok/vim-coach.nvim/lua/?/init.lua"

-- Test backend detection with no backends available
local ok, backends = pcall(require, "vim-coach.backends")
if ok then
  print("✓ Backend module loaded")
  
  -- Test auto-detection with no backends
  local name, backend = backends.auto_detect_backend()
  if name then
    print("✗ Unexpected backend found: " .. name)
  else
    print("✓ Correctly detected no backends available")
  end
  
  -- Test explicit backend selection failure
  local test_ok, err = pcall(backends.set_backend, "telescope")
  if not test_ok then
    print("✓ Correctly failed to set unavailable backend: " .. err)
  else
    print("✗ Should have failed to set telescope backend")
  end
else
  print("✗ Failed to load backend module")
end

-- Restore original notify
vim.notify = original_notify

print("✓ Error handling test complete")