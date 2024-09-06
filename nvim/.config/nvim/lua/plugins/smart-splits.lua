return {
  'mrjones2014/smart-splits.nvim',
  config = function()
    require('smart-splits').setup {
      extensions = {
        -- default settings shown below:
        smart_splits = {
          directions = { 'h', 'j', 'k', 'l' },
          mods = {
            -- for moving cursor between windows
            move = '<C>',
            -- for resizing windows
            resize = '<M>',
            -- for swapping window buffers
            swap = false, -- false disables creating a binding
          },
        },
        -- or, customize the mappings
        smart_splits = {
          mods = {
            -- any of the mods can also be a table of the following form
            swap = {
              -- this will create the mapping like
              -- <leader><C-h>
              -- <leader><C-j>
              -- <leader><C-k>
              -- <leader><C-l>
              mod = '<C>',
              prefix = '<leader>',
            },
          },
        },
      },
    }

    vim.keymap.set('n', '<C-A-h>', require('smart-splits').resize_left)
    vim.keymap.set('n', '<C-A-j>', require('smart-splits').resize_down)
    vim.keymap.set('n', '<C-A-k>', require('smart-splits').resize_up)
    vim.keymap.set('n', '<C-A-l>', require('smart-splits').resize_right)

    -- moving between splits
    vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
    vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
    vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
    vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
    vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)

    -- swapping buffers between windows
    vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
    vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
    vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
    vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
  end,
}
