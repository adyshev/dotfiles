return {
  'nvim-neotest/neotest',
  event = 'VeryLazy',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-plenary',
    'nvim-neotest/neotest-vim-test',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-go',
  },
  config = function()
    require('neotest').setup {
      status = { virtual_text = false },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require('trouble').open { mode = 'quickfix', focus = false }
        end,
      },
      adapters = {
        require 'neotest-python',
        require 'neotest-go' {
          args = { '-v', '-race', '-count=1', '-timeout=60s', '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out' },
          recursive_run = true,
        },
      },
    }
  end,
  keys = {
    {
      '<leader>ta',
      function()
        require('neotest').run.attach()
      end,
      desc = '[t]est [a]ttach',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = '[t]est run [f]ile',
    },
    {
      '<leader>tA',
      function()
        require('neotest').run.run(vim.fn.getcwd() .. '/test')
      end,
      desc = '[t]est [A]ll files',
    },
    {
      '<leader>tS',
      function()
        require('neotest').run.run { suite = true }
      end,
      desc = '[t]est [S]uite',
    },
    {
      '<leader>tn',
      function()
        require('neotest').run.run()
      end,
      desc = '[t]est [n]earest',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = '[t]est [l]ast',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = '[t]est [s]ummary',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open { enter = true, auto_close = true }
      end,
      desc = '[t]est [o]utput',
    },
    {
      '<leader>tO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = '[t]est [O]utput panel',
    },
    {
      '<leader>tt',
      function()
        require('neotest').run.stop()
      end,
      desc = '[t]est [t]erminate',
    },
    {
      '<leader>td',
      function()
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = '[t]est [d]ebug',
    },
  },
}
