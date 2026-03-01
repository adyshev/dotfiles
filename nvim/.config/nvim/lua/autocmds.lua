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

local function lualine_hide()
    local ok, lualine = pcall(require, "lualine")
    if ok then
        lualine.hide({ unhide = false })
    end
end

local function lualine_show()
    local ok, lualine = pcall(require, "lualine")
    if ok then
        lualine.hide({ unhide = true })
    end
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = function()
        lualine_hide()
    end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
        lualine_show()
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
        if vim.bo.buftype == "" then
            require("mini.trailspace").trim()
        end
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

vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "go", "lua", "gitignore", "json", "toml", "yaml", "make" },
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

vim.api.nvim_set_hl(0, "TerminalCursorShape", { fg = "NONE", bg = "NONE", blend = 0, underline = true })
vim.api.nvim_create_autocmd("TermEnter", {
    desc = "Terminal cursor shape",
    callback = function()
        vim.wo.winhighlight = "TermCursor:TerminalCursorShape"
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Disable commenting new lines",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

vim.api.nvim_create_autocmd("RecordingEnter", {
    desc = "Notify when macro recording starts",
    callback = function()
        local reg = vim.fn.reg_recording()
        Snacks.notify("Recording @" .. reg, { title = "Macro" })
    end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
    desc = "Notify when macro recording stops",
    callback = function()
        local reg = vim.fn.reg_recording()
        Snacks.notify("Recorded @" .. reg, { title = "Macro" })
    end,
})

-- Prevent interaction with underlying windows while a float is focused
local _focused_float = nil
local _backdrop_win = nil
local _backdrop_buf = nil

vim.api.nvim_set_hl(0, "FloatBackdrop", { bg = "#000000" })

local function show_backdrop()
    if _backdrop_win and vim.api.nvim_win_is_valid(_backdrop_win) then
        return
    end
    _backdrop_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[_backdrop_buf].bufhidden = "wipe"
    _backdrop_win = vim.api.nvim_open_win(_backdrop_buf, false, {
        relative = "editor",
        width = vim.o.columns,
        height = vim.o.lines,
        row = 0,
        col = 0,
        style = "minimal",
        focusable = false,
        zindex = 1,
        border = "none",
    })
    vim.wo[_backdrop_win].winblend = 20
    vim.wo[_backdrop_win].winhighlight = "Normal:FloatBackdrop"
end

local function hide_backdrop()
    if _backdrop_win and vim.api.nvim_win_is_valid(_backdrop_win) then
        vim.api.nvim_win_close(_backdrop_win, true)
    end
    _backdrop_win = nil
    _backdrop_buf = nil
end

vim.api.nvim_create_autocmd("WinEnter", {
    desc = "Track focused floating window and show backdrop",
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == "WhichKey" or ft == "noice" then
                return
            end
            _focused_float = win
            show_backdrop()
        else
            _focused_float = nil
            hide_backdrop()
        end
    end,
})

vim.api.nvim_create_autocmd("WinClosed", {
    desc = "Clean up backdrop when float closes",
    callback = function(event)
        local closed_win = tonumber(event.match)
        if closed_win == _focused_float then
            _focused_float = nil
            hide_backdrop()
        end
    end,
})

local function mouse_guard(key)
    return function()
        if _focused_float and vim.api.nvim_win_is_valid(_focused_float) then
            local mouse = vim.fn.getmousepos()
            if mouse.winid ~= 0 then
                local target_cfg = vim.api.nvim_win_get_config(mouse.winid)
                if target_cfg.relative == "" or mouse.winid == _backdrop_win then
                    return ""
                end
            end
        end
        return key
    end
end

local guarded_events = {
    "<ScrollWheelUp>", "<ScrollWheelDown>", "<ScrollWheelLeft>", "<ScrollWheelRight>",
    "<LeftMouse>", "<2-LeftMouse>", "<3-LeftMouse>", "<RightMouse>",
}
for _, ev in ipairs(guarded_events) do
    vim.keymap.set({ "n", "i", "v" }, ev, mouse_guard(ev), { expr = true, desc = "Guard mouse while float is focused" })
end
