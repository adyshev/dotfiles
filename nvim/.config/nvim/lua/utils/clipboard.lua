local M = {}

local function executable(bin)
    return vim.fn.executable(bin) == 1
end

local function copy_with(command)
    return function(lines, regtype)
        local text = table.concat(lines, "\n")
        if regtype == "V" then
            text = text .. "\n"
        end
        vim.system(command, { stdin = text, text = true }, function() end)
    end
end

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

    if vim.fn.has("mac") == 1 and executable("pbcopy") and executable("pbpaste") then
        copy = { "pbcopy" }
        paste = { "pbpaste" }
        name = "pbcopy"
    elseif vim.env.WAYLAND_DISPLAY and executable("wl-copy") and executable("wl-paste") then
        copy = { "wl-copy", "--foreground", "--type", "text/plain" }
        paste = { "wl-paste", "--no-newline" }
        name = "wl-clipboard"
    elseif executable("xclip") then
        copy = { "xclip", "-quiet", "-i", "-selection", "clipboard" }
        paste = { "xclip", "-quiet", "-o", "-selection", "clipboard" }
        name = "xclip"
    elseif executable("xsel") then
        copy = { "xsel", "--clipboard", "--input" }
        paste = { "xsel", "--clipboard", "--output" }
        name = "xsel"
    end

    if copy and paste then
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

    local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
    if ok then
        vim.g.clipboard = osc52
    end
end

return M
