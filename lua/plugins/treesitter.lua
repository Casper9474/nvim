return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, { silent = true })
        end
    },
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        local install = require("nvim-treesitter.install")
        configs.setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "cpp", "python" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
        install.compilers = { "zig", "cc", "gcc", "clang", "cl" }
    end
}
