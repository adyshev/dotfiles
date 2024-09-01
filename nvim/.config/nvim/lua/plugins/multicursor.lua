return {
  'mg979/vim-visual-multi',
  branch = 'master',
  init = function()
    vim.cmd [[
      let g:VM_default_mappings = 0
      let g:VM_maps = {}
      let g:VM_maps['Find Under']         = '<C-n>'           " replace C-n
      let g:VM_maps['Find Subword Under'] = '<C-n>'           " replace visual C-n
    ]]
  end,
}
