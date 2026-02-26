return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    enabled = true,
    config = function()
        require("render-markdown").setup({
            anti_conceal = {
                enabled = false,
            },
            completions = { lsp = { enabled = true } },
        })
    end,
}
