return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark", -- or cool | dark | darker
      })
      require("onedark").load()
    end,
  },
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
      -- colorscheme = "catppuccin-macchiato", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    },
  },
}
