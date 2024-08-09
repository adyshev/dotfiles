require 'options'
require 'keymaps'
require 'autocmds'

-- Diagnostic keymaps
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
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[e]Line Diagnostic' })

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- System plugins

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[c]Code' },
        { '<leader>c_', hidden = true },
        { '<leader>f', group = '[f]Find' },
        { '<leader>f_', hidden = true },
        { '<leader>m', group = '[m]Misc' },
        { '<leader>m_', hidden = true },
      }
      vim.keymap.set('n', '<leader>x', '<cmd>Trouble diagnostics toggle<cr>', { desc = '[x]Diagnostic' })
      vim.keymap.set('n', '<leader>q', '<cmd>bd<CR>', { desc = '[q]Close Buffer' })
      vim.keymap.set('n', '<leader>d', require('telescope.builtin').lsp_definitions, { desc = '[d]Definition' })
      vim.keymap.set('n', '<leader>r', require('telescope.builtin').lsp_references, { desc = '[r]Reference' })
      vim.keymap.set('n', '<leader>mc', '<cmd>lua require("cmp").setup { enabled = true }<cr>', { desc = '[c]Enable completion' })
      vim.keymap.set('n', '<leader>mC', '<cmd>lua require("cmp").setup { enabled = false }<cr>', { desc = '[C]Disable completion' })
      vim.keymap.set('n', '<leader>mX', '<cmd>lua vim.diagnostic.enable(false)<cr>', { desc = '[X]Disable diagnostic messages' })
      vim.keymap.set('n', '<leader>mx', '<cmd>lua vim.diagnostic.enable(true)<cr>', { desc = '[x]Enable diagnostic messages' })
      vim.keymap.set('n', '<leader>/', ':normal gcc<CR><DOWN>', { desc = '[/]Toggle comment line' })
      vim.keymap.set('v', '<leader>/', '<Esc>:normal gvgc<CR>', { desc = '[/]Toggle comment block' })
      vim.keymap.set('n', '<leader>t', [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]], { desc = '[t]Recent files' })
    end,
  },
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'smartpde/telescope-recent-files' },
      {
        'nvim-telescope/telescope-symbols.nvim',
        config = function()
          vim.keymap.set('n', '<leader>fs', '<cmd>Telescope symbols<cr>', { desc = '[s]Find Symbols' })
        end,
      },
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

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
          file_browser = {
            hidden = { file_browser = true, folder_browser = true },
            -- theme = 'ivy',
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file-browser')
      pcall(require('telescope').load_extension, 'recent_files')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>f?', builtin.help_tags, { desc = '[?]Find Help' })
      vim.keymap.set('n', '<leader>fh', ':Telescope command_history<CR>', { desc = '[h]Find Command History' })
      vim.keymap.set('n', '<leader>fs', ':Telescope search_history<CR>', { desc = '[s]Find Search History' })
      vim.keymap.set('n', '<leader>ft', ':TodoTelescope<CR>', { desc = '[t]Find TODO' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[k]Find Keymaps' })
      vim.keymap.set('n', '<leader>fn', ':Telescope live_grep search_dirs={"~/.notes/"}<CR>', { desc = '[n]Find Notes' })
      vim.keymap.set('n', '<leader>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = '[b]File Browser' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]Find Files' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[w]Find current Word' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[g]Find by Grep' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ]Find existing buffers' })

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
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gt', require('telescope.builtin').lsp_type_definitions, 'Goto Type Definition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>fl', require('telescope.builtin').lsp_document_symbols, '[l]Find literals')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>cr', vim.lsp.buf.rename, '[r]Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[a]Code Action')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
          map('gR', require('telescope.builtin').lsp_references, 'Goto Reference')
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

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

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>mh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end, '[h]Toggle Inlay Hints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        gopls = {},
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
        ruff_lsp = {
          init_options = {
            settings = {
              args = {
                -- '--ignore=F821',
                '--line-length=120',
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
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
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

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'black',
        'flake8',
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
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
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
    },
  },
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        python = { 'ruff', 'mypy', 'flake8' },
        json = { 'jsonlint' },
        rst = { 'vale' },
        terraform = { 'tflint' },
        text = { 'vale' },
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

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
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
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-calc',
      'f3fora/cmp-spell',
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-under-comparator',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local custom_menu_icon = {
        calc = '󰃬',
      }
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
            if entry.source.name == 'calc' then
              -- Get the custom icon for 'calc' source
              -- Replace the kind glyph with the custom icon
              vim_item.kind = custom_menu_icon.calc
            end
            vim_item.menu = ({
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              luasnip = '[LuaSnip]',
              nvim_lua = '[Lua]',
              path = '[Path]',
              emoji = '[Emoji]',
              calc = '[Calc]',
              spell = '[Spell]',
              latex_symbols = '[LaTeX]',
            })[entry.source.name]
            return vim_item
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert,noselect' },
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          ['<CR>'] = cmp.mapping.confirm { select = false },

          -- Select the [n]ext item
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        },

        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'calc' },
          { name = 'path' },
          { name = 'emoji' },
        },
      }

      cmp.setup.filetype('lua', {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'calc' },
          { name = 'path' },
          { name = 'emoji' },
        },
      })

      cmp.setup.filetype({ 'markdown', 'text' }, {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'luasnip' },
          { name = 'calc' },
          { name = 'path' },
          { name = 'emoji' },
          {
            name = 'spell',
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
              preselect_correct_word = false,
            },
          },
        },
      })

      -- `/` cmdline setup.
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

      -- `:` cmdline setup.
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
  -- Highlight todo, notes, etc in comments
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
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- require('mini.ai').setup()
      require('mini.indentscope').setup {
        symbol = '│',
        draw = {
          animation = require('mini.indentscope').gen_animation.none(),
        },
      }
      local starter = require 'mini.starter'
      local my_items = {
        starter.sections.builtin_actions(),
        { name = 'Notes List', action = ':SimpleNoteList', section = 'Misc' },
        starter.sections.telescope(),
        { name = 'Find In Notes', action = ':Telescope live_grep search_dirs={"~/.notes/"}', section = 'Telescope' },
        starter.sections.recent_files(10, false),
      }

      starter.setup {
        evaluate_single = true,
        header = [[
____________________________
< MAY THE FORCE BE WITH YOU! >
 ----------------------------
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
      -- require('mini.surround').setup()
      require('mini.trailspace').setup()
      require('mini.move').setup()
      require('mini.operators').setup()
      local minimisc = require 'mini.misc'
      minimisc.setup()
      -- NOTE: Detects and changes the filetree root automatically
      -- minimisc.setup_auto_root()
      minimisc.setup_restore_cursor()
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
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
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },

    config = function(_, opts)
      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   config = function()
  --     require('treesitter-context').setup { mode = 'cursor', max_lines = 8, separator = '─' }
  --     vim.cmd [[hi TreesitterContextSeparator guifg='#5A524C']]
  --     vim.keymap.set('n', '[c', function()
  --       require('treesitter-context').go_to_context(vim.v.count1)
  --     end, { silent = true, desc = 'Go to parent context' })
  --   end,
  -- },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
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
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'archibate/lualine-time' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'gruvbox-material',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'cdate', 'ctime' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
  {
    'b0o/incline.nvim',
    config = function()
      require('incline').setup {
        window = {
          placement = {
            vertical = 'bottom',
            horizontal = 'center',
          },
          padding = 0,
          margin = { vertical = 0, horizontal = 0 },
        },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = require('nvim-web-devicons').get_icon_color(filename)

          local function get_git_diff()
            local icons = { removed = ' ', changed = ' ', added = ' ' }
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. signs[name] .. ' ', group = 'Diff' .. name })
              end
            end
            if #labels > 0 then
              table.insert(labels, { '| ' })
            end
            return labels
          end

          local function get_diagnostic_label()
            local icons = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { '| ' })
            end
            return label
          end

          local function get_harpoon_items()
            local harpoon = require 'harpoon'
            local marks = harpoon:list().items
            local current_file_path = vim.fn.expand '%:p:.'
            local label = {}

            for id, item in ipairs(marks) do
              if item.value == current_file_path then
                table.insert(label, { id .. ' ', guifg = '#FFFFFF', gui = 'bold' })
              else
                table.insert(label, { id .. ' ', guifg = '#434852' })
              end
            end

            if #label > 0 then
              table.insert(label, 1, { '󰛢 ', guifg = '#61AfEf' })
              table.insert(label, { '| ' })
            end
            return label
          end

          local function get_file_name()
            local label = {}
            table.insert(label, { (ft_icon or '') .. ' ', guifg = ft_color, guibg = 'none' })
            table.insert(label, { vim.bo[props.buf].modified and ' ' or '', guifg = '#d19a66' })
            table.insert(label, { filename, gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' })
            if not props.focused then
              label['group'] = 'BufferInactive'
            end

            return label
          end

          return {
            { '', guifg = '#282828', guibg = '#282828' },
            {
              { get_diagnostic_label() },
              { get_git_diff() },
              { get_harpoon_items() },
              { get_file_name() },
              guibg = '#282828',
            },
            { '', guifg = '#282828', guibg = '#282828' },
          }
        end,
      }
    end,
    event = 'VeryLazy',
  },
  { import = 'plugins' },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'netrwPlugin',
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
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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
-- The line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2
