return {
  'utilyre/barbecue.nvim',
  name = 'barbecue',
  version = '*',
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons', -- optional dependency
  },
  config = function()
    vim.opt.updatetime = 200

    require('barbecue').setup {
      create_autocmd = false, -- prevent barbecue from updating itself automatically
      show_dirname = false,
      show_modified = true,
      show_basename = true,
    }

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
    vim.keymap.set('n', '[b', function()
      require('barbecue.ui').navigate(-2)
    end, { silent = true, desc = 'Go to parent context' })
  end,
}
