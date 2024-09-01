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
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 0
      vim.g.gruvbox_material_diagnostic_virtual_text = 'grey'
      vim.g.gruvbox_material_dim_inactive_windows = 0
      vim.g.gruvbox_material_transparent_background = 0
      vim.g.gruvbox_material_background = 'medium'
      vim.g.gruvbox_material_foreground = 'mix' -- 'material'`, `'mix'`, `'original
      vim.g.gruvbox_material_ui_contrast = 'low' -- `'low'`, `'high'`
      vim.g.gruvbox_material_float_style = 'dim'
      vim.g.gruvbox_material_show_eob = 0
      vim.g.gruvbox_material_diagnostic_line_highlight = 0
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_colors_override = {
        bg0 = { '#282828', '235' },
        bg3 = { '#484545', '237' },
        bg_dim = { '#282828', '235' },
      }

      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {}),
        pattern = 'gruvbox-material',
        callback = function()
          local config = vim.fn['gruvbox_material#get_configuration']()
          local palette = vim.fn['gruvbox_material#get_palette'](config.background, config.foreground, config.colors_override)
          local set_hl = vim.fn['gruvbox_material#highlight']

          set_hl('CursorLineNr', palette.orange, palette.none)
        end,
      })

      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  -- {
  --   'f4z3r/gruvbox-material.nvim',
  --   name = 'gruvbox-material',
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     local colors = require('gruvbox-material.colors').get(vim.o.background, 'medium')
  --
  --     require('gruvbox-material').setup {
  --       italics = true,
  --       background = {
  --         transparent = false, -- set the background to transparent
  --       },
  --       float = {
  --         force_background = false, -- force background on floats even when background.transparent is set
  --         background_color = '#282828', -- set color for float backgrounds. If nil, uses the default color set
  --       },
  --       comments = {
  --         italics = true,
  --       },
  --       contrast = 'medium',
  --       customize = function(g, o)
  --         if g == 'CursorLineNr' then
  --           o.link = nil -- wipe a potential link, which would take precedence over other
  --           -- attributes
  --           o.fg = colors.orange -- or use any color in "#rrggbb" hex format
  --         end
  --
  --         o.bold = false
  --         return o
  --       end,
  --     }
  --   end,
  -- },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { 'wittyjudge/gruvbox-material.nvim' },
}
