To use this, use the following basic configuration

```lua
require("neo-tree").setup({
    source_selector = {
        winbar = true,
    },
    sources = {
        "neo-tree-dummy-extension"
    },
})
```

Below is a basic init.lua you can use to launch this in its own environment
```lua
-- Minimal configuration
-- mini.lua
-- Use with the --clean -u flags. EG nvim --clean -u mini.lua
-- This config will create a temp directory and will blow away that temp directory
-- everytime this configuration is loaded. Great for simulating a new installation
-- of a plugin

-- Setting some basic vim options
vim.opt.termguicolors = true
-- If you want to play around with this, you can set the do_clean
-- variable to false. This will allow changes made to
-- underlying plugins to persist between sessions, while
-- still keeping everything in its own directory so
-- as to not affect your existing neovim installation.
--
-- Setting this to true will result in a fresh clone of
-- all modules
local do_clean = true

-- Dummy var to make the dummy extension not provide a name
-- Set this to true to make the dummy extension not provide a name
-- otherwise it will provide the name "dummy"
-- vim.g.neo_tree_dummy_extension_no_name = true

local sep = vim.loop.os_uname().sysname:lower():match('windows') and '\\' or '/' -- \ for windows, mac and linux both use \

local mod_path = string.format("%s%sclean-test%s", vim.fn.stdpath('cache'), sep, sep)
if vim.loop.fs_stat(mod_path) and do_clean then
    print("Found previous clean test setup. Cleaning it out")
    -- Clearing out the mods directory and recreating it so 
    -- you have a fresh run everytime
    vim.fn.delete(mod_path, 'rf')
end

vim.fn.mkdir(mod_path, 'p')

local modules = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-tree/nvim-web-devicons'},
    {'MunifTanjim/nui.nvim'},
    {'nvim-neo-tree/neo-tree.nvim', branch = "v2.x", mod = "neo-tree"},
    {'miversen33/neo-tree-dummy-extension'}
}

for _, module in ipairs(modules) do
    local repo = module[1]
    local branch = module.branch
    local module_name = repo:match('/(.*)')
    local module_path = string.format('%s%s%s', mod_path, sep, module_name)
    if not vim.loop.fs_stat(module_name) then
        -- The module doesn't exist, download it
        local cmd = {
            'git',
            'clone'
        }
        if branch then
            table.insert(cmd, '--branch')
            table.insert(cmd, branch)
        end
        table.insert(cmd, string.format('https://github.com/%s', repo))
        table.insert(cmd, module_path)
        vim.fn.system(cmd)
        local message = string.format("Downloaded %s", module_name)
        if branch then
            message = string.format("%s on branch %s", message, branch)
        end
        print(message)
    end
    vim.opt.runtimepath:append(module_path)
end

print("Finished installing plugins. Beginning Setup of plugins")

for _, module in ipairs(modules) do
    if module.mod then
        print(string.format("Loading %s", module.mod))
        local success, err = pcall(require, module.mod)
        if not success then
            print(string.format("Failed to load module %s", module.mod))
            error(err)
        end
    end
end

-- --> Do you module setups below this line <-- --

local neo_tree = require("neo-tree")


neo_tree.setup({
    source_selector = {
        winbar = true,
    },
    sources = {
        "neo-tree-dummy-extension"
    },
})

-- --> Do your module setups above this line <-- --

print("Completed minimal setup!")
```
