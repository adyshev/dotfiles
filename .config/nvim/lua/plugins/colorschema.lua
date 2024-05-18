return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "warm", -- or cool | dark | darker
      })
      require("onedark").load()
    end,
  },
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { "wittyjudge/gruvbox-material.nvim" },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "gruvbox-material",
      colorscheme = "onedark",
      -- colorscheme = "catppuccin-macchiato", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    },
  },
}
