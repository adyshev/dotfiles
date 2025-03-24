return {
    "folke/noice.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
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
        },
        progress = {
            enabled = true,
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
            ---@type NoiceViewOptions
            opts = {}, -- merged with defaults from documentation
        },
        status = {
            -- Statusline component for LSP progress notifications.
            lsp_progress = { event = "lsp", kind = "progress" },
        },
        presets = {
            bottom_search = true,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = true,
            lsp_doc_border = true,
            cmdline_output_to_split = true,
        },
        documentation = {
            view = "hover",
            ---@type NoiceViewOptions
            opts = {
                lang = "markdown",
                replace = true,
                render = "plain",
                format = { "{message}" },
                win_options = { concealcursor = "n", conceallevel = 3 },
            },
        },
        routes = {
            {
                filter = {
                    event = "notify",
                    min_height = 10,
                },
                view = "split",
            },
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                        { find = "%d fewer lines" },
                        { find = "%d more lines" },
                    },
                },
                opts = { skip = true },
            },
            { filter = { event = "msg_show", find = "lsp_signature? handler RPC" }, skip = true },
            { filter = { event = "msg_show", find = "^%s*at process.processTicksAndRejections" }, skip = true },
            { filter = { event = "notify", find = "No code actions available" }, skip = true },
            { filter = { event = "msg_show", find = "^[/?]." }, skip = true },
            { filter = { event = "msg_show", find = "^:!make" }, skip = true },
            { filter = { event = "msg_show", find = "^%(%d+ of %d+%):" }, skip = true },
            { filter = { event = "msg_show", find = "E211: File .* no longer available" }, skip = true },
            {
                filter = {
                    event = "lsp",
                    kind = "progress",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                },
                view = "mini",
            },
            {
                filter = {
                    event = "notify",
                    cond = function(msg)
                        return msg.opts and (msg.opts.title or ""):find("mason")
                    end,
                },
                view = "mini",
            },
            {
                filter = {
                    event = "notify",
                    cond = function(msg)
                        return msg.opts and (msg.opts.title or ""):find("nvim-treesitter")
                    end,
                },
                view = "mini",
            },
        },
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = false,
        },
    },
    config = function(_, opts)
        require("noice").setup(opts)

        vim.keymap.set("n", "<leader>l", function()
            require("noice").cmd("history")
        end, { desc = "[l]Noice History" })
    end,
}
