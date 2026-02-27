require("options")
require("keymaps")
require("autocmds")

-- Diagnostic
vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        prefix = "●",
    },
    severity_sort = true,
    underline = false,
    signs = {
        text = {
            -- Alas nerdfont icons don't render properly on Medium!
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        },
    },
    update_in_insert = false,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
    },
})

local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic message" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Previous Diagnostic message" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local open_float_diagnostic = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
            return
        end
    end
    vim.diagnostic.open_float({
        scope = "line",
        focusable = false,
        close_events = {
            "CursorMoved",
            "CursorMovedI",
            "BufHidden",
            "InsertCharPre",
            "WinLeave",
        },
    })
end

-- Pre-configure colorscheme variables (applied before lazy loads gruvbox-material)
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 0
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_float_style = "dim"
vim.g.gruvbox_material_colors_override = {
    bg0 = { "#282828", "235" },
    bg3 = { "#484545", "237" },
    bg_dim = { "#282828", "235" },
}
-- Add to rtp so lazy's install.colorscheme can find it
local gruvbox_path = vim.fn.stdpath("data") .. "/lazy/gruvbox-material"
if vim.uv.fs_stat(gruvbox_path) then
    vim.opt.rtp:prepend(gruvbox_path)
end

-- Restore dashboard/Oil after Lazy install window is closed
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local has_lazy_win = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local b = vim.api.nvim_win_get_buf(win)
            if vim.bo[b].filetype == "lazy" then
                has_lazy_win = true
                break
            end
        end
        if not has_lazy_win then
            return
        end
        vim.api.nvim_create_autocmd("WinClosed", {
            callback = function()
                vim.schedule(function()
                    local has_lazy = false
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local b = vim.api.nvim_win_get_buf(win)
                        if vim.bo[b].filetype == "lazy" then
                            has_lazy = true
                            break
                        end
                    end
                    if has_lazy then
                        return
                    end
                    local cur = vim.api.nvim_get_current_buf()
                    local lines = vim.api.nvim_buf_get_lines(cur, 0, -1, false)
                    local is_empty = #lines <= 1 and (lines[1] or "") == ""
                    if not is_empty then
                        return
                    end
                    for i = 2, #vim.v.argv do
                        local arg = vim.v.argv[i]
                        if not arg:match("^%-") and vim.fn.isdirectory(arg) == 1 then
                            require("oil").open(arg)
                            return
                        end
                    end
                    Snacks.dashboard()
                end)
                return true
            end,
        })
    end,
})

-- NOTE: Here is where you install your plugins.
require("lazy").setup({
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    "tpope/vim-sleuth",
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("which-key").setup({
                win = {
                    border = { "─", "─", "─", " ", " ", " ", " ", " " },
                },
            })

            -- Document existing key chains
            require("which-key").add({
                { "<leader>s", group = "[s]Search" },
                { "<leader>d", group = "[d]Debug" },
                { "<leader>t", group = "[t]Test" },
                { "<leader>c", group = "[c]Code" },
                { "<leader>g", group = "[g]Git" },
                { "<leader>o", group = "[o]Options" },
            })
            -- Main
            vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "[q]Close Buffer" })
            vim.keymap.set("n", "<leader>p", function()
                Snacks.picker.projects({
                    confirm = function(picker, item)
                        picker:close()
                        if item and item.file then
                            local project_dir = item.file
                            local ca = package.loaded["cursor-agent"]
                            if ca and ca._term_state then
                                local st = ca._term_state
                                if st.bufnr and vim.api.nvim_buf_is_valid(st.bufnr) then
                                    local ca_util = require("cursor-agent.util")
                                    local orig_notify = ca_util.notify
                                    ca_util.notify = function() end
                                    pcall(vim.api.nvim_buf_delete, st.bufnr, { force = true })
                                    vim.defer_fn(function()
                                        ca_util.notify = orig_notify
                                    end, 200)
                                end
                                st.win, st.bufnr, st.job_id = nil, nil, nil
                            end
                            Snacks.picker.files({
                                cwd = project_dir,
                                hidden = true,
                                ignored = false,
                                on_close = function()
                                    vim.schedule(function()
                                        vim.cmd.cd(project_dir)
                                    end)
                                end,
                            })
                        end
                    end,
                })
            end, { desc = "[p]Projects" })
            vim.keymap.set("n", "<leader>e", open_float_diagnostic, { desc = "[e]Line Diagnostic" })
            vim.keymap.set("n", "<leader>_", "<C-W>s", { desc = "[_]Horisontal split" })
            vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "[|]Vertical split" })

            vim.keymap.set("n", "<leader>cr", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true, desc = "[r]Code Rename" })

            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[a]Code Action" })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                float = {
                    border = "rounded",
                },
            },
        },
        dependencies = {
            {
                "williamboman/mason.nvim",
                config = true,
                opts = {
                    ui = {
                        border = "rounded",
                        backdrop = 100,
                    },
                },
            }, -- NOTE: Must be loaded before dependants
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            {
                "j-hui/fidget.nvim",
                event = "VeryLazy",
                config = function()
                    require("fidget").setup({
                        notification = {
                            override_vim_notify = false,
                            window = {
                                winblend = 0,
                                relative = "editor",
                                avoid = { "Oil" },
                            },
                        },
                    })
                end,
            },
            { "folke/lazydev.nvim", ft = "lua", opts = {} },
        },
        config = function()
            local function is_pyright(ctx)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                return client and client.name == "pyright"
            end

            local default_publish = vim.lsp.handlers["textDocument/publishDiagnostics"]
            vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
                if is_pyright(ctx) then
                    return
                end
                default_publish(err, result, ctx, config)
            end

            local default_pull = vim.lsp.handlers["textDocument/diagnostic"]
            vim.lsp.handlers["textDocument/diagnostic"] = function(err, result, ctx, config)
                if is_pyright(ctx) then
                    return
                end
                if default_pull then
                    default_pull(err, result, ctx, config)
                end
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
                    end
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("<space>cf", function()
                        vim.lsp.buf.format({ async = true })
                    end, "[f]Format")
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
            capabilities.workspace = capabilities.workspace or {}
            capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }

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
                svelte = {},
                ts_ls = {},
                pyright = {
                    on_init = function(client)
                        client.server_capabilities.diagnosticProvider = nil
                    end,
                    settings = {
                        pyright = {
                            disableOrganizeImports = true,
                            disableTaggedHints = true,
                        },
                        python = {
                            analysis = {
                                autoImportCompletions = true,
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "off",
                                typeCheckingMode = "off",
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
                                    "F821",
                                },
                            },
                        },
                    },
                },
                -- marksman = {},
                templ = {
                    filetypes = { "templ" },
                },
                tailwindcss = {
                    settings = {
                        tailwindCSS = {
                            classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
                            includeLanguages = {
                                eelixir = "html-eex",
                                eruby = "erb",
                                htmlangular = "html",
                                templ = "html",
                            },
                            lint = {
                                cssConflict = "warning",
                                invalidApply = "error",
                                invalidConfigPath = "error",
                                invalidScreen = "error",
                                invalidTailwindDirective = "error",
                                invalidVariant = "error",
                                recommendedVariantOrder = "warning",
                            },
                            validate = true,
                        },
                    },
                },
                cssls = {
                    settings = {
                        css = {
                            validate = true,
                            lint = {
                                unknownAtRules = "ignore",
                            },
                        },
                    },
                },
                sqls = {},
                htmx = {},
                html = {
                    filetypes = { "html" },
                },
                jsonls = {},
                yamlls = {},
                lua_ls = {},
                taplo = {},
            }
            require("lspconfig.ui.windows").default_options.border = "rounded"

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "black",
                "reorder-python-imports",
                "bandit",
                "mypy",
                "taplo",
                "goimports",
                "shfmt",
                "prettier",
                "jq",
                "jsonlint",
                "yamlfmt",
                "vale",
                "tflint",
                "cssls",
                "tailwindcss",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
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
                lua = { "stylua" },
                svelte = { "prettier" },
                typescript = { "prettier" },
                javascript = { "prettier" },
                python = { "black", "reorder-python-imports" },
                go = { "goimports", "gofmt" },
                json = { "prettier" },
                -- markdown = { "prettier" },
                sh = { "shfmt" },
                yaml = { "yamlfmt" },
            },
            formatters = {
                black = {
                    prepend_args = { "--line-length", "119" },
                },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                -- markdown = { "markdownlint", "vale" },
                python = { "mypy", "bandit" },
                -- python = { "mypy" },
                json = { "jsonlint" },
                rst = { "vale" },
                terraform = { "tflint" },
                text = { "vale" },
            }

            lint.linters.mypy.args = {
                "--install-types",
                "--non-interactive",
                "--ignore-missing-imports",
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        config = function()
            require("todo-comments").setup({ signs = false })
            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
                -- require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})
            end, { desc = "Next todo comment" })

            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })
        end,

        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "gsa", -- Add surrounding in Normal and Visual modes
                    delete = "gsd", -- Delete surrounding
                    find = "gsf", -- Find surrounding (to the right)
                    find_left = "gsF", -- Find surrounding (to the left)
                    highlight = "gsh", -- Highlight surrounding
                    replace = "gsr", -- Replace surrounding
                    update_n_lines = "gsn", -- Update `n_lines`
                    suffix_last = "", -- Suffix to search with "prev" method
                    suffix_next = "", -- Suffix to search with "next" method
                },
            })
            vim.g.minitrailspace_disable = true
            require("mini.trailspace").setup()
            vim.api.nvim_create_autocmd("User", {
                pattern = "SnacksDashboardOpened",
                once = true,
                callback = function()
                    vim.g.minitrailspace_disable = false
                    MiniTrailspace.unhighlight()
                end,
            })
            vim.api.nvim_create_autocmd("BufReadPost", {
                once = true,
                callback = function()
                    vim.g.minitrailspace_disable = false
                    MiniTrailspace.highlight()
                end,
            })
            require("mini.move").setup({
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                    left = "<M-h>",
                    right = "<M-l>",
                    down = "<M-j>",
                    up = "<M-k>",

                    -- Move current line in Normal mode
                    line_left = "<M-h>",
                    line_right = "<M-l>",
                    line_down = "<M-j>",
                    line_up = "<M-k>",
                },

                -- Options which control moving behavior
                options = {
                    -- Automatically reindent selection during linewise vertical move
                    reindent_linewise = false,
                },
            })
            -- mini.starter replaced by Snacks.dashboard
            -- INFO: Miscellaneous useful functions
            local minimisc = require("mini.misc")
            minimisc.setup()
            minimisc.setup_termbg_sync()
            minimisc.setup_restore_cursor()
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    {
        "letieu/harpoon-lualine",
        dependencies = {
            {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "archibate/lualine-time" },
        config = function()
            local function count_items(qf_list)
                if #qf_list > 0 then
                    local valid = 0
                    for _, item in ipairs(qf_list) do
                        if item.valid == 1 then
                            valid = valid + 1
                        end
                    end
                    if valid > 0 then
                        return tostring(valid)
                    end
                end
            end
            -- local custom_gruvbox = require("lualine.themes.gruvbox-material")
            local custom_gruvbox = require("lualine.themes.gruvbox")
            custom_gruvbox.normal.b.bg = "#32302F"
            custom_gruvbox.normal.c.bg = "#282828"
            custom_gruvbox.insert.b.bg = "#32302F"
            custom_gruvbox.insert.c.bg = "#282828"
            custom_gruvbox.visual.b.bg = "#32302F"
            custom_gruvbox.visual.c.bg = "#282828"
            custom_gruvbox.command.b.bg = "#32302F"
            custom_gruvbox.command.c.bg = "#282828"
            custom_gruvbox.inactive.b.bg = "#32302F"
            custom_gruvbox.inactive.c.bg = "#282828"

            require("lualine").setup({
                options = {
                    theme = custom_gruvbox,
                    -- section_separators = '',
                    component_separators = "",
                },
                extensions = { "oil", "trouble" },
                sections = {
                    lualine_c = {
                        {
                            "filename",
                            file_status = true, -- Displays file status (readonly status, modified status)
                            newfile_status = false, -- Display new file status (new file means no write after created)
                            path = 4, -- 0: Just the filename
                            -- 1: Relative path
                            -- 2: Absolute path
                            -- 3: Absolute path, with tilde as the home directory
                            -- 4: Filename and parent dir, with tilde as the home directory
                            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                            -- for other components. (terrible name, any suggestions?)
                            symbols = {
                                modified = "[+]", -- Text to show when the file is modified.
                                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                                newfile = "[New]", -- Text to show for newly created file before first write
                            },
                        },
                        { "selectioncount" },
                        {
                            function()
                                local loc_values = vim.fn.getloclist(vim.api.nvim_get_current_win())
                                local items = count_items(loc_values)
                                if items then
                                    return "Loc: " .. items
                                end
                                return ""
                            end,
                            on_click = function(clicks, button, modifiers)
                                local winid = vim.fn.getqflist(vim.api.nvim_get_current_win()).winid
                                if winid == 0 then
                                    vim.cmd.lopen()
                                else
                                    vim.cmd.lclose()
                                end
                            end,
                        },
                        {
                            function()
                                local qf_values = vim.fn.getqflist()
                                local items = count_items(qf_values)
                                if items then
                                    return "Qf: " .. items
                                end
                                return ""
                            end,
                            on_click = function(clicks, button, modifiers)
                                local winid = vim.fn.getqflist({ winid = 0 }).winid
                                if winid == 0 then
                                    vim.cmd.copen()
                                else
                                    vim.cmd.cclose()
                                end
                            end,
                        },
                        "%=", -- make the indicator center
                        {
                            "harpoon2",
                            icon = "󰛢 ",
                            color_active = { fg = "#B0B846" },
                            separator = " ",
                            no_harpoon = "Harpoon not loaded",
                        },
                    },
                    lualine_y = {
                        {
                            "datetime",
                            -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
                            style = "%a %e %b, %H:%M",
                        },
                    },
                    lualine_z = {
                        { "location" },
                        { "searchcount" },
                    },
                },
            })
        end,
    },
    { import = "plugins" },
}, {
    install = {
        colorscheme = { "gruvbox-material" },
    },
    change_detection = {
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    defaults = {
        version = false,
        lazy = false,
    },
    ui = {
        border = "rounded",
        backdrop = 100,
        size = {
            width = 0.8,
            height = 0.8,
        },
        icons = vim.g.have_nerd_font and {} or {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})

-- vim: ts=2 sts=2 sw=2
