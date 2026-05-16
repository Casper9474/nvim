-- Opts ----------------------------------------------------------------------------------------------------------------

vim.loader.enable(true)
require('vim._core.ui2').enable({
    enable = true,
})

vim.g.mapleader = " "
vim.o.undofile = true
vim.o.mouse = "a"
vim.opt.timeoutlen = 300

vim.o.breakindent = true
vim.o.linebreak = true
vim.o.scrolloff = 5

vim.o.number = true
vim.o.relativenumber = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.signcolumn = "yes"
vim.o.fillchars = "eob: "

vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.smartcase = true

vim.o.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.o.formatoptions = "qjl1"

vim.o.undofile = true

-- Keymap --------------------------------------------------------------------------------------------------------------

vim.keymap.set({ "n", "x" }, "<Esc>", "<CMD>noh<CR><Esc>", { silent = true })

-- Autocmds ------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end
})

-- Utils ---------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_user_command("AlignHeaders", function()
    local width = 120
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
        local title = line:match("^%-%- (.-) %-+$")
        if title then
            lines[i] = "-- " .. title .. " " .. string.rep("-", width - #title - 4)
        end
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, {})

vim.api.nvim_create_user_command("VimPackClean", function()
    local inactive_plugins = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()

    vim.notify("Attempting to delete inactive plugins: \n" .. table.concat(inactive_plugins, "\n"))
    if not pcall(vim.pack.del, inactive_plugins) then
        vim.notify("Failed to delete inactive plugins...")
    end
end, {})

vim.api.nvim_create_user_command("VimPackUpdate", function()
    local plugins = vim.iter(vim.pack.get())
        :filter(function(x) return x.active end)
        :map(function(x) return x.spec.name end)
        :totable()

    vim.notify("Attempting to update active plugins: \n" .. table.concat(plugins, "\n"))
    if not pcall(vim.pack.update, plugins) then
        vim.notify("Failed to update active plugins...")
    end
end, {})

-- Plugins -------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
            vim.cmd("TSUpdate")
        end
    end
})

local gh = function(x) return "https://github.com/" .. x end
vim.pack.add({
    gh("ofirgall/ofirkai.nvim"),
    gh("nvim-tree/nvim-web-devicons"),
    gh("hiphish/rainbow-delimiters.nvim"),
    gh("nvimdev/indentmini.nvim"),
    gh("nvim-treesitter/nvim-treesitter"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("mason-org/mason.nvim"),
    gh("neovim/nvim-lspconfig"),
    gh("stevearc/conform.nvim"),
    gh("nvim-lualine/lualine.nvim"),
    gh("stevearc/oil.nvim"),
    gh("ibhagwan/fzf-lua"),
    gh("rafamadriz/friendly-snippets"),
    gh("saghen/blink.lib"),
    gh("saghen/blink.cmp"),
    gh("github/copilot.vim"),
})

-- Colorscheme ---------------------------------------------------------------------------------------------------------

vim.cmd.colorscheme("ofirkai")
vim.cmd.highlight('IndentLine guifg=#717475')
vim.cmd.highlight('IndentLineCurrent guifg=#e3a1db')
require("indentmini").setup({})

-- Treesitter ----------------------------------------------------------------------------------------------------------

local treesitter = { "cpp", "lua", "html", "vim", "c_sharp", "css", "tsx", "svelte", "go", "rust", "zig", "javascript",
    "java", "c", "json" }

require("nvim-treesitter").install(treesitter)

vim.api.nvim_create_autocmd("FileType", {
    pattern = treesitter,
    callback = function()
        vim.treesitter.start()
    end,
})

-- Lsp -----------------------------------------------------------------------------------------------------------------

local servers = {
    lua_ls = {
        settings = {
            Lua = {
                workspace = {
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                    checkThirdParty = false
                }
            }
        }
    },
    clangd = {},
    ty = {},
    neocmake = {},
    svelte = {},
    vtsls = {},
}

vim.lsp.inlay_hint.enable(true)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers)
})
for server, settings in pairs(servers) do
    vim.lsp.config(server, settings)
end

--- @param diagnostic? vim.Diagnostic
--- @param bufnr integer
local function on_jump(diagnostic, bufnr)
    if not diagnostic then return end
    vim.diagnostic.show(
        diagnostic.namespace,
        bufnr,
        { diagnostic },
        { virtual_lines = { current_line = true }, virtual_text = false }
    )
end

vim.diagnostic.config({ jump = { on_jump = on_jump } })

vim.keymap.set({ "n", "x" }, "<Leader>r", vim.lsp.buf.rename, { desc = "Rename symbol under cursor", silent = true })

-- Formatter -----------------------------------------------------------------------------------------------------------

require("conform").setup()
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.keymap.set({ "n", "x" }, "<Leader>=", "<CMD>Format<CR>", { silent = true, desc = "Format current buffer" })

-- Lualine -------------------------------------------------------------------------------------------------------------

require("lualine").setup({
    options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    extensions = { "oil", "fzf", "mason", },
})

-- File explorer -------------------------------------------------------------------------------------------------------

require("oil").setup()
vim.keymap.set({ "n", "x" }, "-", "<CMD>Oil<CR>", { silent = true, desc = "Open oil" })

require("fzf-lua").setup({
    -- fzf_bin = "sk",
})
vim.keymap.set({ "n", "x" }, "<Leader>ff", function() require("fzf-lua").files() end,
    { silent = true, desc = "Open file picker" })
vim.keymap.set({ "n", "x" }, "<Leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end,
    { silent = true, desc = "Open config file picker" })
vim.keymap.set({ "n", "x" }, "<Leader>fb", function() require("fzf-lua").buffers() end,
    { silent = true, desc = "Open buffer picker" })
vim.keymap.set({ "n", "x" }, "<Leader>/", function() require("fzf-lua").live_grep() end,
    { silent = true, desc = "Open live grep" })
vim.keymap.set({ "n", "x" }, "<Leader>fr", function() require("fzf-lua").lsp_references() end,
    { silent = true, desc = "Find references" })
vim.keymap.set({ "n", "x" }, "<Leader>ca", function() require("fzf-lua").lsp_code_actions() end,
    { silent = true, desc = "Code actions" })
vim.keymap.set({ "n", "x" }, "<Leader>sk", function() require("fzf-lua").keymaps() end,
    { silent = true, desc = "Show keybidings" })
vim.keymap.set({ "n", "x" }, "gd", function()
    require("fzf-lua").lsp_definitions()
end, { silent = true, desc = "Goto Definition" })
vim.keymap.set({ "n", "x" }, "gi", function() require("fzf-lua").lsp_implementations() end,
    { silent = true, desc = "Goto Implementation" })

-- Cmp -----------------------------------------------------------------------------------------------------------------

require("blink.cmp").build():wait(60000)

require("blink.cmp").setup({
    cmdline = {
        completion = {
            menu = {
                auto_show = function()
                    return vim.fn.getcmdtype() == ":"
                end
            }
        }
    },
    sources = {
        min_keyword_length = 2,
    },
})
