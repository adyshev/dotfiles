return {
    "gbprod/yanky.nvim",
    lazy = false,
    enabled = true,
    keys = {
        {
            "<leader>y",
            function()
                require("telescope").extensions.yank_history.yank_history({})
            end,
            desc = "[y]Open Yank History",
        },
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
        { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Cursor" },
        { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Cursor" },
        { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Selection" },
        { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Selection" },
        { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
        { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
        { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
        { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
        { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
        { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
        { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous Yank entry" },
        { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Next Yank entry" },
    },
    config = function()
        local utils = require("yanky.utils")
        local mapping = require("yanky.telescope.mapping")

        require("yanky").setup({
            highlight = {
                on_put = true,
                on_yank = true,
                timer = 150,
            },
            preserve_cursor_position = {
                enabled = true,
            },
            ring = {
                history_length = 100,
                storage = "shada",
                sync_with_numbered_registers = true,
                cancel_event = "update",
                ignore_registers = { "_" },
                update_register_on_cycle = false,
                permanent_wrapper = nil,
            },
            system_clipboard = {
                sync_with_ring = true,
            },
            picker = {
                telescope = {
                    mappings = {
                        default = mapping.put("p"),
                        i = {
                            ["<c-g>"] = mapping.put("p"),
                            ["<c-k>"] = mapping.put("P"),
                            ["<c-x>"] = mapping.delete(),
                            ["<c-r>"] = mapping.set_register(utils.get_default_register()),
                        },
                        n = {
                            p = mapping.put("p"),
                            P = mapping.put("P"),
                            d = mapping.delete(),
                            r = mapping.set_register(utils.get_default_register()),
                        },
                    },
                },
            },
        })
    end,
}
