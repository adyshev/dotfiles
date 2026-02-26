return {
    -- {
    --   'navarasu/onedark.nvim',
    --   lazy = false,
    --   priority = 1000,
    --   config = function()
    --     require('onedark').setup {
    --       style = 'warm', -- or cool | dark | darker
    --     }
    --     require('onedark').load()
    --     vim.cmd.colorscheme 'onedark'
    --   end,
    -- },

    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_enable_bold = 0
            vim.g.gruvbox_material_diagnostic_virtual_text = "grey"
            vim.g.gruvbox_material_dim_inactive_windows = 0
            vim.g.gruvbox_material_transparent_background = 0
            vim.g.gruvbox_material_background = "medium"
            vim.g.gruvbox_material_foreground = "mix" -- 'material'`, `'mix'`, `'original
            vim.g.gruvbox_material_ui_contrast = "low" -- `'low'`, `'high'`
            vim.g.gruvbox_material_float_style = "dim"
            vim.g.gruvbox_material_show_eob = 0
            vim.g.gruvbox_material_diagnostic_line_highlight = 1
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_colors_override = {
                bg0 = { "#282828", "235" },
                bg3 = { "#484545", "237" },
                bg_dim = { "#282828", "235" },
            }

            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("custom_highlights_gruvboxmaterial", {}),
                pattern = "gruvbox-material",
                callback = function()
                    local cfg = vim.fn["gruvbox_material#get_configuration"]()
                    local p = vim.fn["gruvbox_material#get_palette"](cfg.background, cfg.foreground, cfg.colors_override)
                    local set_hl = vim.fn["gruvbox_material#highlight"]

                    set_hl("CursorLineNr", p.orange, p.none)

                    local bg0 = p.bg0[1]
                    local bg1 = p.bg1[1]
                    local fg0 = p.fg0[1]
                    local grey1 = p.grey1[1]
                    local orange = p.orange[1]
                    local yellow = p.yellow[1]
                    local aqua = p.aqua[1]

                    local hl = vim.api.nvim_set_hl

                    -- Snacks picker windows
                    hl(0, "SnacksPicker", { bg = bg0, fg = fg0 })
                    hl(0, "SnacksPickerBorder", { fg = grey1, bg = bg0 })
                    hl(0, "SnacksPickerTitle", { fg = yellow, bg = bg0, bold = true })
                    hl(0, "SnacksPickerFooter", { fg = grey1, bg = bg0 })

                    -- List
                    hl(0, "SnacksPickerList", { bg = bg0, fg = fg0 })
                    hl(0, "SnacksPickerListBorder", { fg = grey1, bg = bg0 })
                    hl(0, "SnacksPickerListCursorLine", { bg = bg1 })

                    -- Input
                    hl(0, "SnacksPickerInput", { bg = bg0, fg = fg0 })
                    hl(0, "SnacksPickerInputBorder", { fg = grey1, bg = bg0 })
                    hl(0, "SnacksPickerInputSearch", { fg = orange })

                    -- Preview
                    hl(0, "SnacksPickerPreview", { bg = bg0, fg = fg0 })
                    hl(0, "SnacksPickerPreviewBorder", { fg = grey1, bg = bg0 })

                    -- Content highlights (the green culprits)
                    hl(0, "SnacksPickerMatch", { fg = orange, bold = true })
                    hl(0, "SnacksPickerPrompt", { fg = orange })
                    hl(0, "SnacksPickerSpecial", { fg = yellow })
                    hl(0, "SnacksPickerLabel", { fg = yellow })
                    hl(0, "SnacksPickerSpinner", { fg = yellow })
                    hl(0, "SnacksPickerIcon", { fg = aqua })
                    hl(0, "SnacksPickerSelected", { fg = orange })
                    hl(0, "SnacksPickerToggle", { fg = aqua, bg = bg1 })
                    hl(0, "SnacksPickerTotals", { fg = grey1 })

                    -- Notifier
                    hl(0, "SnacksNotifierHistory", { bg = bg0, fg = fg0 })

                    -- WhichKey
                    hl(0, "WhichKeyNormal", { bg = bg1 })
                end,
            })

            vim.cmd.colorscheme("gruvbox-material")
        end,
    },
    -- {
    --   'f4z3r/gruvbox-material.nvim',
    --   name = 'gruvbox-material',
    --   priority = 1000,
    --   opts = {},
    --   config = function()
    --     local colors = require('gruvbox-material.colors').get(vim.o.background, 'medium')
    --
    --     require('gruvbox-material').setup {
    --       italics = true,
    --       background = {
    --         transparent = false, -- set the background to transparent
    --       },
    --       float = {
    --         force_background = false, -- force background on floats even when background.transparent is set
    --         background_color = '#282828', -- set color for float backgrounds. If nil, uses the default color set
    --       },
    --       comments = {
    --         italics = true,
    --       },
    --       contrast = 'medium',
    --       customize = function(g, o)
    --         if g == 'CursorLineNr' then
    --           o.link = nil -- wipe a potential link, which would take precedence over other
    --           -- attributes
    --           o.fg = colors.orange -- or use any color in "#rrggbb" hex format
    --         end
    --
    --         o.bold = false
    --         return o
    --       end,
    --     }
    --   end,
    -- },
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup({
                user_default_options = {
                    names = false,
                },
            })
        end,
    },

    -- {
    --   'norcalli/nvim-colorizer.lua',
    --   config = function()
    --     require('colorizer').setup()
    --   end,
    -- },
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- { 'wittyjudge/gruvbox-material.nvim' },
}
