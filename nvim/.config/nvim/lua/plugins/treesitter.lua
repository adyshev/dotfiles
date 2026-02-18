return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.config")

        configs.setup({
            ensure_installed = {
                "bash",
                "c",
                "python",
                "go",
                "rust",
                "diff",
                "html",
                "regex",
                "templ",
                "json",
                "yaml",
                "css",
                "lua",
                "luadoc",
                "markdown",
                "vim",
                "vimdoc",
                "query",
                "typst",
                "latex",
                "scss",
                "svelte",
                "javascript",
                "typescript",
            },
            auto_install = true,
            sync_install = false,
            highlight = { enable = true },
            matchup = {
                enable = true,
                enable_quotes = true,
                disable_virtual_text = false,
                include_match_words = true,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<c-space>",
                    node_incremental = "<c-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
