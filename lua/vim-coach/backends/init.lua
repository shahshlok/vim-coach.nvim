-- Backend abstraction for different picker implementations
local M = {}

-- Available backends
M.backends = {
	telescope = "vim-coach.backends.telescope",
	snacks = "vim-coach.backends.snacks",
}

-- Currently active backend
M.current_backend = nil

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

-- Set backend
function M.set_backend(backend_name)
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
		M.set_backend("snacks")
	end

	return M.current_backend
end

-- Show picker using current backend
function M.show_picker(opts)
	local backend = M.get_backend()

	return backend.show_picker(opts)
end

return M
