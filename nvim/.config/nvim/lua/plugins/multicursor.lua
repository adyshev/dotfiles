return {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
        vim.cmd([[
            let g:VM_default_mappings = 0
            let g:VM_maps = {}
            let g:VM_theme = 'paper'
        ]])
    end,
    config = function()
        -- Ensure v:hlsearch=1 before VM starts to prevent enable_hls() timer
        -- from injecting feedkeys that corrupt the first 'n' press after restart.
        vim.keymap.set("n", "<C-n>", function()
            vim.v.hlsearch = 1
            local key = vim.api.nvim_replace_termcodes("<Plug>(VM-Find-Under)", true, false, true)
            vim.api.nvim_feedkeys(key, "m", false)
        end, { noremap = false, silent = true, desc = "VM Find Under" })
    end,
}
