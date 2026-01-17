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
        MiniTrailspace.trim()
    end,
    desc = "Trim spaces",
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " " or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
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

-- local file_exists_and_is_empty = function(filepath)
--   local file = io.open(filepath, 'r') -- Open the file in read mode
--   if file ~= nil then
--     local content = file:read '*all' -- Read the entire content of the file
--     file:close() -- Close the file
--     return content == '' -- Check if the content is empty
--   else
--     return false
--   end
-- end

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
