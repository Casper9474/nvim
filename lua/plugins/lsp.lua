local servers = {
    lua_ls  = {
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
                        '${3rd}/luv/library'
                        -- Depending on the usage, you might want to add additional paths
                        -- here.
                        -- '${3rd}/busted/library'
                    }
                    -- Or pull in all of 'runtimepath'.
                    -- NOTE: this is a lot slower and will cause issues when working on
                    -- your own configuration.
                    -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                    -- library = {
                    --   vim.api.nvim_get_runtime_file('', true),
                    -- }
                }
            })
        end,
        settings = {
            Lua = {
                hint = {
                    enable = true,
                    arrayIndex = "Disable",
                    awaitPropagate = true,
                }
            }
        }
    },
    pyrefly = {},
    neocmake = {},
}

local ensure_installed = vim.tbl_keys(servers or {})

return {
    "mason-org/mason-lspconfig.nvim",
    event = {"BufReadPre", "BufNewFile"},
    cmd = "Mason",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        {
            "neovim/nvim-lspconfig",
            config = function()
                for server, settings in pairs(servers) do
                    settings.capabilities = require("blink.cmp").get_lsp_capabilities(settings.capabilities)
                    vim.lsp.config(server, settings)
                    vim.lsp.enable(server)
                end
                vim.lsp.inlay_hint.enable(true)
            end
        }
    },
    opts = {
        ensure_installed = ensure_installed,
        automatic_enable = true,
    },
}
