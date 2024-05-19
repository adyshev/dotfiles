return {
  -- {
  --   "navarasu/onedark.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("onedark").setup({
  --       style = "warm", -- or cool | dark | darker
  --     })
  --     require("onedark").load()
  --   end,
  -- },
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { "wittyjudge/gruvbox-material.nvim" },
  {
    "f4z3r/gruvbox-material.nvim",
    name = "gruvbox-material",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("gruvbox-material").setup({
        italics = true,
        comments = {
          italics = true,
        },
        contrast = "medium",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
      -- colorscheme = "onedark",
      -- colorscheme = "catppuccin-macchiato", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    },
  },
}
