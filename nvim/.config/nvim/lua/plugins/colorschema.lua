return {
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
                    local bg3 = p.bg3[1]
                    local green = p.green[1]
                    local blue = p.blue[1]
                    local purple = p.purple[1]
                    local red = p.red[1]

                    local hl = vim.api.nvim_set_hl

                    -- Snacks picker windows
                    hl(0, "SnacksPicker", { bg = bg0, fg = fg0, italic = false })
                    hl(0, "SnacksPickerBorder", { fg = grey1, bg = bg0 })
                    hl(0, "SnacksPickerTitle", { fg = yellow, bg = bg0, bold = true })
                    hl(0, "SnacksPickerFooter", { fg = grey1, bg = bg0 })

                    -- List
                    hl(0, "SnacksPickerList", { bg = bg0, fg = fg0, italic = false })
                    hl(0, "SnacksPickerListBorder", { fg = grey1, bg = bg0 })
                    hl(0, "SnacksPickerListCursorLine", { bg = bg1 })

                    -- Input
                    hl(0, "SnacksPickerInput", { bg = bg0, fg = fg0 })
                    hl(0, "SnacksPickerInputBorder", { fg = grey1, bg = bg0 })
                    hl(0, "SnacksPickerInputSearch", { fg = orange })

                    -- Preview
                    hl(0, "SnacksPickerPreview", { bg = bg0, fg = fg0 })
                    hl(0, "SnacksPickerPreviewBorder", { fg = grey1, bg = bg0 })

                    -- Content highlights
                    hl(0, "SnacksPickerMatch", { fg = orange, bold = true, italic = false })
                    hl(0, "SnacksPickerPrompt", { fg = orange })
                    hl(0, "SnacksPickerSpecial", { fg = yellow, italic = false })
                    hl(0, "SnacksPickerLabel", { fg = yellow, italic = false })
                    hl(0, "SnacksPickerSpinner", { fg = yellow })
                    hl(0, "SnacksPickerIcon", { fg = aqua })
                    hl(0, "SnacksPickerSelected", { fg = orange })
                    hl(0, "SnacksPickerToggle", { fg = aqua, bg = bg1 })
                    hl(0, "SnacksPickerTotals", { fg = grey1 })
                    hl(0, "SnacksPickerDir", { fg = grey1, italic = false })
                    hl(0, "SnacksPickerFile", { fg = fg0, italic = false })
                    hl(0, "SnacksPickerComment", { fg = grey1, italic = false })
                    hl(0, "SnacksPickerIdx", { fg = grey1, italic = false })
                    hl(0, "SnacksPickerRow", { fg = fg0, italic = false })

                    -- Notifier
                    hl(0, "SnacksNotifierHistory", { bg = bg0, fg = fg0 })

                    -- Noice cmdline
                    hl(0, "NoiceCmdlineIcon", { fg = orange })

                    -- Yank highlight
                    hl(0, "YankyYanked", { bg = green, fg = bg0 })
                    hl(0, "YankyPut", { bg = red, fg = bg0 })

                    -- Substitute highlight
                    hl(0, "SubstituteSubstituted", { bg = orange, fg = bg0 })
                    hl(0, "SubstituteRange", { bg = orange, fg = bg0 })
                    hl(0, "SubstituteExchange", { bg = orange, fg = bg0 })

                    -- WhichKey
                    local whichkey_bg = bg0
                    hl(0, "WhichKeyNormal", { bg = whichkey_bg })
                    hl(0, "WhichKeyBorder", { bg = whichkey_bg, fg = grey1 })
                    hl(0, "WhichKeyTitle", { bg = whichkey_bg, fg = yellow, bold = true })
                    hl(0, "WhichKeyDesc", { fg = fg0 })
                    hl(0, "WhichKeyGroup", { fg = aqua })
                    hl(0, "WhichKeySeparator", { fg = grey1 })
                    hl(0, "WhichKeyValue", { fg = grey1 })

                    hl(0, "BlinkCmpMenu", { bg = bg0, fg = fg0 })
                    hl(0, "BlinkCmpMenuBorder", { bg = bg0, fg = grey1 })
                    hl(0, "BlinkCmpMenuSelection", { bg = bg3 })
                    hl(0, "BlinkCmpLabel", { fg = fg0 })
                    hl(0, "BlinkCmpLabelMatch", { fg = orange, bold = true })
                    hl(0, "BlinkCmpLabelDeprecated", { fg = grey1, strikethrough = true })
                    hl(0, "BlinkCmpKind", { fg = aqua })
                    hl(0, "BlinkCmpKindFunction", { fg = green })
                    hl(0, "BlinkCmpKindMethod", { fg = green })
                    hl(0, "BlinkCmpKindVariable", { fg = blue })
                    hl(0, "BlinkCmpKindField", { fg = blue })
                    hl(0, "BlinkCmpKindProperty", { fg = blue })
                    hl(0, "BlinkCmpKindClass", { fg = yellow })
                    hl(0, "BlinkCmpKindStruct", { fg = yellow })
                    hl(0, "BlinkCmpKindInterface", { fg = yellow })
                    hl(0, "BlinkCmpKindModule", { fg = yellow })
                    hl(0, "BlinkCmpKindKeyword", { fg = red })
                    hl(0, "BlinkCmpKindSnippet", { fg = purple })
                    hl(0, "BlinkCmpKindText", { fg = aqua })
                    hl(0, "BlinkCmpKindConstant", { fg = orange })
                    hl(0, "BlinkCmpKindEnum", { fg = yellow })
                    hl(0, "BlinkCmpKindEnumMember", { fg = aqua })
                    hl(0, "BlinkCmpKindValue", { fg = orange })
                    hl(0, "BlinkCmpSource", { fg = grey1 })
                    hl(0, "BlinkCmpDoc", { bg = bg0, fg = fg0 })
                    hl(0, "BlinkCmpDocBorder", { bg = bg0, fg = grey1 })
                    hl(0, "BlinkCmpDocCursorLine", { bg = bg1 })
                    hl(0, "BlinkCmpSignatureHelp", { bg = bg0, fg = fg0 })
                    hl(0, "BlinkCmpSignatureHelpBorder", { bg = bg0, fg = grey1 })
                end,
            })

            vim.cmd.colorscheme("gruvbox-material")
        end,
    },
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            vim.opt.termguicolors = true
            require("colorizer").setup({
                user_default_options = {
                    names = false,
                },
            })
        end,
    },
}
