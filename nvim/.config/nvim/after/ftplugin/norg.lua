vim.keymap.set('n', '<leader>nr', '<cmd>Neorg return<CR>', { desc = '[r]Neorg Return', buffer = true })
vim.keymap.set('n', '<CR>', '<Plug>(neorg.esupports.hop.hop-link)', { desc = '[CR]Follow the link', buffer = true })
