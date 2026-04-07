-- Quick test file to verify which-key and startify are working
-- Save this as test-plugins.lua and run with :luafile %

print("=== Plugin Status Test ===")

-- Test which-key
local wk_ok, wk = pcall(require, 'which-key')
if wk_ok then
    print("✅ which-key.nvim is loaded successfully")
    print("   - Press <Space> to see which-key menu")
    print("   - Timeout is set to:", vim.o.timeoutlen, "ms")
else
    print("❌ which-key.nvim failed to load:", wk)
end

-- Test startify
if vim.fn.exists(':Startify') == 2 then
    print("✅ vim-startify is loaded successfully")
    print("   - Use :Startify to open startify")
    print("   - Use <Space>` to open startify")
else
    print("❌ vim-startify command not available")
end

-- Test if startify shows on empty buffer
if vim.fn.exists('g:startify_custom_header') == 1 then
    print("✅ Startify is configured with custom header")
else
    print("⚠️  Startify configuration might not be loaded")
end

-- Test REPL commands
if vim.fn.exists(':ReplStatus') == 2 then
    print("✅ REPL commands are available")
    print("   - Use :ReplStatus to check REPL configuration")
else
    print("❌ REPL commands not loaded")
end

print("=== Test Complete ===")
print("If you see ✅ for both which-key and startify, they should work!")
print("Try pressing <Space> in normal mode to see which-key menu")
print("Try running :Startify to see the start screen")
