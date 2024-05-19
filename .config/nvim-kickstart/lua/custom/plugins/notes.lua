return {
  'rguruprakash/simple-note.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('simple-note').setup {
      -- configuration defaults
      notes_dir = '~/notes/',
      telescope_new = '<M-c>',
      telescope_delete = '<M-d>',
      telescope_rename = '<M-r>',
    }
    vim.keymap.set('n', '<leader>so', ':SimpleNoteList<CR>', { desc = '[O]Search Notes' })
  end,
}
