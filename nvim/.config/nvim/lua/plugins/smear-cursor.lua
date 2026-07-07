return {
    "sphamba/smear-cursor.nvim",
    -- enabled = false,
    opts = {
        -- The upstream "faster" preset is snappy, but it can look jumpy because
        -- it stops early and asks the terminal to redraw faster than the display
        -- can present frames. These values favor smoothness in Ghostty/tmux.
        time_interval = 7, -- ~120 FPS; avoid overscheduling redraws
        stiffness = 0.62,
        trailing_stiffness = 0.42,
        stiffness_insert_mode = 0.5,
        trailing_stiffness_insert_mode = 0.5,
        damping = 0.88,
        damping_insert_mode = 0.9,
        distance_stop_animating = 0.08,
        distance_stop_animating_vertical_bar = 0.12,
        max_length = 18,
    },
}
