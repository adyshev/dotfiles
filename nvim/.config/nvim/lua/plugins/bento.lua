return {
    "serhez/bento.nvim",
    enabled = true,
    opts = {
        ui = {
            floating = {
                position = "top-right", -- See position options below
                offset_x = 0, -- Horizontal offset from position
                offset_y = 1, -- Vertical offset from position
                dash_char = "─", -- Character for collapsed dashes
                label_padding = 1, -- Padding around labels
                minimal_menu = nil, -- nil | "dashed" | "filename" | "full"
                max_rendered_buffers = nil, -- nil (no limit) or number for pagination
            },
        },
    },
}
