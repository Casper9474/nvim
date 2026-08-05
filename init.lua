-- 0. Pack

local hooks = function(ev)
    -- Use available |event-data|
    local name, kind = ev.data.spec.name, ev.data.kind

    -- Run build script after plugin's code has changed
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
        if not ev.data.active then
            vim.cmd.packadd('nvim-treesitter')
        end
        vim.cmd('TSUpdate')
    end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })
vim.pack.add({ 'https://github.com/ellisonleao/gruvbox.nvim' })

-- 1. Colorscheme
vim.cmd.colorscheme('gruvbox')

if vim.fn.executable('tree-sitter') == 1 then
    require('nvim-treesitter').install { 'lua', 'cpp', 'c', 'python' }
end

-- 2. Options
vim.g.mapleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.softtabstop = -1

vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.undofile = true
vim.o.signcolumn = 'yes'

vim.opt.completeopt = { 'menuone', 'noinsert', 'popup', 'fuzzy' }
vim.o.autocomplete = true
vim.opt.complete = { '.', 'o' }
vim.o.pumheight = 15
vim.o.winborder = 'single'
vim.opt.wildmode = { 'noinsert' }

vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = vim.api.nvim_create_augroup('my.cmp'),
    pattern = ':',
    callback = function()
        vim.fn.wildtrigger()
    end
})

vim.o.findfunc = function(cmdarg, _)
    local files = vim.fn.glob('**/*', true, true)
    return vim.fn.matchfuzzy(files, cmdarg)
end

vim.keymap.set("n", "<leader>/", function()
    vim.ui.input({ prompt = "Grep: " }, function(pattern)
        if pattern then
            vim.cmd.grep({ args = { pattern }, bang = true, mods = { silent = true } })
            vim.cmd.copen()
        end
    end)
end, { silent = true })

vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-e><CR>'
    else
        return '<CR>'
    end
end, { expr = true, replace_keycodes = true })


vim.keymap.set('n', '<Esc>', '<cmd>noh<cr>')

-- 3. Lsp
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

local lsp_servers = {
    lua_ls = {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath('config')
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT',
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                    }
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
                    },
                },
            })
        end,
        settings = {
            Lua = {}
        }
    },
    clangd = {},
    rust_analyzer = {},
    ty = {},
    ruff = {},
}

for lsp_name, lsp_config in pairs(lsp_servers) do
    vim.lsp.config(lsp_name, lsp_config)
    vim.lsp.enable(lsp_name)
end

vim.lsp.inlay_hint.enable(true)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp'),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            -- client.server_capabilities.completionProvider.triggerCharacters = chars

            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(ev)
        local value = ev.data.params.value
        vim.api.nvim_echo({ { value.message or 'done' } }, false, {
            id = 'lsp.' .. ev.data.params.token,
            kind = 'progress',
            source = 'vim.lsp',
            title = value.title,
            status = value.kind ~= 'end' and 'running' or 'success',
            percent = value.percentage,
        })
    end,
})
