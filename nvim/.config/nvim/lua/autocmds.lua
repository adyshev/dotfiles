-- Autocommands
--
-- This file holds editor-wide event hooks. Plugin-specific autocommands stay
-- with their plugin specs unless they coordinate behavior across plugins.

-- `q:` opens the command-line window, which is rarely intentional in this
-- workflow. `keymaps.lua` maps `q:` back to `:`, but this guard also catches
-- accidental command-window entry from other paths and immediately returns to
-- the normal command line.
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

-- Common utility buffers should behave like transient panels: no buffer list
-- entry and a single-key close action. This keeps help/checkhealth/qf windows
-- easy to dismiss without affecting normal file buffers.
vim.api.nvim_create_autocmd("FileType", {
    desc = "Close some filtypes simply by pressing 'q'",
    pattern = { "checkhealth", "help", "lspinfo", "man", "notify", "qf", "query", "lazygit" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- For buffers with no detected filetype, use shell-style comments. This gives
-- plugins that depend on `commentstring` a sane default for scratch files and
-- extensionless config files.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    callback = function()
        if vim.bo.filetype == "" then
            vim.bo.commentstring = "# %s"
        end
    end,
})

-- Hide lualine while the command line is active. With cmdheight=0 and Noice,
-- the command area is compact; hiding the statusline reduces visual overlap
-- and restores it immediately after command-line mode exits.
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

-- Markdown is written with two-space indentation and spell checking. This is
-- intentionally filetype-local so source code keeps its own indentation rules.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { "en_us" }
    end,
    desc = "Enable spell checking for certain file types",
})

-- Trim trailing whitespace just before writing real, editable file buffers.
-- The modifiable/readonly checks prevent plugin stack traces in help, picker,
-- Oil, terminal, and other special buffers.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" and vim.bo.modifiable and not vim.bo.readonly then
            require("mini.trailspace").trim()
        end
    end,
    desc = "Trim spaces",
})

-- If the current project has a pyproject.toml, ask venv-selector to restore the
-- last selected virtualenv. The pcall keeps startup clean on machines where the
-- plugin has not loaded yet or no Python workflow is active.
vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Auto select virtualenv Nvim open",
    pattern = "*",
    callback = function()
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
            local ok, venv_selector = pcall(require, "venv-selector")
            if ok then
                venv_selector.retrieve_from_cache()
            end
        end
    end,
    once = true,
})

-- Python defaults differ from the global two-space settings. Keep the 120
-- column marker aligned with the formatter/linter settings in the LSP config.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.colorcolumn = "120"
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
    end,
    desc = "Python specific settings",
})

-- Oil emits this event after file operations. Forward renames to Snacks so LSP
-- clients and open buffers can update references after a file is moved.
vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        for _, action in ipairs(event.data.actions) do
            if action.type == "move" then
                Snacks.rename.on_rename_file(action.src_url, action.dest_url)
            end
        end
    end,
})

-- Spell checking is useful in prose but noisy in code and config files.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "go", "lua", "gitignore", "json", "toml", "yaml", "make" },
    command = "setlocal nospell",
})

-- When Neovim is opened with a directory argument, switch the working directory
-- to that path. This makes picker, Oil, and relative commands operate from the
-- project root the terminal launched.
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

-- Terminal buffers use a separate cursor highlight. This makes terminal mode
-- visible without changing the global cursor configuration.
vim.api.nvim_set_hl(0, "TerminalCursorShape", { fg = "NONE", bg = "NONE", blend = 0, underline = true })
vim.api.nvim_create_autocmd("TermEnter", {
    desc = "Terminal cursor shape",
    callback = function()
        vim.wo.winhighlight = "TermCursor:TerminalCursorShape"
    end,
})

-- Avoid automatically continuing comment leaders after pressing Enter or `o`.
-- This is applied on BufEnter because some filetype plugins reset
-- `formatoptions` after the buffer is created.
vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Disable commenting new lines",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Surface macro recording state through Snacks notifications. Neovim's native
-- recording indicator can be easy to miss with a minimal statusline.
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
--
-- Many UI plugins open floating windows that do not fully block mouse input to
-- windows behind them. The backdrop window and mouse guards below make focused
-- floats behave more like modals: clicks/scrolls outside the float are ignored
-- until focus returns to a normal window.
local _focused_float = nil
local _backdrop_win = nil
local _backdrop_buf = nil

vim.api.nvim_set_hl(0, "FloatBackdrop", { bg = "#000000" })

local function show_backdrop()
    -- Reuse an existing backdrop if the current float changes focus without
    -- closing the old window.
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
    -- Backdrop buffers are scratch buffers with bufhidden=wipe, so closing the
    -- window is enough to clean up both UI and buffer state.
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
        -- If a float is focused, suppress mouse events aimed at normal windows
        -- or the backdrop. Mouse events inside another float are still allowed.
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
    "<ScrollWheelUp>",
    "<ScrollWheelDown>",
    "<ScrollWheelLeft>",
    "<ScrollWheelRight>",
    "<LeftMouse>",
    "<2-LeftMouse>",
    "<3-LeftMouse>",
    "<RightMouse>",
}
for _, ev in ipairs(guarded_events) do
    vim.keymap.set({ "n", "i", "v" }, ev, mouse_guard(ev), { expr = true, desc = "Guard mouse while float is focused" })
end
