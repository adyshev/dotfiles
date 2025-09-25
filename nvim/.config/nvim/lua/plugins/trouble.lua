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
            "<leader>cq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "[q]Quickfix List",
        },
    },
}
