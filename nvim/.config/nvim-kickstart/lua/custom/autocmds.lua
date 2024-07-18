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

vim.api.nvim_create_autocmd('FocusLost', {
  desc = 'Save/write all unsaved buffers when focus is lost',
  pattern = '*',
  command = 'silent! wall',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Jump to the last known position of a file before closing it',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
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
  pattern = { '*.txt', '*.md', '*.toml', 'Makefile' },
  command = [[%s/\s\+$//e]],
  desc = 'Trim spaces for MD and TXT files',
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

-- Disable commenting new lines
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'
