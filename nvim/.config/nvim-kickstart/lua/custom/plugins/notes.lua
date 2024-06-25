return {
  'rguruprakash/simple-note.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('simple-note').setup {
      -- configuration defaults
      notes_dir = '~/.secondbrain/',
      telescope_new = '<M-c>',
      telescope_delete = '<M-d>',
      telescope_rename = '<M-r>',
    }
    vim.keymap.set('n', '<leader>n', ':SimpleNoteList<CR>', { desc = '[n]Notes' })
  end,
}
