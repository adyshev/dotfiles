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
      local colors = require('gruvbox-material.colors').get(vim.o.background, 'medium')

      require('gruvbox-material').setup {
        italics = true,
        background = {
          transparent = false, -- set the background to transparent
        },
        float = {
          force_background = false, -- force background on floats even when background.transparent is set
          background_color = '#282828', -- set color for float backgrounds. If nil, uses the default color set
        },
        comments = {
          italics = true,
        },
        contrast = 'medium',
        customize = function(g, o)
          if g == 'CursorLineNr' then
            o.link = nil -- wipe a potential link, which would take precedence over other
            -- attributes
            o.fg = colors.orange -- or use any color in "#rrggbb" hex format
            o.bold = true
          end
          return o
        end,
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
