return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark", -- or cool | dark | darker
      })
      require("onedark").load()
    end,
    opts = {
      -- Custom Highlights --
      colors = { -- Override default colors
        dark = "#1d1f21",
        bg4 = "#3b4261",
        white = "#eeeeee",
        cream = "#fcf1cf",
      },
      highlights = { -- Override highlight groups
        ["NormalDark"] = { bg = "$dark" },

        ["IndentBlanklineChar"] = { fg = "$bg3" },
        ["MiniIndentscopeSymbol"] = { fg = "$bg_blue" },

        ["IlluminatedWordText"] = { bg = "$bg4" },
        ["IlluminatedWordRead"] = { bg = "$bg4" },
        ["IlluminatedWordWrite"] = { bg = "$bg4" },

        ["StorageClass"] = { fg = "$white" },

        ["@field"] = { fg = "$red" },
        ["@function.macro"] = { fg = "$orange", fmt = "italic" },
        ["@namespace"] = { fg = "$cyan" },
        ["@parameter"] = { fg = "$red", fmt = "italic" },
        ["@punctuation.special"] = { fg = "$purple" },
        ["@type.builtin"] = { fg = "$blue" },
        ["@type.qualifier"] = { fg = "$purple" },
        ["@variable"] = { fg = "$cream" },

        ["@lsp.mod.mutable"] = { fmt = "bold,underline" },
        ["@lsp.type.attributeBracket"] = { fg = "$white" },
        ["@lsp.type.builtinType"] = { fg = "$blue" },
        ["@lsp.type.decorator"] = { fg = "$orange" },
        ["@lsp.type.enum"] = { fg = "$cyan" },
        ["@lsp.type.generic"] = { fg = "$cream" },
        ["@lsp.type.interface"] = { fg = "$blue" },
        ["@lsp.type.macro"] = { fg = "$orange", fmt = "italic" },
        ["@lsp.type.namespace"] = { fg = "$cyan" },
        ["@lsp.type.parameter"] = { fg = "$red", fmt = "italic" },
        ["@lsp.type.property"] = { fg = "$red" },
        ["@lsp.type.selfKeyword"] = { fg = "$purple", fmt = "italic" },
        ["@lsp.type.selfTypeKeyword"] = { fg = "$purple" },
        ["@lsp.type.typeParameter"] = { fg = "$white" },
        ["@lsp.type.variable"] = { fg = "$cream" },
        ["@lsp.typemod.enumMember.defaultLibrary"] = { fg = "$yellow" },
        ["@lsp.typemod.keyword.constant"] = { fg = "$purple" },
        ["@lsp.typemod.variable.constant"] = { fg = "$orange" },
      },
    },
  },
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { "wittyjudge/gruvbox-material.nvim" },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "gruvbox-material",
      colorscheme = "onedark",
      -- colorscheme = "catppuccin-macchiato", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    },
  },
}
