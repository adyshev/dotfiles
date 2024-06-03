return {
  'linux-cultist/venv-selector.nvim',
  dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
  branch = 'regexp',
  event = 'VeryLazy',
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { '<leader>cv', '<cmd>VenvSelect<cr>', desc = '[v]Select virtualenv' },
  },
  config = function()
    require('venv-selector').setup()
  end,
}
