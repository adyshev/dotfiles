return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-M-n>",
      ["Add Cursor Down"] = "<C-M-j>",
      ["Add Cursor Up"] = "<C-M-k>",
    }
  end,
}
