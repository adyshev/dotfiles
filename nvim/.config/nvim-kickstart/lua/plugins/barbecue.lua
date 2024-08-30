return {
  'utilyre/barbecue.nvim',
  name = 'barbecue',
  version = '*',
  enabled = true,
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons', -- optional dependency
  },
  config = function()
    vim.opt.updatetime = 200

    require('barbecue').setup {
      show_dirname = false,
      show_modified = false,
      show_basename = false,
      create_autocmd = false,
      theme = {
        normal = { bg = '#282828', fg = '#4E4E4E' },
      },
    }

    vim.keymap.set('n', '[c', function()
      require('barbecue.ui').navigate(-2)
    end, { silent = true, desc = 'Go to parent context' })

    vim.api.nvim_create_autocmd({
      'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
      'BufWinEnter',
      'CursorHold',
      'InsertLeave',

      -- include this if you have set `show_modified` to `true`
      'BufModifiedSet',
    }, {
      group = vim.api.nvim_create_augroup('barbecue.updater', {}),
      callback = function()
        require('barbecue.ui').update()
      end,
    })
  end,
}
