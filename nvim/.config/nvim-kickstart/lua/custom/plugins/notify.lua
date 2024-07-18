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
      render = 'minimal',
    }
    vim.notify = notify
  end,
}
