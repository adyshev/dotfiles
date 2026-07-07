local M = {}

-- Move focus to a neighboring tmux pane from inside Neovim UI contexts that
-- cannot rely on vim-tmux-navigator commands, such as Snacks picker windows.
function M.select_pane(direction)
    if vim.env.TMUX then
        vim.system({ "tmux", "select-pane", direction }, { text = true }, function() end)
    end
end

return M
