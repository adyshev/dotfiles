-- Autocommands
vim.api.nvim_create_autocmd("CmdWinEnter", {
    pattern = "*",
    callback = function()
        if vim.g.requested_cmdwin then
            vim.g.requested_cmdwin = nil
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":q<CR>:", true, false, true), "m", false)
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Close some filtypes simply by pressing 'q'",
    pattern = { "checkhealth", "help", "lspinfo", "man", "notify", "qf", "query", "lazygit" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    callback = function()
        if vim.bo.filetype == "" then
            vim.bo.commentstring = "# %s"
        end
    end,
})

-- :h restore-cursor
-- local function RestoreCursorPosition()
--     if vim.buftype == "terminal" then
--         return
--     end
--     local ft = vim.bo.filetype
--     if not (ft:match("commit") or ft:match("rebase")) and vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
--         vim.cmd('normal! g`"')
--     end
-- end
--
-- vim.api.nvim_create_autocmd({ "BufRead" }, {
--     pattern = "*",
--     callback = RestoreCursorPosition,
-- })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    desc = "Redraw the cursorline when navigating around the buffer",
    callback = function()
        if vim.wo.cursorline then
            vim.cmd("redraw")
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.md" },
    callback = function()
        vim.opt.expandtab = true
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.spell = true
        vim.opt.spelllang = { "en_us" }
    end,
    desc = "Enable spell checking for certain file types",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    callback = function()
        require("mini.trailspace").trim()
    end,
    desc = "Trim spaces",
})

vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Auto select virtualenv Nvim open",
    pattern = "*",
    callback = function()
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
    once = true,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.py" },
    callback = function()
        vim.opt.tabstop = 4 -- Number of spaces tabs count for
        vim.opt.colorcolumn = "120" -- Ruler at column number
        vim.opt.shiftwidth = 2 -- Size of an indent
        vim.opt.softtabstop = 4
    end,
    desc = "Python specific settings",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "oil",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
    },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})

-- Show/Close diagnostic messages
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--     pattern = "*",
--     callback = function()
--         for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
--             if vim.api.nvim_win_get_config(winid).zindex then
--                 return
--             end
--         end
--         vim.diagnostic.open_float({
--             scope = "line",
--             focusable = false,
--             close_events = {
--                 "CursorMoved",
--                 "CursorMovedI",
--                 "BufHidden",
--                 "InsertCharPre",
--                 "WinLeave",
--             },
--         })
--     end,
-- })
--
vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})

-- vim.api.nvim_create_autocmd("TextYankPost", {
--     callback = function()
--         vim.highlight.on_yank({ higroup = "Search" })
--     end,
-- })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "golang", "lua", "gitignore", "*.json", "*.toml", "*.yaml", "makefile" },
    command = "setlocal nospell",
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local args = vim.v.argv
        -- skip program name, look for first non-option arg
        for i = 2, #args do
            local arg = args[i]
            if not arg:match("^%-") and vim.fn.isdirectory(arg) == 1 then
                vim.cmd("cd " .. vim.fn.fnameescape(arg))
                break
            end
        end
    end,
})

-- Cursor look
vim.api.nvim_set_hl(0, "TerminalCursorShape", { fg = "NONE", bg = "NONE", blend = 0, underline = true })
vim.cmd("autocmd TermEnter * setlocal winhighlight=TermCursor:TerminalCursorShape")

-- Disable commenting new lines
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")
vim.cmd("autocmd BufEnter * silent! :lcd%:p:h")
