local parsers = {
    "bash",
    "c",
    "css",
    "diff",
    "editorconfig",
    "zsh",
    "fish",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "latex",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "rust",
    "scss",
    "svelte",
    "templ",
    "toml",
    "tsx",
    "typescript",
    "typst",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })
        end,
    },
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            ensure_installed = parsers,
            -- fold = { enable = true },
            highlight = { enable = true },
            -- indent = { enable = true },
            incremental_selection = {
                enable = true,
                -- set value to `false` to disable individual mapping
                -- node_decremental captures both node_incremental and scope_incremental
                keymaps = {
                    init_selection = "<c-space>",
                    node_incremental = "<c-space>",
                    scope_incremental = false,
                    node_decremental = "<BS>",
                },
            },
        },
    },
}
