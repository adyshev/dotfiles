require 'options'
require 'keymaps'
require 'autocmds'

-- Diagnostic
vim.diagnostic.config {
  virtual_text = false,
  severity_sort = true,
  underline = true,
  signs = true,
  float = {
    border = 'rounded',
  },
}

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic message' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Previous Diagnostic message' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- Lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth',
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>f', group = '[f]Find' },
        -- { '<leader>d', group = '[d]Debug' },
        -- { '<leader>t', group = '[t]Test' },
        { '<leader>c', group = '[c]Code' },
        -- { '<leader>s', group = '[s]Sessions' },
        -- { '<leader>n', group = '[n]Notes' },
        -- { '<leader>o', group = '[o]Options' },
      }
      -- Main
      vim.keymap.set('n', '<leader>q', '<cmd>bd<CR>', { desc = '[q]Close Buffer' })
      vim.keymap.set(
        'n',
        '<leader>e',
        ":lua vim.diagnostic.open_float(nil, {focusable=false, scope='line', close_events = { 'CursorMoved', 'CursorMovedI', 'BufHidden', 'InsertCharPre', 'WinLeave'}})<CR>",
        { desc = '[e]Line Diagnostic' }
      )
      vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = '[-]Horisontal split' })
      vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = '[|]Vertical split' })

      -- -- Code
      -- vim.keymap.set('n', '<leader>cr', function()
      --   return ':IncRename ' .. vim.fn.expand '<cword>'
      -- end, { expr = true, desc = '[r]Rename' })
      -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[c]Code Action' })

      -- Options
      -- vim.keymap.set('n', '<leader>oc', '<cmd>lua require("cmp").setup { enabled = true }<cr>', { desc = '[c]Enable completion' })
      -- vim.keymap.set('n', '<leader>oC', '<cmd>lua require("cmp").setup { enabled = false }<cr>', { desc = '[C]Disable completion' })
      -- vim.keymap.set('n', '<leader>oX', '<cmd>lua vim.diagnostic.enable(false)<cr>', { desc = '[X]Disable diagnostic messages' })
      -- vim.keymap.set('n', '<leader>ox', '<cmd>lua vim.diagnostic.enable(true)<cr>', { desc = '[x]Enable diagnostic messages' })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'smartpde/telescope-recent-files' },
      {
        'nvim-telescope/telescope-symbols.nvim',
        config = function()
          vim.keymap.set('n', '<leader>fy', '<cmd>Telescope symbols<cr>', { desc = '[y]Find Symbols' })
        end,
      },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--hidden', '-g', '!{**/.git/*,**/node_modules/*,**/venv/*}' },
          },
          grep_string = {
            additional_args = { '--hidden', '-g', '!{**/.git/*,**/node_modules/*,**/venv/*}' },
          },
          live_grep = {
            additional_args = { '--hidden', '-g', '!{**/.git/*,**/node_modules/*,**/venv/*}' },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          recent_files = {
            only_cwd = true,
          },
          -- file_browser = {
          --   hidden = { file_browser = true, folder_browser = true },
          -- },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      -- pcall(require('telescope').load_extension, 'file-browser')
      pcall(require('telescope').load_extension, 'recent_files')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>f?', builtin.help_tags, { desc = '[?]Find Help' })
      vim.keymap.set('n', '<leader>fh', ':Telescope command_history<CR>', { desc = '[h]Find Command History' })
      vim.keymap.set('n', '<leader>fs', ':Telescope search_history<CR>', { desc = '[s]Find Search History' })
      vim.keymap.set('n', '<leader>ft', ':TodoTelescope<CR>', { desc = '[t]Find TODO' })
      vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = '[d] Find Diagnostics' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[k]Find Keymaps' })
      -- vim.keymap.set('n', '<leader>fn', ':Telescope live_grep search_dirs={"~/neorg/"}<CR>', { desc = '[n]Find Notes' })
      -- vim.keymap.set('n', '<leader>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = '[b]File Browser' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]Find Files' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[w]Find current Word' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[g]Find by Grep' })
      vim.keymap.set('n', '<leader><leader>', [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]], { desc = '[ ]Find Recent files' })
      vim.keymap.set('n', '<leader>fo', builtin.buffers, { desc = '[o]Find open buffers' })

      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[/]Find in Open Files' })

      vim.keymap.set('n', '<leader>fc', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[c]Find Neovim config files' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- GoTo operator
          map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
          map('gT', require('telescope.builtin').lsp_type_definitions, 'Goto Type Definition')
          map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
          map('gR', require('telescope.builtin').lsp_references, 'Goto Reference')
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
          map('<space>cr', vim.lsp.buf.rename, '[r]Rename')
          map('<space>cf', function()
            vim.lsp.buf.format { async = true }
          end, '[f]Format')

          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end, '[h]Toggle Inlay Hints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
        pyright = {
          capabilities = {
            textDocument = {
              publishDiagnostics = {
                tagSupport = {
                  valueSet = { 2 },
                },
              },
            },
          },
          settings = {
            pyright = {
              disableOrganizeImports = true,
              disableTaggedHints = true,
            },
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
                -- diagnosticSeverityOverrides = {
                -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
                -- reportUndefinedVariable = 'none',
                -- reportAttributeAccessIssue = 'none',
                -- },
                ignore = { '*' }, -- Using Ruff
                typeCheckingMode = 'off', -- Using mypy
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              lineLength = 119,
              lint = {
                ignore = {
                  'F821',
                },
              },
            },
          },
        },
        marksman = {},
        templ = {
          filetypes = { 'templ' },
        },
        cssls = {},
        sqls = {},
        htmx = {},
        html = {
          filetypes = { 'html' },
        },
        jsonls = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
            },
          },
        },
      }
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      require('mason').setup {
        ui = {
          border = 'rounded',
          width = 0.8,
          height = 0.8,
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'black',
        'mypy',
        'isort',
        'goimports',
        'shfmt',
        'prettier',
        'jq',
        'jsonlint',
        'yamlfmt',
        'vale',
        'tflint',
        'markdownlint',
        'markdown-toc',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 5000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          async = false,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        go = { 'goimports', 'gofmt' },
        json = { 'prettier' },
        markdown = { 'prettier' },
        sh = { 'shfmt' },
        yaml = { 'yamlfmt' },
      },
      formatters = {
        black = {
          prepend_args = { '--line-length', '119' },
        },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        python = { 'mypy' },
        json = { 'jsonlint' },
        rst = { 'vale' },
        terraform = { 'tflint' },
        text = { 'vale' },
      }

      lint.linters.mypy.args = {
        '--install-types',
        '--non-interactive',
        '--ignore-missing-imports',
      }
      --
      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      --
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      -- lint.linters_by_ft['python'] = { 'mypy', 'flake8' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['clojure'] = nil

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    lazy = false,
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        opts = {
          history = true,
          region_check_events = 'InsertEnter',
          delete_check_events = 'TextChanged,InsertLeave',
        },
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      'f3fora/cmp-spell',
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-under-comparator',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local kind_icons = {
        Text = '',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰇽',
        Variable = '󰂡',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '󰅲',
      }

      luasnip.config.setup {}
      vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = '#7DAEA3' })
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None',
          },
          documentation = cmp.config.window.bordered {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None',
          },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            require('cmp-under-comparator').under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
            vim_item.menu = ({
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              luasnip = '[LuaSnip]',
              nvim_lua = '[Lua]',
              path = '[Path]',
              emoji = '[Emoji]',
              -- neorg = '[Neorg]',
              spell = '[Spell]',
              latex_symbols = '[LaTeX]',
            })[entry.source.name]
            return vim_item
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert,noselect' },
        mapping = cmp.mapping.preset.insert {
          -- Disable navigation using arrows within autocomplete windows
          ['<Down>'] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { 'i' }),
          ['<Up>'] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { 'i' }),

          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { select = false },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
      }

      cmp.setup.filetype('norg', {
        sources = {
          -- { name = 'neorg' },
          { name = 'luasnip' },
          {
            name = 'spell',
            option = {
              keyword_length = 4,
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
              preselect_correct_word = false,
            },
          },
          { name = 'emoji' },
        },
      })

      cmp.setup.filetype('lua', {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'emoji' },
        },
      })

      cmp.setup.filetype({ 'markdown', 'text' }, {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          {
            name = 'spell',
            option = {
              keyword_length = 4,
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
              preselect_correct_word = false,
            },
          },
          { name = 'emoji' },
        },
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'nvim_lsp_document_symbol' },
          { name = 'buffer' },
        },
        view = {
          entries = { name = 'wildmenu', separator = ' ⇨ ' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup { signs = false }
      vim.keymap.set('n', ']t', function()
        require('todo-comments').jump_next()
        -- require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})
      end, { desc = 'Next todo comment' })

      vim.keymap.set('n', '[t', function()
        require('todo-comments').jump_prev()
      end, { desc = 'Previous todo comment' })
    end,

    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      -- require('mini.surround').setup()
      require('mini.operators').setup()
      require('mini.trailspace').setup()
      require('mini.move').setup()
      require('mini.indentscope').setup {
        symbol = '│',
        options = {
          try_as_border = true,
        },
        draw = {
          animation = require('mini.indentscope').gen_animation.none(),
        },
      }
      -- INFO: Mini-starter page configuration
      local starter = require 'mini.starter'
      local my_items = {
        starter.sections.builtin_actions(),
        starter.sections.telescope(),
        -- { name = 'Find In Notes', action = ':Telescope live_grep search_dirs={"~/neorg/"}', section = 'Telescope' },
        starter.sections.recent_files(10, false),
      }
      starter.setup {
        evaluate_single = true,
        header = [[
______________________________
< MAY THE FORCE BE WITH YOU! >
------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
        ]],
        items = my_items,
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing('all', { 'Builtin actions', 'Telescope' }),
          starter.gen_hook.padding(5, 2),
          starter.gen_hook.aligning('center', 'center'),
        },
      }
      -- INFO: Miscellaneous useful functions
      local minimisc = require 'mini.misc'
      minimisc.setup()
      minimisc.setup_auto_root()
      minimisc.setup_termbg_sync()
      minimisc.setup_restore_cursor()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'python',
        'go',
        'diff',
        'html',
        'regex',
        'templ',
        'json',
        'yaml',
        'css',
        'lua',
        'luadoc',
        'markdown',
        'vim',
        'vimdoc',
        'query',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      matchup = {
        enable = true,
        -- disable_virtual_text = true,
      },
      indent = { enable = true, disable = { 'ruby' } },
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = '<c-space>',
      --     node_incremental = '<c-space>',
      --     scope_incremental = '<c-s>',
      --     node_decremental = '<c-backspace>',
      --   },
      -- },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ii'] = '@conditional.inner',
            ['ai'] = '@conditional.outer',
            ['il'] = '@loop.inner',
            ['al'] = '@loop.outer',
            ['at'] = '@comment.outer',
          },
          include_surrounding_whitespace = false,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']f'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  -- { 'JoosepAlviste/nvim-ts-context-commentstring' },
  {
    'nmac427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {}
    end,
  },
  {
    'andymass/vim-matchup',
    setup = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'letieu/harpoon-lualine',
    dependencies = {
      {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'archibate/lualine-time' },
    config = function()
      local custom_gruvbox = require 'lualine.themes.gruvbox-material'
      -- custom_gruvbox.normal.a.bg = '#32302F'
      custom_gruvbox.normal.b.bg = '#32302F'
      custom_gruvbox.normal.c.bg = '#282828'
      -- custom_gruvbox.insert.b.bg = '#32302F'
      -- custom_gruvbox.insert.c.bg = '#282828'
      -- custom_gruvbox.visual.b.bg = '#32302F'
      -- custom_gruvbox.visual.c.bg = '#282828'
      custom_gruvbox.replace.b.bg = '#32302F'
      custom_gruvbox.replace.c.bg = '#282828'
      custom_gruvbox.command.b.bg = '#32302F'
      custom_gruvbox.command.c.bg = '#282828'
      custom_gruvbox.inactive.b.bg = '#32302F'
      custom_gruvbox.inactive.c.bg = '#282828'

      require('lualine').setup {
        options = {
          theme = custom_gruvbox,
          -- section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_y = {
            {
              'datetime',
              -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
              style = '%a %e %b, %H:%M',
            },
          },
          lualine_c = {
            '%=', -- make the indicator center
            {
              'harpoon2',
              icon = '󰛢 ',
              color_active = { fg = '#B0B846' },
              separator = ' ',
              no_harpoon = 'Harpoon not loaded',
            },
          },
        },
      }
    end,
  },
  { import = 'plugins' },
}, {
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  defaults = {
    version = false,
    lazy = false,
  },
  ui = {
    border = 'rounded',
    size = {
      width = 0.8,
      height = 0.8,
    },
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- vim: ts=2 sts=2 sw=2
