return {
  -- {
  --   'navarasu/onedark.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('onedark').setup {
  --       style = 'warm', -- or cool | dark | darker
  --     }
  --     require('onedark').load()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  {
    'f4z3r/gruvbox-material.nvim',
    name = 'gruvbox-material',
    priority = 1000,
    opts = {},
    config = function()
      require('gruvbox-material').setup {
        italics = true,
        comments = {
          italics = true,
        },
        contrast = 'medium',
      }
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { 'wittyjudge/gruvbox-material.nvim' },
}
