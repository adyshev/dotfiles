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

            local parsers = {
                "bash",
                "c",
                "css",
                "diff",
                "editorconfig",
                "zsh",
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

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyDone",
                once = true,
                callback = function()
                    require("nvim-treesitter").install(parsers)
                end,
            })

            require("treesitter-modules").setup({
                auto_install = true,
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
            })
        end,
    },
    { "MeanderingProgrammer/treesitter-modules.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } },
}
