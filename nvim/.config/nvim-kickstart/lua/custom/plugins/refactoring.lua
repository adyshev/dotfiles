return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('refactoring').setup()
    vim.keymap.set({ 'n', 'x' }, '<leader>r', function()
      require('refactoring').select_refactor()
    end, { desc = '[r]Refactoring' })
  end,
}
