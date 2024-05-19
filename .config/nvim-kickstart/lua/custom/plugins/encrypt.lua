return {
  'Praczet/encrypt-text.nvim',
  config = function()
    require('encrypt-text').setup()
    vim.keymap.set('n', '<leader>ie', '<cmd>Encrypt<cr>', { desc = 'Encrypt text' })
    vim.keymap.set('n', '<leader>id', '<cmd>Decrypt<cr>', { desc = 'Decrypt text' })
  end,
}
