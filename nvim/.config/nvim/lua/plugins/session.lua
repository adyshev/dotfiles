return {
  'stevearc/resession.nvim',
  config = function()
    local resession = require 'resession'
    local session_dir = vim.fn.stdpath 'config' .. '/session'

    resession.setup {
      dir = session_dir,
    }

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        resession.save 'last'
      end,
    })

    vim.keymap.set('n', '<leader>ss', resession.save, { desc = '[s]Save Session' })
    vim.keymap.set('n', '<leader>sl', resession.load, { desc = '[l]Load Session' })
    vim.keymap.set('n', '<leader>sd', resession.delete, { desc = '[d]Delete Session' })
  end,
}
