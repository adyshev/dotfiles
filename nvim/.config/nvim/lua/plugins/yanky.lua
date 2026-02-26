return {
    "gbprod/yanky.nvim",
    lazy = false,
    enabled = true,
    keys = {
        {
            "<leader>sy",
            function()
                local history = require("yanky.history")
                local items = history.all()
                local display = {}
                for i, item in ipairs(items) do
                    display[i] = table.concat(item.regcontents, "\\n")
                end
                vim.ui.select(display, { prompt = "Yank History" }, function(_, idx)
                    if idx then
                        local entry = items[idx]
                        vim.fn.setreg(vim.v.register ~= "" and vim.v.register or '"', entry.regcontents, entry.regtype)
                        vim.api.nvim_put(entry.regcontents, entry.regtype, true, true)
                    end
                end)
            end,
            desc = "[y]Search Yank History",
        },
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
        { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Cursor" },
        { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Cursor" },
        { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Selection" },
        { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Selection" },
        { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        -- { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
        -- { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
        -- { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        -- { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        -- { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
        -- { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
        -- { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
        -- { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
        -- { "<c-y>", "<Plug>(YankyPreviousEntry)", desc = "Previous Yank entry" },
        -- { "<c-u>", "<Plug>(YankyNextEntry)", desc = "Next Yank entry" },
    },
    config = function()
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
        })
    end,
}
