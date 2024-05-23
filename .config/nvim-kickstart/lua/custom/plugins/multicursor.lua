return {
  'smoka7/multicursors.nvim',
  event = 'VeryLazy',
  dependencies = {
    'smoka7/hydra.nvim',
  },
  opts = {
    hint_config = false,
  },
  cmd = { 'MCstart', 'MCvisual' },
  keys = {
    {
      mode = { 'v', 'n' },
      '<C-n>',
      '<cmd>MCstart<cr>',
      desc = 'Start Multicursors',
    },
    {
      mode = { 'v', 'n' },
      '<C-m>',
      '<cmd>MCvisual<cr>',
      desc = 'Multicursors in visual mode',
    },
  },
}
