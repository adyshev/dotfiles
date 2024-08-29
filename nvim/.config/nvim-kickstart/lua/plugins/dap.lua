return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<leader>dO',
        function()
          require('dap').step_out()
        end,
        desc = '[O]Step Out',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = '[o]Step Over',
      },
    },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {
      virt_text_win_col = 80,
    },
  },
}
