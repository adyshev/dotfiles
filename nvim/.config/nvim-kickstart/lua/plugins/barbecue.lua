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

      theme = {
        normal = { bg = '#32302F' },
      },
    }
  end,
}
