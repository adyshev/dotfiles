return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<C-r>'] = 'actions.refresh',
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return vim.startswith(name, '.DS_Store') or name == '..' or name == '.git'
          end,
        },
        win_options = {
          wrap = true,
        },
      }
    end,
    keys = {
      { '-', '<cmd>Oil<cr>', mode = 'n', desc = 'Open Filesystem' },
    },
  },
}
