local neorg_dependencies = {
  'nvim-treesitter/nvim-treesitter',
  'hrsh7th/nvim-cmp',
}

local lazy_loading_keymaps = {
  { '<leader>nj', '<cmd>Neorg journal today<cr>', desc = '[j]Journal for Today' },
  { '<leader>nw', '<cmd>Neorg workspace work<cr>', desc = '[w]Work Notes' },
  { '<leader>np', '<cmd>Neorg workspace personal<cr>', desc = '[p]Personal Notes' },
  { '<leader>ne', '<cmd>Neorg export<cr>', desc = '[e]Export Notes' },
}

local dirman_configuration = {
  config = {
    workspaces = {
      work = '~/neorg/work',
      journal = '~/neorg/journal',
      personal = '~/neorg/personal',
    },
    autochdir = true,
    default_workspace = 'personal',
    index = 'index.norg',
  },
}

local module_list = {
  ['core.defaults'] = {},
  ['core.dirman'] = dirman_configuration,
  ['core.presenter'] = {
    config = {
      zen_mode = 'zen-mode',
    },
  },
  ['core.completion'] = {
    config = {
      engine = 'nvim-cmp',
    },
  },
  ['core.journal'] = {
    config = {
      journal_folder = '/years/',
      use_folders = true,
      workspace = 'journal',
    },
  },
  ['core.esupports.metagen'] = {
    config = {
      type = 'auto',
      update_date = true,
      tab = '  ',
      template = {
        -- The title field generates a title for the file based on the filename.
        {
          'title',
          function()
            return vim.fn.expand '%:p:t:r'
          end,
        },

        { 'description', '' },
        { 'authors', 'Oleksandr Dyshev' },
        {
          'categories',
          '',
        },

        -- The created field is populated with the current date as returned by `os.date`.
        {
          'created',
          function()
            return os.date '%Y-%m-%d'
          end,
        },

        -- When creating fresh, new metadata, the updated field is populated the same way
        -- as the `created` date.
        {
          'updated',
          function()
            return os.date '%Y-%m-%d'
          end,
        },

        -- The version field determines which Norg version was used when
        -- the file was created.
        { 'version', require('neorg.core.config').version },
      },
    },
  },
  ['core.export'] = {
    config = {
      export_dir = '~/neorg-export/<language>',
    },
  },
  ['core.export.markdown'] = {
    config = {
      extensions = 'all',
    },
  },
  ['core.summary'] = {},
  ['core.integrations.nvim-cmp'] = {},
  ['core.concealer'] = {
    config = {
      folds = false,
      icon_preset = 'diamond',
      icons = {
        todo = {
          undone = {
            enabled = true,
            icon = ' ',
            query = '(todo_item_undone) @icon',
          },
        },
      },
    },
  },
}

return {
  {
    'nvim-neorg/neorg',
    dependencies = neorg_dependencies,
    keys = lazy_loading_keymaps,
    config = function()
      require('neorg').setup {
        load = module_list,
      }
    end,
  },
}
