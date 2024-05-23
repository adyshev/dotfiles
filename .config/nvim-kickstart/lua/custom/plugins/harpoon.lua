return {
  'theprimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('harpoon'):setup()
  end,
  keys = {
    {
      '<leader>A',
      function()
        require('harpoon'):list():add()
      end,
      desc = '[A]harpoon file',
    },
    {
      '<leader>a',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = '[a]harpoon quick menu',
    },
    {
      '<leader>1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = '[1]harpoon to file 1',
    },
    {
      '<leader>2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = '[2]harpoon to file 2',
    },
    {
      '<leader>3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = '[3]harpoon to file 3',
    },
    {
      '<leader>4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = '[4]harpoon to file 4',
    },
    {
      '<leader>5',
      function()
        require('harpoon'):list():select(5)
      end,
      desc = '[5]harpoon to file 5',
    },
    {
      '<leader>6',
      function()
        require('harpoon'):list():select(6)
      end,
      desc = '[6]harpoon to file 6',
    },
    {
      '<leader>7',
      function()
        require('harpoon'):list():prev()
      end,
      desc = '[7]Prev Harpoon',
    },
    {
      '<leader>8',
      function()
        require('harpoon'):list():next()
      end,
      desc = '[8]Next Harpoon',
    },
  },
}
