-- Autocommands
vim.api.nvim_create_autocmd('CmdWinEnter', {
  pattern = '*',
  callback = function()
    if vim.g.requested_cmdwin then
      vim.g.requested_cmdwin = nil
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':q<CR>:', true, false, true), 'm', false)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = "Close some filtypes simply by pressing 'q'",
  pattern = { 'checkhealth', 'help', 'lspinfo', 'man', 'notify', 'qf', 'query', 'lazygit' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  desc = 'Redraw the cursorline when navigating around the buffer',
  callback = function()
    if vim.wo.cursorline then
      vim.cmd 'redraw'
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.norg' },
  callback = function()
    vim.opt.expandtab = true
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.spell = true
    vim.opt.spelllang = { 'en_us' }
  end,
  desc = 'Enable spell checking for certain file types',
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*',
  callback = function()
    MiniTrailspace.trim()
  end,
  desc = 'Trim spaces',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.py' },
  callback = function()
    vim.opt.tabstop = 4 -- Number of spaces tabs count for
    vim.opt.colorcolumn = '120' -- Ruler at column number
    vim.opt.shiftwidth = 2 -- Size of an indent
    vim.opt.softtabstop = 4
  end,
  desc = 'Python specific settings',
})

local file_exists_and_is_empty = function(filepath)
  local file = io.open(filepath, 'r') -- Open the file in read mode
  if file ~= nil then
    local content = file:read '*all' -- Read the entire content of the file
    file:close() -- Close the file
    return content == '' -- Check if the content is empty
  else
    return false
  end
end

-- vim.api.nvim_create_autocmd({ 'BufNew', 'BufNewFile' }, {
--   callback = function(args)
--     vim.schedule(function()
--       if args.event == 'BufNewFile' or (args.event == 'BufNew' and file_exists_and_is_empty(args.file)) then
--         vim.api.nvim_cmd({ cmd = 'Neorg', args = { 'templates', 'fload', 'journal' } }, {})
--       end
--     end)
--   end,
--   pattern = '**/journal/years/*/*/*.norg',
-- })
--
-- vim.api.nvim_create_autocmd('BufNewFile', {
--   command = 'Neorg templates fload work',
--   pattern = { '**/neorg/work/*.norg' },
-- })
--
-- vim.api.nvim_create_autocmd('BufNewFile', {
--   command = 'Neorg templates fload personal',
--   pattern = { '**/neorg/personal/*.norg' },
-- })

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'help',
    'alpha',
    'dashboard',
    'neo-tree',
    'Trouble',
    'trouble',
    'lazy',
    'oil',
    'mason',
    'notify',
    'toggleterm',
    'lazyterm',
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- Show/Close diagnostic messages
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float {
      scope = 'line',
      focusable = false,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'BufHidden',
        'InsertCharPre',
        'WinLeave',
      },
    }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', '*.go', '*.lua', 'gitignore', '*.json', '*.toml', '*.yaml', 'makefile' },
  command = 'setlocal nospell',
})

-- Disable commenting new lines
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'
