local neorg_dependencies = {
  'nvim-treesitter/nvim-treesitter',
  'hrsh7th/nvim-cmp',
  'nvim-neorg/neorg-telescope',
}

local lazy_loading_keymaps = {
  { '<leader>nt', '<cmd>Neorg journal today<cr>', desc = "[t]Today's Journal Page" },
  { '<leader>nw', '<cmd>Neorg workspace work<cr>', desc = '[w]Edit Work Notes' },
  { '<leader>np', '<cmd>Neorg workspace personal<cr>', desc = '[p]Edit Personal Notes' },
  { '<leader>ns', '<cmd>Neorg generate-workspace-summary<cr>', desc = '[s]Generate Workspace Summary' },
  { '<leader>ni', '<cmd>Neorg index<cr>', desc = '[i]Neorg index' },
  { '<leader>nf', '<cmd>Telescope neorg search_headings<CR>', desc = '[f]Find Headings' },
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
  ['core.concealer'] = {},
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
  ['core.keybinds'] = {},
  ['core.qol.toc'] = {},
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
    },
  },
  ['core.export'] = {},
  ['core.export.markdown'] = {
    config = {
      extensions = 'all',
    },
  },
  ['core.integrations.telescope'] = {},
  ['core.summary'] = {},
  ['core.ui.calendar'] = {},
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
