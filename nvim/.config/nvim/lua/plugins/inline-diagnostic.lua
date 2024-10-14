return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy', -- Or `LspAttach`
  config = function()
    require('tiny-inline-diagnostic').setup {
      hi = {
        arrow = 'CursorLineNr',
        mixing_color = '#3A3A3A',
      },
      options = {
        throttle = 0,

        -- The minimum length of the message, otherwise it will be on a new line.
        softwrap = 30,

        -- If multiple diagnostics are under the cursor, display all of them.
        multiple_diag_under_cursor = true,

        -- Enable diagnostic message on all lines.
        multilines = true,
      },
      blend = {
        factor = 0,
      },
      signs = {
        left = ' ',
        right = ' ',
        diag = ' ⚠',
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
