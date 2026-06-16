return {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
    config = function()
        require("inc_rename").setup({
            input_buffer_type = "snacks",
        })
    end,
}
