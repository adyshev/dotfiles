return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('trouble').setup()
    vim.keymap.set('n', '<leader>xx', function()
      require('trouble').toggle()
    end, { desc = '[x]Toggle Trouble' })
    vim.keymap.set('n', '<leader>xw', function()
      require('trouble').toggle 'workspace_diagnostics'
    end, { desc = '[w]Toggle Trouble Workspace' })
    vim.keymap.set('n', '<leader>xd', function()
      require('trouble').toggle 'document_diagnostics'
    end, { desc = '[d]Toggle Trouble Document' })
    vim.keymap.set('n', '<leader>xq', function()
      require('trouble').toggle 'quickfix'
    end, { desc = '[q]QuickFix' })
    vim.keymap.set('n', '<leader>xl', function()
      require('trouble').toggle 'loclist'
    end, { desc = '[l]Loclist' })
    vim.keymap.set('n', 'gr', function()
      require('trouble').toggle 'lsp_references'
    end, { desc = 'LSP: [R]Goto Lsp References' })
  end,
}
