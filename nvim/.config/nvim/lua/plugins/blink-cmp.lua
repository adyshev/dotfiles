return {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "rafamadriz/friendly-snippets",
        {
            "Kaiser-Yang/blink-cmp-git",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        "ribru17/blink-cmp-spell",
    },
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<Up>"] = { "cancel", "fallback" },
            ["<Down>"] = { "cancel", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },
        completion = {
            list = {
                selection = { preselect = false, auto_insert = false },
            },
            menu = {
                border = "rounded",
                draw = {
                    columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
                    components = {
                        source_name = {
                            text = function(ctx)
                                local map = {
                                    lsp = "[LSP]",
                                    snippets = "[Snip]",
                                    buffer = "[Buffer]",
                                    path = "[Path]",
                                    git = "[Git]",
                                    spell = "[Spell]",
                                }
                                return map[ctx.source_id] or ("[" .. ctx.source_id .. "]")
                            end,
                            highlight = "BlinkCmpSource",
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = {
                    border = "rounded",
                },
            },
        },
        snippets = { preset = "default" },
        sources = {
            default = { "lsp", "snippets", "buffer", "path" },
            per_filetype = {
                gitcommit = { "git", "buffer" },
                markdown = { "lsp", "snippets", "spell", "buffer", "path" },
            },
            providers = {
                git = {
                    module = "blink-cmp-git",
                    name = "Git",
                    enabled = true,
                },
                spell = {
                    module = "blink-cmp-spell",
                    name = "Spell",
                },
            },
        },
        cmdline = {
            enabled = true,
            keymap = {
                preset = "none",
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
            },
            completion = {
                list = {
                    selection = { preselect = false, auto_insert = true },
                },
                menu = {
                    auto_show = true,
                },
            },
        },
    },
}
