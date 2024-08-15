local neorg_dependencies = {
  'nvim-treesitter/nvim-treesitter',
  'hrsh7th/nvim-cmp',
  'pysan3/neorg-templates',
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

local function imports()
  return require 'luasnip', require 'neorg.modules.external.templates.default_snippets'
end

local KEYWORDS = {
  TODAY_OF_FILE_ORG = function() -- detect date from filename and return in org date format
    local ls, m = imports()
    -- use m.file_name_date() if you use journal.strategy == "flat"
    return ls.text_node(m.parse_date(0, m.file_tree_date(), [[<%Y-%m-%d %a]])) -- <2006-11-01 Wed>
  end,
  TODAY_OF_FILE_NORG = function() -- detect date from filename and return in norg date format
    local ls, m = imports()
    -- use m.file_name_date() if you use journal.strategy == "flat"
    return ls.text_node(m.parse_date(0, m.file_tree_date(), [[%a, %d %b %Y]])) -- Wed, 1 Nov 2006
  end,
  TODAY_ORG = function() -- detect date from filename and return in org date format
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[<%Y-%m-%d %a %H:%M:%S>]])) -- <2006-11-01 Wed 19:15>
  end,
  TODAY_NORG = function() -- detect date from filename and return in norg date format
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[%a, %d %b %Y %H:%M:%S]])) -- Wed, 1 Nov 2006 19:15
  end,
  NOW_IN_DATETIME = function() -- print current date+time of invoke
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[%Y-%m-%d %a %X]])) -- 2023-11-01 Wed 23:48:10
  end,
  YESTERDAY_OF_FILEPATH = function() -- detect date from filename and return its file path to be used in a link
    local ls, m = imports()
    return ls.text_node(m.parse_date(-1, m.file_tree_date(), [[../../%Y/%m/%d]])) -- ../../2020/01/01
  end,
  TOMORROW_OF_FILEPATH = function() -- detect date from filename and return its file path to be used in a link
    local ls, m = imports()
    return ls.text_node(m.parse_date(1, m.file_tree_date(), [[../../%Y/%m/%d]])) -- ../../2020/01/01
  end,
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
  ['external.templates'] = {
    config = {
      keywords = KEYWORDS,
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
  'nvim-neorg/neorg',
  lazy = false,
  dependencies = neorg_dependencies,
  keys = lazy_loading_keymaps,
  config = function()
    require('neorg').setup {
      load = module_list,
    }
    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
}
