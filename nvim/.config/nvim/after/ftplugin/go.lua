vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false
vim.opt_local.listchars = "tab:  "

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require("go.format").goimports()
    end,
    group = format_sync_grp,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "golang" },
    command = "setlocal nospell",
})
