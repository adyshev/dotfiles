local indent = 2

-- Configure the system clipboard before setting `clipboard=unnamedplus`.
-- The helper picks the best provider for the current host: pbcopy on macOS,
-- wl-clipboard on Wayland, xclip/xsel on X11, and OSC52 as a fallback.
require("utils.clipboard").setup()

-- Editing model
-- Keep buffers responsive and persistent without producing swap files in each
-- project. Undo history is stored in Neovim's undo directory instead.
vim.o.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add"
vim.opt.swapfile = false
vim.o.formatoptions = "jcroqlnt"
vim.o.shortmess = "filnxtToOFWIcC"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.smartcase = true

-- Window and UI defaults
-- These are global defaults; filetype-specific overrides live in ftplugin or
-- autocmds. `laststatus=0` is intentional because lualine is hidden outside
-- focused editing contexts in this setup.
vim.o.winborder = "rounded"
vim.o.smartindent = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.list = true
vim.o.cursorline = true
vim.opt.scrolloff = 999
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.cmdheight = 0
vim.opt.conceallevel = 0
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.joinspaces = false
vim.opt.laststatus = 0
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.pumblend = 10
vim.opt.pumheight = 10

-- Session files should remember layout and working directory, but not options
-- that are already controlled by this config.
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true
vim.opt.shiftwidth = indent
vim.opt.tabstop = indent
vim.o.showtabline = 0
vim.opt.wildmode = "longest:full,full"
vim.o.confirm = false

-- Leader keys and font capability must be set before plugins define mappings/UI.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Oil is the file explorer, so disable netrw early to avoid duplicate file
-- browser autocommands and startup work.
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrw_gitignore = 1

-- Disable language providers that this config does not use. This removes
-- checkhealth noise and avoids probing runtimes on every startup.
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- lualine still calls the deprecated vim.validate({ name = { value, type } }) form.
-- Neovim 0.12 tightened `vim.validate`; this compatibility shim accepts the
-- legacy table form and forwards all modern calls unchanged. Keep it scoped and
-- minimal so it can be removed once lualine no longer needs it.
do
    local validate = vim.validate
    local aliases = { n = "number", s = "string", t = "table", b = "boolean", f = "function", c = "callable" }

    vim.validate = function(name, value, validator, optional_or_msg, ...)
        if type(name) == "table" and value == nil and validator == nil and optional_or_msg == nil and select("#", ...) == 0 then
            for key, spec in pairs(name) do
                local expected = spec[2]
                if type(expected) == "string" then
                    expected = aliases[expected] or expected
                end
                validate(key, spec[1], expected, spec[3])
            end
            return
        end

        return validate(name, value, validator, optional_or_msg, ...)
    end
end
