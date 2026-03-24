local servers = {
    lua_ls   = {
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
    pyrefly  = {},
    neocmake = {},
    clangd = {},
}

local ensure_installed = vim.tbl_keys(servers or {})

return {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Mason",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        {
            "neovim/nvim-lspconfig",
            config = function()
                for server, settings in pairs(servers) do
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
