return {
  'smoka7/multicursors.nvim',
  event = 'VeryLazy',
  dependencies = {
    'smoka7/hydra.nvim',
  },
  opts = {
    hint_config = {
      border = 'rounded',
      position = 'bottom-right',
    },
    generate_hints = {
      normal = true,
      insert = true,
      extend = true,
      config = {
        column_count = 1,
      },
    },
  },
  cmd = { 'MCstart', 'MCvisual', 'MCclear' },
  keys = {
    {
      mode = { 'v', 'n' },
      '<C-n>',
      '<cmd>MCstart<cr>',
      desc = 'Start Multicursors',
    },
    {
      mode = { 'v', 'n' },
      '<C-c>',
      '<cmd>MCclear<cr>',
      desc = 'Clear Multicursors',
    },
    {
      mode = { 'v', 'n' },
      '<C-m>',
      '<cmd>MCvisual<cr>',
      desc = 'Multicursors in visual mode',
    },
  },
}
