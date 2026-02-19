return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "evim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    enabled = false,
    config = function()
        require("render-markdown").setup({
            latex = { enabled = false },
            completions = { lsp = { enabled = true } },
        })
    end,
}
