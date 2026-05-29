local indent = 2

require("utils.clipboard").setup()

vim.o.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add"
vim.opt.swapfile = false
vim.o.formatoptions = "jcroqlnt"
vim.o.shortmess = "filnxtToOFWIcC"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.smartcase = true
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
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true
vim.opt.shiftwidth = indent
vim.opt.tabstop = indent
vim.o.showtabline = 0
vim.opt.wildmode = "longest:full,full"
vim.o.confirm = false
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrw_gitignore = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- lualine still calls the deprecated vim.validate({ name = { value, type } }) form.
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
