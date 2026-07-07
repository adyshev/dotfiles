return {
    "folke/noice.nvim",
    enabled = true,
    opts = {
        lsp = {
            signature = {
                enabled = true,
                auto_open = {
                    enabled = true,
                    trigger = true,
                    luasnip = false,
                    throttle = 50,
                },
                view = nil,
                opts = {},
            },
            documentation = {
                view = "hover",
                opts = {
                    lang = "markdown",
                    replace = true,
                    render = "plain",
                    format = { "{message}" },
                    win_options = { concealcursor = "n", conceallevel = 3 },
                },
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
            progress = {
                enabled = false,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
            cmdline_output_to_split = false,
        },
        views = {
            split = {
                win_options = { wrap = false },
                size = 8,
                close = { keys = { "q", "<CR>", "<Esc>" } },
            },
        },
        cmdline = {
            view = "cmdline",
        },
        notify = {
            enabled = false,
            view = "notify",
        },
        messages = {
            enabled = true,
            view = "notify", -- default view for messages
            view_error = "notify", -- view for errors
            view_warn = "notify", -- view for warnings
            view_history = "messages", -- view for :messages
            view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
        popupmenu = {
            enabled = true, -- enables the Noice popupmenu UI
            -- Noice currently supports only "nui" and "cmp" here. "native"
            -- leaves the backend nil and crashes from scheduled popupmenu hides.
            backend = "nui",
            -- backend = "cmp", -- backend to use to show regular cmdline completions
            -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
            kind_icons = {}, -- set to `false` to disable icons
        },
        routes = {
            { filter = { event = "msg_show", find = "E21" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "E37" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "E162" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "E20" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "E23" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "E348" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "E353" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "E508" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "Already at oldest change" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "Already at newest change" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "search hit TOP" }, opts = { skip = true } },
            { filter = { event = "msg_show", find = "search hit BOTTOM" }, opts = { skip = true } },
        },
    },
    config = function(_, opts)
        require("noice").setup(opts)
    end,
}
