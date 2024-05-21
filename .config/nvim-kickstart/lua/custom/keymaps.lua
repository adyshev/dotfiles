-- Added useful keymaps
vim.keymap.set('n', 'vA', 'gg^VG', { desc = 'All' })
vim.keymap.set('n', 'yA', 'gg^VGy', { desc = 'All' })
vim.keymap.set('n', '<PageDown>', '<C-d>zz')
vim.keymap.set('n', '<PageUp>', '<C-u>zz')
vim.keymap.set('n', 'q:', ':')
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', '<C-z>', ':echo "Yaay!!!"<CR>')
