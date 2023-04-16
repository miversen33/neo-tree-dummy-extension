local name = "dummy"
if vim.g.neo_tree_dummy_extension_no_name then
    name = nil
end

local commands = {}
require("neo-tree.sources.common.commands")._add_common_commands(commands)

local M = {
    name = name,
    display_name = 'ﭧ Dummy',
    components = {},
    commands = commands,
    navigate = function(state)
        require("neo-tree.ui.renderer").show_nodes({}, state)
    end,
    setup = function() end,
}

return M
