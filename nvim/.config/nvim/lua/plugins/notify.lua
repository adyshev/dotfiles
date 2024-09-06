return {
  -- UI plugin for showing notifications appropriately instead of taking up the message space
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  init = function()
    -- Set Neovim to use 24-bit colours
    vim.opt.termguicolors = true
  end,
  config = function()
    local notify = require 'notify'
    notify.setup {
      timeout = 500,
      -- render = 'minimal',
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.25)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    }
    vim.notify = notify
  end,
}
