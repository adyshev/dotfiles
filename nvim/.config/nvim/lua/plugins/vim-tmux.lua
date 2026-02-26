local function tmux_navigate(direction, tmux_flag)
    return function()
        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.fn.system("tmux select-pane " .. tmux_flag)
        else
            vim.cmd("TmuxNavigate" .. direction)
        end
    end
end

return {
    "christoomey/vim-tmux-navigator",
    enabled = true,
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>", tmux_navigate("Left", "-L") },
        { "<c-j>", tmux_navigate("Down", "-D") },
        { "<c-k>", tmux_navigate("Up", "-U") },
        { "<c-l>", tmux_navigate("Right", "-R") },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
}
