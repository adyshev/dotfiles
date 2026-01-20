return {
    "smjonas/inc-rename.nvim",
    opts = {},
    config = function()
        require("inc_rename").setup({
            input_buffer_type = "snacks",
        })
    end,
}
