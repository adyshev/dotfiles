return {
    "akinsho/bufferline.nvim",
    version = "*",
    enabled = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup({
            highlights = {
                fill = {
                    fg = "#282828",
                    bg = "#282828",
                },
                modified = {
                    fg = "#928374",
                    bg = "#282828",
                },
                modified_visible = {
                    fg = "#928374",
                    bg = "#282828",
                },
                modified_selected = {
                    fg = "#D4BE98",
                    bg = "#32302E",
                },
                separator_selected = {
                    fg = "#32302E",
                    bg = "#32302E",
                },
                separator_visible = {
                    fg = "#282828",
                    bg = "#282828",
                },
                separator = {
                    fg = "#282828",
                    bg = "#282828",
                },
                background = {
                    fg = "#928374",
                    bg = "#282828",
                },
                buffer_visible = {
                    fg = "#928374",
                    bg = "#282828",
                },
                buffer_selected = {
                    fg = "#D7D7AF",
                    bg = "#32302E",
                    bold = false,
                    italic = false,
                },
                close_button = {
                    fg = "#928374",
                    bg = "#282828",
                },
                close_button_visible = {
                    fg = "#928374",
                    bg = "#282828",
                },
                close_button_selected = {
                    fg = "#D4BE98",
                    bg = "#32302E",
                },
            },
            options = {
                always_show_bufferline = false,
                show_buffer_close_icons = false,
                show_duplicate_prefix = false,
                show_close_icon = false,
                separator_style = "slant",
                style_preset = bufferline.style_preset.minimal,
            },
        })
    end,
}
