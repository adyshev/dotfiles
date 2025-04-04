return {
    "okuuva/auto-save.nvim",
    config = function()
        require("auto-save").setup({
            noautocmd = true,
            condition = function(buf)
                local fn = vim.fn

                -- don't save for special-buffers
                if fn.getbufvar(buf, "&buftype") ~= "" then
                    return false
                end
                return true
            end,
            trigger_events = { -- See :h events
                immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
                defer_save = {}, -- vim events that trigger a deferred save (saves after `debounce_delay`)
                cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
            },
        })
    end,
}
