return {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
        {
            "<leader>x",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "[x]Diagnostics",
        },
        {
            "<leader>r",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "[r]Quickfix List",
        },
    },
}
