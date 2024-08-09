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
  pattern = { 'checkhealth', 'help', 'lspinfo', 'man', 'notify', 'qf', 'query' },
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
  pattern = { '*.txt', '*.md' },
  callback = function()
    vim.opt.expandtab = true
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.spell = true
    vim.opt.spelllang = { 'en_us' }
    vim.opt.colorcolumn = '120' -- Ruler at column number
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
    vim.opt.colorcolumn = '120' -- Ruler at column number
    vim.opt.tabstop = 4 -- Number of spaces tabs count for
    vim.opt.shiftwidth = 2 -- Size of an indent
    vim.opt.softtabstop = 4
  end,
  desc = 'Python specific settings',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'help',
    'alpha',
    'dashboard',
    'neo-tree',
    'Trouble',
    'trouble',
    'lazy',
    'mason',
    'notify',
    'toggleterm',
    'lazyterm',
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- Restore Beam '|' cursor
vim.cmd [[augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver25
augroup END]]

-- Disable commenting new lines
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'
