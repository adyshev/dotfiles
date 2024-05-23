return {
  'shortcuts/no-neck-pain.nvim',
  cmd = 'NoNeckPain',
  keys = { { '<leader>z', '<cmd>NoNeckPain<cr>', desc = '[z]Zen Mode' } },
  config = function()
    require('no-neck-pain').setup {
      width = 128,
    }
  end,
}
