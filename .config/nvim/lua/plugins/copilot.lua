return {
  {
    "github/copilot.vim",
    enabled = false,
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    config = function()
      vim.keymap.set("i", "<C-j>", [[copilot#Accept("\<CR>")]], {
        silent = true,
        expr = true,
        script = true,
        replace_keycodes = false,
      })
    end,
  },
}
