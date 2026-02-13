return {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {
        modes = {
            char = { jump_labels = true },
        },
        exclude = {
            "NeogitStatus",
            "notify",
            "cmp_menu",
            "noice",
            "flash_prompt",
            function(win)
                return not vim.api.nvim_win_get_config(win).focusable
            end,
        },
    },
    keys = {
        {
            "<leader>f",
            mode = { "n", "x", "o" },
            function()
                require("lua.plugins.disabled.flash").jump()
            end,
            desc = "[f]Flash",
        },
    },
}
