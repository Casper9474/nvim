-- Map leader
vim.g.mapleader = ' '

-- Line column
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

-- Fix line wrapping
vim.o.wrap = true
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Keep x lines above/below cursor
vim.o.scrolloff = 5

-- Better search
vim.o.smartcase = true
vim.o.ignorecase = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- Peristent undo
vim.o.undofile = true

-- Better tab
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.expandtab = true

-- Clipboard
if vim.fn.executable("clip.exe") == 1 and vim.fn.executable("powershell.exe") == 1 then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true
})

-- Colorscheme
vim.pack.add({
    'https://github.com/junegunn/seoul256.vim'
})
vim.g.seoul256_background = 234
vim.cmd.colorscheme('seoul256')

-- Line
vim.pack.add({'https://github.com/itchyny/lightline.vim'})
vim.g.lightline = {
    colorscheme = 'seoul256'
}
vim.o.showmode = false

-- Direcotry changer
vim.pack.add({'https://github.com/airblade/vim-rooter'})

-- Autocompletion
vim.pack.add({
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') },
    'https://github.com/rafamadriz/friendly-snippets',
})
require('blink.cmp').setup({
    completion = {
        documentation = { auto_show = true }
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    fuzzy = {
        implementation = "prefer_rust_with_warning"
    },

    cmdline = {
        completion = {
            menu = {
                auto_show = function ()
                    return vim.fn.getcmdtype() == ':'
                end
            }
        }
    }
})

-- Lsp
vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig'
})
local lsp_servers = {
    lua_ls = {
        bin = 'lua-language-server',
        ---@type vim.lsp.Config
        config = {
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                        return
                    end
                end

                ---@diagnostic disable-next-line: param-type-mismatch
                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most
                        -- likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                        -- Tell the language server how to find Lua modules same way as Neovim
                        -- (see `:h lua-module-load`)
                        path = {
                            'lua/?.lua',
                            'lua/?/init.lua',
                        },
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
                            vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                        },
                        -- Or pull in all of 'runtimepath'.
                        -- NOTE: this is a lot slower and will cause issues when working on
                        -- your own configuration.
                        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                        -- library = vim.api.nvim_get_runtime_file('', true),
                    },
                })
            end,
            ---@type lspconfig.settings.lua_ls
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                    }
                },
            },
        }
    },
    clangd = {
        config = {}
    },
    rust_analyzer = {
        bin = 'rust-analyzer',
        config = {}
    }
}
for lsp, config in pairs(lsp_servers) do
    if vim.fn.executable(config.bin and config.bin or lsp) == 1 then
        vim.lsp.config(lsp, config.config)
        vim.lsp.enable(lsp)
    end
end
vim.keymap.set('n', '<Leader>t', function () vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { silent = true })
vim.lsp.inlay_hint.enable()
vim.keymap.del({'n','v'}, 'gra')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'grx')
vim.keymap.del('n', 'gO')
vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, {silent = true})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {silent = true})
vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, {silent = true})
-- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {silent = true})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {silent = true})
-- vim.keymap.set('n', '<Leader>c', vim.lsp.codelens.run, {silent = true})

-- Fzf
vim.pack.add({'https://github.com/ibhagwan/fzf-lua'})
require('fzf-lua').setup({'ivy', fzf_colors = true})
require('fzf-lua').register_ui_select()
vim.keymap.set({'n', 'v'},'<Leader>f', function() require('fzf-lua').files() end, {silent = true})
vim.keymap.set('n','<Leader>/', function() require('fzf-lua').live_grep() end, {silent = true}) -- <search_term> -- <glob_patterns> <C-g> <search_term>
vim.keymap.set('n','<Leader><Leader>', function() require('fzf-lua').resume() end, {silent = true})
vim.keymap.set('n', 'gr', function() require('fzf-lua').lsp_references() end, {silent = true})
vim.keymap.set('n', 'gO', function () require('fzf-lua').lsp_document_symbols({
    child_prefix = false,
    regex_filter = function(entry)
        local denied_kinds = {
            "String",
            "Boolean",
            "Array",
            "Number"
        }
        return not vim.tbl_contains(denied_kinds, entry.kind)
    end,
}) end, {silent = true})
