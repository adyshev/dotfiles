-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

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

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Auto select virtualenv Nvim open',
  pattern = '*',
  callback = function()
    local venv = vim.fn.findfile('pyproject.toml', vim.fn.getcwd() .. ';')
    if venv ~= '' then
      require('venv-selector').retrieve_from_cache()
    end
  end,
  once = true,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md' },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = 'en' -- could be 'en,gb,fr'
  end,
  desc = 'Enable spell checking for certain file types',
})

vim.api.nvim_create_autocmd('Filetype', {
  pattern = { '*.go', '*.python' },
  callback = function()
    vim.opt.colorcolumn = '120' -- Ruler at column number
    vim.opt.tabstop = 4 -- Number of spaces tabs count for
    vim.opt.shiftwidth = 4 -- Size of an indent
    vim.opt.softtabstop = 4
  end,
  desc = 'Golang & Python specific settings',
})

vim.api.nvim_create_autocmd('Filetype', {
  pattern = '*.lua',
  callback = function()
    vim.opt.colorcolumn = '120' -- Ruler at column number
  end,
  desc = 'Golang & Python specific settings',
})
