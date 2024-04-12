-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "go" },
  callback = function()
    vim.opt_local.colorcolumn = "120" -- Ruler at column number
    vim.opt_local.tabstop = 4 -- Number of spaces tabs count for
    vim.opt_local.shiftwidth = 4 -- Size of an indent
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("trim_whitespaces", { clear = true }),
  desc = "Trim trailing white spaces",
  pattern = "*",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "<buffer>",
      -- Trim trailing whitespaces
      callback = function()
        -- Save cursor position to restore later
        local curpos = vim.api.nvim_win_get_cursor(0)
        -- Search and replace trailing whitespaces
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})

-- disable completion on markdown files by default
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    require("cmp").setup({ enabled = false })
  end,
})
