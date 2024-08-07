local api = vim.api

function AttachFileBrowser(plugin_name, plugin_open)
  local previous_buffer_name
  api.nvim_create_autocmd('BufEnter', {
    group = api.nvim_create_augroup('UserUtilsCustomAutocmds', { clear = true }), -- I use the same group for all my autocmds. To create one: vim.api.nvim_create_augroup("CustomAutocmdGroupName", { clear = true })
    desc = string.format('[%s] replacement for Netrw', plugin_name),
    pattern = '*',
    callback = function()
      vim.schedule(function()
        local buffer_name = api.nvim_buf_get_name(0)
        if vim.fn.isdirectory(buffer_name) == 0 then
          _, previous_buffer_name = pcall(vim.fn.expand, '#:p:h')
          return
        end

        -- Avoid reopening when exiting without selecting a file
        if previous_buffer_name == buffer_name then
          previous_buffer_name = nil
          return
        else
          previous_buffer_name = buffer_name
        end

        -- Ensure no buffers remain with the directory name
        api.nvim_set_option_value('bufhidden', 'wipe', { buf = 0 })
        plugin_open(vim.fn.expand '%:p:h')
      end)
    end,
  })
end

return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- enabled = false,
    init = function()
      local oil_open_folder = function(path)
        require('oil').open(path)
      end
      AttachFileBrowser('oil', oil_open_folder)
    end,
    config = function()
      require('oil').setup {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        columns = { 'icon' },
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
          ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return vim.startswith(name, '.DS_Store') or name == '..' or name == '.git'
          end,
        },
        win_options = {
          wrap = true,
          winblend = 0,
        },
      }
    end,
    keys = {
      { '\\', '<cmd>Oil<cr>', mode = 'n', desc = 'Open Filesystem' },
    },
  },
}
