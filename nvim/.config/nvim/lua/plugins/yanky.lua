local function can_edit_buffer()
    return vim.bo.modifiable and not vim.bo.readonly
end

local function feed_plug(plug)
    return function()
        if not can_edit_buffer() then
            return
        end
        local key = vim.api.nvim_replace_termcodes("<Plug>(" .. plug .. ")", true, false, true)
        vim.api.nvim_feedkeys(key, "m", false)
    end
end

return {
    "gbprod/yanky.nvim",
    lazy = false,
    enabled = true,
    keys = {
        {
            "<leader>sy",
            function()
                local ok, history = pcall(require, "yanky.history")
                if not ok then
                    vim.notify("yanky not available", vim.log.levels.WARN)
                    return
                end
                local entries = history.all()
                if not entries or #entries == 0 then
                    vim.notify("Yank history is empty", vim.log.levels.INFO)
                    return
                end
                local items = {}
                for i, entry in ipairs(entries) do
                    local text = type(entry.regcontents) == "table" and table.concat(entry.regcontents, " ") or tostring(entry.regcontents)
                    items[i] = {
                        text = text,
                        entry = entry,
                    }
                end
                Snacks.picker({
                    title = "Yank History",
                    items = items,
                    format = "text",
                    confirm = function(picker, item)
                        picker:close()
                        if item then
                            local e = item.entry
                            local contents = type(e.regcontents) == "table" and e.regcontents or { e.regcontents }
                            vim.fn.setreg('"', contents, e.regtype)
                            vim.fn.setreg("+", contents, e.regtype)
                            vim.notify("Yanked to register", vim.log.levels.INFO)
                        end
                    end,
                })
            end,
            desc = "[y]Search Yank History",
        },
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
        { "Y", "^<Plug>(YankyYank)$", mode = "n", desc = "Yank to end of line" },
        { "p", feed_plug("YankyPutAfter"), mode = { "n", "x" }, desc = "Put Yanked Text After Cursor" },
        { "P", feed_plug("YankyPutBefore"), mode = { "n", "x" }, desc = "Put Yanked Text Before Cursor" },
        { "gp", feed_plug("YankyGPutAfter"), mode = { "n", "x" }, desc = "Put Yanked Text After Selection" },
        { "gP", feed_plug("YankyGPutBefore"), mode = { "n", "x" }, desc = "Put Yanked Text Before Selection" },
        { "]p", feed_plug("YankyPutIndentAfterLinewise"), desc = "Put Indented After Cursor (Linewise)" },
        { "[p", feed_plug("YankyPutIndentBeforeLinewise"), desc = "Put Indented Before Cursor (Linewise)" },
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
                timer = 180,
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
