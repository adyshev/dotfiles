-- Single source of truth for parsers this config wants available on every
-- machine. Keep this list conservative: adding unavailable parsers breaks
-- installation on machines with older/newer nvim-treesitter registries.
local parsers = {
    "bash",
    "c",
    "css",
    "diff",
    "editorconfig",
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
    "vue",
}

local module_config = {
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
}

-- Install compiled parsers into stdpath("data")/site so they are shared by
-- nvim-treesitter and Neovim's runtimepath, independent of plugin checkout
-- location. This is important when the same dotfiles run on macOS and Linux.
local parser_install_dir = vim.fn.stdpath("data") .. "/site"

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                install_dir = parser_install_dir,
            })
        end,
    },
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        -- treesitter-modules provides the old-style highlight/incremental
        -- selection modules for the current nvim-treesitter main branch.
        opts = module_config,
    },
}
