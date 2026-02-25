return {
    "folke/noice.nvim",
    enabled = true,
    -- dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    -- "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
    -- },
    opts = {
        lsp = {
            signature = {
                auto_open = {
                    enabled = false,
                },
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
            progress = {
                enabled = false,
            },
        },
        signature = {
            enabled = true,
            auto_open = {
                enabled = true,
                luasnip = true, -- Automatically show signature help when typing a trigger character from the LSP
                trigger = true, -- Will open signature help when jumping to Luasnip insert nodes
                throttle = 50, -- Debounce lsp signature help request by 50ms
            },
            view = nil, -- when nil, use defaults from documentation
            opts = {}, -- merged with defaults from documentation
        },
        -- status = {
        --     -- Statusline component for LSP progress notifications.
        --     lsp_progress = { event = "lsp", kind = "progress" },
        -- },
        presets = {
            bottom_search = true,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
            cmdline_output_to_split = false,
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
        -- routes = {
        --     {
        --         filter = {
        --             event = "notify",
        --             min_height = 10,
        --         },
        --         view = "split",
        --     },
        --     {
        --         filter = {
        --             event = "msg_show",
        --             kind = "",
        --             find = "written",
        --         },
        --         opts = { skip = true },
        --     },
        --     {
        --         filter = {
        --             event = "msg_show",
        --             kind = "search_count",
        --         },
        --         opts = { skip = true },
        --     },
        --     {
        --         filter = {
        --             event = "msg_show",
        --             any = {
        --                 { find = "%d+L, %d+B" },
        --                 { find = "; after #%d+" },
        --                 { find = "; before #%d+" },
        --                 { find = "%d fewer lines" },
        --                 { find = "%d more lines" },
        --             },
        --         },
        --         opts = { skip = true },
        --     },
        --     { filter = { event = "msg_show", find = "lsp_signature? handler RPC" }, skip = true },
        --     { filter = { event = "msg_show", find = "^%s*at process.processTicksAndRejections" }, skip = true },
        --     { filter = { event = "notify", find = "No code actions available" }, skip = true },
        --     { filter = { event = "msg_show", find = "^[/?]." }, skip = true },
        --     { filter = { event = "msg_show", kind = "" }, skip = true },
        --     { filter = { event = "msg_show", find = "^:!make" }, skip = true },
        --     { filter = { event = "msg_show", find = "^%(%d+ of %d+%):" }, skip = true },
        --     { filter = { event = "msg_show", find = "E211: File .* no longer available" }, skip = true },
        --     { filter = { event = "msg_show", find = "E486: Pattern not found:" }, skip = true },
        --     {
        --         filter = {
        --             event = "lsp",
        --             kind = "progress",
        --         },
        --         opts = { skip = true },
        --     },
        --     {
        --         filter = {
        --             event = "notify",
        --             cond = function(msg)
        --                 return msg.opts and (msg.opts.title or ""):find("mason")
        --             end,
        --         },
        --         view = "mini",
        --     },
        --     {
        --         filter = {
        --             event = "notify",
        --             cond = function(msg)
        --                 return msg.opts and (msg.opts.title or ""):find("nvim-treesitter")
        --             end,
        --         },
        --         view = "mini",
        --     },
        -- },
        views = {
            split = {
                win_options = { wrap = false },
                size = 8,
                close = { keys = { "q", "<CR>", "<Esc>" } },
            },
        },
        cmdline = {
            -- view = "cmdline_popup",
            view = "cmdline",
        },
        notify = {
            -- Noice can be used as `vim.notify` so you can route any notification like other messages
            -- Notification messages have their level and other properties set.
            -- event is always "notify" and kind can be any log level as a string
            -- The default routes will forward notifications to nvim-notify
            -- Benefit of using Noice for this is the routing and consistent history view
            enabled = false,
            view = "notify",
        },
        -- messages = {
        --     -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        --     -- This is a current Neovim limitation.
        --     enabled = true, -- enables the Noice messages UI
        --     view = "notify", -- default view for messages
        --     view_error = "notify", -- view for errors
        --     view_warn = "notify", -- view for warnings
        --     view_history = "messages", -- view for :messages
        --     view_search = false, -- view for search count messages. Set to `false` to disable
        -- },
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
            backend = "cmp", -- backend to use to show regular cmdline completions
            -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
            kind_icons = {}, -- set to `false` to disable icons
        },
    },
    config = function(_, opts)
        require("noice").setup(opts)
    end,
}
