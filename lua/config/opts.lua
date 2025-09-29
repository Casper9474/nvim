-- Options
vim.g.mapleader = " " -- Sets leader to space
vim.o.number = true -- Enables line numbers
vim.o.relativenumber = true -- Enables relative line numbers
vim.o.smartindent = true -- Enables better indenting
vim.o.undofile = true -- Enables undo history
vim.o.scrolloff = 7 -- Minimal number of lines to keep above and below the cursor
vim.o.signcolumn = "yes" -- Reduce the flickering when lsp warnings appear
vim.opt.listchars = { nbsp = "+", eol = "↴" } -- Shows end of line character
vim.o.list = true -- Shows listchars
vim.opt.fillchars = { fold = " ", eob = " " } -- Cleaner fold look

-- Better search
vim.o.ignorecase = true -- Ignore case in search
vim.o.smartcase = true  -- Override ignorecase, if search contains upper case characters

-- Better tab
vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.shiftwidth = 0   -- Number of spaces inserted when indenting
vim.o.softtabstop = -1 -- Number of spaces inserted instead of a TAB character

-- Folding options
vim.o.foldlevel = 99        -- Open all fold by default
vim.o.foldmethod = "indent" -- Better folding
vim.opt.foldtext = "v:lua.custom_foldtext()"

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false,
    underline = true,
})

-- Keybindings
vim.keymap.set({ "n", "v" }, "-", ":Oil<CR>", { silent = true, desc = "Oil" })             -- Binds netrw to -
vim.keymap.set({ "n" }, "<Esc>", ":noh<CR>", { silent = true, desc = "Clear highlights" }) -- Clears highlightings on Esc
vim.keymap.set("n", "<leader>=", function()
    require("conform").format()
end, { silent = true, desc = "Format current buffer" }) -- Formats current buffer on <leader>=

-- Autocommands

-- Highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end
})

-- Disables hover highlight
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "LspInfo", {})
    end,
})

-- Opens help in vertical split
vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
    pattern = "*/doc/*",
    callback = function()
        if (vim.bo.filetype == "help") then
            vim.cmd("wincmd L")
        end
    end
})

-- Highlights variable under the cursor
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        local filetype = vim.bo[bufnr].filetype
        local disable = {"cmake"}
        if vim.tbl_contains(disable, filetype) then
            return
        end

        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })

        vim.opt_local.updatetime = 500
    end,
})

-- Functions
local function fold_virt_text(result, s, lnum, coloff)
    if not coloff then
        coloff = 0
    end
    local text = ""
    local hl
    for i = 1, #s do
        local char = s:sub(i, i)
        local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
        local _hl = hls[#hls]
        if _hl then
            local new_hl = "@" .. _hl.capture
            if new_hl ~= hl then
                table.insert(result, { text, hl })
                text = ""
                hl = nil
            end
            text = text .. char
            hl = new_hl
        else
            text = text .. char
        end
    end
    table.insert(result, { text, hl })
end

function _G.custom_foldtext()
    local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
    local end_str = vim.fn.getline(vim.v.foldend)
    local end_ = vim.trim(end_str)
    local result = {}
    fold_virt_text(result, start, vim.v.foldstart - 1)
    table.insert(result, { " ... ", "Delimiter" })
    fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))
    return result
end
