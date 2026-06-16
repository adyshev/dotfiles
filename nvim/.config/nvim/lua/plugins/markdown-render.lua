return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    enabled = true,
    ft = { "markdown", "mdx" },
    config = function()
        require("render-markdown").setup({
            anti_conceal = {
                enabled = false,
            },
            completions = { blink = { enabled = true } },
        })
    end,
}
