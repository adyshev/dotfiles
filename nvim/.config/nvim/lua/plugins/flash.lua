return {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = true,
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                enabled = false,
            },
            search = { enabled = false },
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
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<C-f>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  }
,
}
