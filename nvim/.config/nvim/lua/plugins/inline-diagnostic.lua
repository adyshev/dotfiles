return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy', -- Or `LspAttach`
  config = function()
    require('tiny-inline-diagnostic').setup {
      hi = {
        arrow = 'CursorLineNr',
        mixing_color = '#3A3A3A',
      },
      blend = {
        factor = 0,
      },
      signs = {
        left = ' ',
        right = '',
        diag = '',
        arrow = '    ',
        up_arrow = '    ',
        vertical = '',
        vertical_end = '',
      },
    }

    vim.diagnostic.config {
      virtual_text = false,
    }
  end,
}
-- return {
--   'dgagn/diagflow.nvim',
--   event = 'LspAttach',
--   opts = {
--     scope = 'line',
--   },
-- }
