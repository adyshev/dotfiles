local M = {}

function M.select_pane(direction)
    if vim.env.TMUX then
        vim.system({ "tmux", "select-pane", direction }, { text = true }, function() end)
    end
end

return M
