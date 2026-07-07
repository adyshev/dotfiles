local M = {}

-- Cross-platform clipboard integration for the `+` and `*` registers.
-- Neovim's default clipboard detection can be inconsistent inside tmux, SSH,
-- or minimal Linux installs, so this module explicitly chooses an available
-- provider and falls back to OSC52 when no local clipboard tool exists.

local function executable(bin)
    return vim.fn.executable(bin) == 1
end

-- Neovim expects clipboard providers to be functions keyed by register.
-- `copy_with` adapts an external command like pbcopy/wl-copy/xclip into that
-- provider shape, preserving linewise selections with a trailing newline.
local function copy_with(command)
    return function(lines, regtype)
        local text = table.concat(lines, "\n")
        if regtype == "V" then
            text = text .. "\n"
        end
        vim.system(command, { stdin = text, text = true }, function() end)
    end
end

-- Paste providers return `{ lines }, regtype`. External clipboard tools return
-- raw text, so split it into lines without trimming empty trailing fields.
local function paste_with(command)
    return function()
        local result = vim.system(command, { text = true }):wait()
        if result.code ~= 0 then
            return { "" }, "v"
        end
        return vim.split(result.stdout or "", "\n", { plain = true, trimempty = false }), "v"
    end
end

function M.setup()
    local copy
    local paste
    local name

    -- Prefer native providers first, then Linux display-server-specific tools.
    -- The DISPLAY/XAUTHORITY check supports X11 sessions where DISPLAY may be
    -- unavailable but X authority is still configured by the environment.
    if vim.fn.has("mac") == 1 and executable("pbcopy") and executable("pbpaste") then
        copy = { "pbcopy" }
        paste = { "pbpaste" }
        name = "pbcopy"
    elseif vim.env.WAYLAND_DISPLAY and executable("wl-copy") and executable("wl-paste") then
        copy = { "wl-copy", "--foreground", "--type", "text/plain" }
        paste = { "wl-paste", "--no-newline" }
        name = "wl-clipboard"
    elseif (vim.env.DISPLAY or vim.env.XAUTHORITY) and executable("xclip") then
        copy = { "xclip", "-quiet", "-i", "-selection", "clipboard" }
        paste = { "xclip", "-quiet", "-o", "-selection", "clipboard" }
        name = "xclip"
    elseif (vim.env.DISPLAY or vim.env.XAUTHORITY) and executable("xsel") then
        copy = { "xsel", "--clipboard", "--input" }
        paste = { "xsel", "--clipboard", "--output" }
        name = "xsel"
    end

    if copy and paste then
        -- `cache_enabled` lets Neovim avoid repeated paste command calls for
        -- unchanged clipboard contents.
        vim.g.clipboard = {
            name = name,
            copy = {
                ["+"] = copy_with(copy),
                ["*"] = copy_with(copy),
            },
            paste = {
                ["+"] = paste_with(paste),
                ["*"] = paste_with(paste),
            },
            cache_enabled = 1,
        }
        return
    end

    -- OSC52 copies through terminal escape sequences. It is not as universal as
    -- native tools, but it is the best fallback for SSH/tmux/headless sessions.
    local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
    if ok then
        vim.g.clipboard = osc52
    end
end

return M
