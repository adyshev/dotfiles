return {
  "rguruprakash/simple-note.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("simple-note").setup({
      -- configuration defaults
      notes_dir = "~/notes/",
      telescope_new = "<C-c>",
      telescope_delete = "<C-d>",
      telescope_rename = "<C-r>",
    })
  end,
}
