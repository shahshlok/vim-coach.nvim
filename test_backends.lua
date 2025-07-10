-- Simple test script to verify backend functionality
print("Testing vim-coach backend system...")

-- Add our plugin to the Lua path
package.path = package.path .. ";" .. "/Users/Shlok/vim-coach.nvim/lua/?.lua"
package.path = package.path .. ";" .. "/Users/Shlok/vim-coach.nvim/lua/?/init.lua"

-- Test 1: Check if backends module loads
print("\n=== Test 1: Backend Module Loading ===")
local ok, backends = pcall(require, "vim-coach.backends")
if ok then
    print("✓ Backend module loaded successfully")
    
    -- Test available backends
    local available = backends.get_available_backends()
    print("Available backends:")
    for name, backend in pairs(available) do
        print("  - " .. name .. " (" .. backend.get_name() .. ")")
    end
    
    -- Test auto-detection
    local selected_name, selected_backend = backends.auto_detect_backend()
    if selected_name then
        print("✓ Auto-detection selected: " .. selected_name)
    else
        print("✗ No backend available for auto-detection")
    end
else
    print("✗ Failed to load backend module: " .. tostring(backends))
    return
end

-- Test 2: Check individual backends
print("\n=== Test 2: Individual Backend Tests ===")

-- Test telescope backend
print("Testing telescope backend...")
local telescope_ok, telescope = pcall(require, "vim-coach.backends.telescope")
if telescope_ok then
    print("✓ Telescope backend module loaded")
    print("  - Available: " .. tostring(telescope.is_available()))
    print("  - Name: " .. telescope.get_name())
else
    print("✗ Telescope backend failed: " .. tostring(telescope))
end

-- Test snacks backend
print("Testing snacks backend...")
local snacks_ok, snacks = pcall(require, "vim-coach.backends.snacks")
if snacks_ok then
    print("✓ Snacks backend module loaded")
    print("  - Available: " .. tostring(snacks.is_available()))
    print("  - Name: " .. snacks.get_name())
else
    print("✗ Snacks backend failed: " .. tostring(snacks))
end

-- Test 3: Check main module
print("\n=== Test 3: Main Module Test ===")
local main_ok, main = pcall(require, "vim-coach")
if main_ok then
    print("✓ Main vim-coach module loaded")
    
    -- Test commands loading
    local commands = main.get_all_commands()
    print("✓ Commands loaded: " .. #commands .. " total")
    
    -- Test info function
    local info = main.info()
    print("✓ Plugin info: " .. info.name .. " v" .. info.version)
else
    print("✗ Main module failed: " .. tostring(main))
end

print("\n=== Backend Test Complete ===")