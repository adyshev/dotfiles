vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
-- vim.opt.relativenumber = true

vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.nu = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.spell = false

vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.showmatch = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.isfname:append '@-@'
vim.opt.conceallevel = 2
vim.o.spellfile = os.getenv 'HOME' .. '/.config/nvim-kickstart/spell/en.utf-8.add'

vim.g.loaded_netrwPlugin = 0
vim.g.loaded_netrw = 0
vim.g.loaded_netrwSettings = 0
vim.g.loaded_netrwFileHandlers = 0
vim.g.loaded_netrw_gitignore = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.diagnostic.config {
  float = {
    border = 'rounded',
  },
}
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.cmd [[noremap ; :]]
vim.cmd [[command! Qa :qa]]
vim.cmd [[command! Q :q]]
