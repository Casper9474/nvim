-- Options
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.smartindent = true
vim.o.undofile = true
vim.o.scrolloff = 7
vim.o.signcolumn = "yes"
vim.opt.listchars = { nbsp = "+", eol = "↴" }
vim.o.list = true
vim.opt.fillchars = { fold = " ", eob = " " }
vim.o.showmode = false
vim.o.wrap = false

-- Better search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Better tab
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 0
vim.o.softtabstop = -1

-- Folding options
vim.o.foldlevel = 99
vim.o.foldmethod = "indent"
vim.opt.foldtext = ""

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false,
    underline = true,
})
