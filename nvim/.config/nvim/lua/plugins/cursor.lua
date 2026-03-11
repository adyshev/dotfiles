return {
    "sphamba/smear-cursor.nvim",
    opts = {
        enabled = true,
        smear_between_buffers = true,
        stiffness = 0.9,
        trailing_stiffness = 0.8,
        distance_stop_animating = 0.3,
    },
    config = function(_, opts)
        require("smear_cursor").setup(opts)
        vim.api.nvim_create_autocmd("CmdlineEnter", {
            callback = function() require("smear_cursor").enabled = false end,
        })
        vim.api.nvim_create_autocmd("CmdlineLeave", {
            callback = function() require("smear_cursor").enabled = true end,
        })
    end,
}
