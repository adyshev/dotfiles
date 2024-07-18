return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files Telescope" },
    },
    opts = {
      pickers = {
        find_files = {
          -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
          find_command = { "rg", "--files", "--glob", "!**/.git/*", "-L" },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope-symbols.nvim",
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    keys = {
      { "<leader>fq", "<cmd>Telescope frecency<cr>", desc = "frecency (root dir)" },
      { "<leader>fQ", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "frecency (cwd)" },
    },
    config = function()
      require("telescope").load_extension("frecency")
    end,
    opts = {
      db_safe_mode = false,
    },
  },
  -- Custom ripgrep configuration:

  -- I want to search in hidden/dot files.
  -- "--hidden"
  --
  -- I don't want to search in the `.git` directory.
  -- "--glob")
  -- "!**/.git/*")
  --
  --  I want to follow symbolic links
  -- "-L"
  --
}
