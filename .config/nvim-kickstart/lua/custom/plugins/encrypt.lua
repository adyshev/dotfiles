return {
  'Praczet/encrypt-text.nvim',
  config = function()
    require('encrypt-text').setup()
    vim.keymap.set('n', '<leader>me', '<cmd>Encrypt<cr>', { desc = '[e]Encrypt Document' })
    vim.keymap.set('n', '<leader>md', '<cmd>Decrypt<cr>', { desc = '[d]Decrypt Document' })
  end,
}
