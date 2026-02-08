local indent = 2

vim.o.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add"
vim.opt.swapfile = false
vim.o.formatoptions = "jcroqlnt"
vim.o.shortmess = "filnxtToOFWIcC"
vim.o.breakindent = true
vim.opt.winborder = "rounded"
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
vim.o.confirm = true
vim.o.cursorline = true
vim.opt.scrolloff = 999
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.cmdheight = 0
vim.opt.completeopt = "menuone,noselect"
vim.opt.conceallevel = 0
vim.opt.expandtab = true
vim.opt.hidden = true
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
vim.opt.termguicolors = true
vim.opt.wildmode = "longest:full,full"

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrwPlugin = 0
vim.g.loaded_netrw = 0
vim.g.loaded_netrwSettings = 0
vim.g.loaded_netrwFileHandlers = 0
vim.g.loaded_netrw_gitignore = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.loaded_matchit = 1

vim.lsp.handlers["textDocument/hover"] = function()
    vim.lsp.buf.hover({
        border = "rounded",
    })
end

vim.lsp.handlers["textDocument/signatureHelp"] = function()
    vim.lsp.buf.hover({
        border = "rounded",
    })
end
