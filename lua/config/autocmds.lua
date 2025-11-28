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
        local disable = { "cmake" }
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

-- Resizes window after resizing vim
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function ()
        vim.cmd("wincmd =")
    end
})
