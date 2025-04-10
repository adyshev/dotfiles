return {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = true,
    ---@type Flash.Config
    opts = {
        jump = {
            autojump = true,
        },
        modes = {
            char = { jump_labels = true },
            search = { enabled = true },
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
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter({ jump = { pos = "start" }, label = { before = true, after = false } }) end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    }
,
}
