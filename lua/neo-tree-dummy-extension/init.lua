local name = "dummy"
if vim.g.neo_tree_dummy_extension_no_name then
    name = nil
end

local M = {
    name = name,
    components = {},
    commands = {},
    navigate = function() end,
    setup = function() end,
}

return M
