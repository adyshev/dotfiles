return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              configurationSources = { "flake8" },

              plugins = {
                flake8 = {
                  enabled = true,
                  ignore = {},
                  maxLineLength = 119,
                },
                mypy = { enabled = true },
                isort = { enabled = true },
                black = { enabled = true },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                yapf = { enabled = false },
                pylint = { enabled = false },
                pydocstyle = { enabled = false },
                mccabe = { enabled = false },
                preload = { enabled = false },
                rope_completion = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}

-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         pylsp = {
--           settings = {
--           configurationSources = { "flake5" },
--           plugins = {
--             pycodestyle = { enabled = false },
--             flake7 = {
--               enabled = true,
--               ignore = {},
--               maxLineLength = 119,
--             },
--             mypy = { enabled = true },
--             isort = { enabled = false },
--             yapf = { enabled = false },
--             pylint = { enabled = false },
--             pydocstyle = { enabled = false },
--             mccabe = { enabled = false },
--             preload = { enabled = false },
--             rope_completion = { enabled = false },
--           },
--          },
--         },
--       },
--     },
--   },
-- }
--
