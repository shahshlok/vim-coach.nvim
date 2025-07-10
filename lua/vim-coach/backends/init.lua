-- Backend abstraction for different picker implementations
local M = {}

-- Available backends
M.backends = {
  telescope = "vim-coach.backends.telescope",
  snacks = "vim-coach.backends.snacks",
}

-- Default backend priority (first available will be used)
M.backend_priority = { "telescope", "snacks" }

-- Currently active backend
M.current_backend = nil

-- Backend interface - all backends must implement these methods
local backend_interface = {
  -- Check if backend is available
  is_available = function() end,
  
  -- Create and show picker
  show_picker = function(opts) end,
  
  -- Get backend name
  get_name = function() end,
}

-- Get available backends
function M.get_available_backends()
  local available = {}
  for name, module_path in pairs(M.backends) do
    local ok, backend = pcall(require, module_path)
    if ok and backend.is_available() then
      available[name] = backend
    end
  end
  return available
end

-- Auto-detect best backend
function M.auto_detect_backend()
  local available = M.get_available_backends()
  
  for _, backend_name in ipairs(M.backend_priority) do
    if available[backend_name] then
      return backend_name, available[backend_name]
    end
  end
  
  return nil, nil
end

-- Set backend
function M.set_backend(backend_name)
  if backend_name == "auto" then
    local name, backend = M.auto_detect_backend()
    if not name then
      error("No supported picker backend found. Please install telescope.nvim or snacks.nvim")
    end
    M.current_backend = backend
    return name
  end
  
  local available = M.get_available_backends()
  if not available[backend_name] then
    error("Backend '" .. backend_name .. "' is not available")
  end
  
  M.current_backend = available[backend_name]
  return backend_name
end

-- Get current backend
function M.get_backend()
  if not M.current_backend then
    M.set_backend("auto")
  end
  return M.current_backend
end

-- Show picker using current backend
function M.show_picker(opts)
  local backend = M.get_backend()
  return backend.show_picker(opts)
end

return M