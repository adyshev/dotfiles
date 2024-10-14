return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy', -- Or `LspAttach`
  -- enabled = false,
  config = function()
    require('tiny-inline-diagnostic').setup {
      hi = {
        arrow = 'CursorLineNr',
        mixing_color = '#282828',
      },
      options = {
        throttle = 20,

        -- The minimum length of the message, otherwise it will be on a new line.
        softwrap = 30,

        -- If multiple diagnostics are under the cursor, display all of them.
        multiple_diag_under_cursor = false,

        -- Enable diagnostic message on all lines.
        multilines = true,
      },
      blend = {
        factor = 0.27,
      },
      signs = {
        left = ' ',
        right = ' ',
        diag = '',
        arrow = '   ',
        up_arrow = '   ',
        vertical = '',
        vertical_end = '',
      },
    }
  end,
}
