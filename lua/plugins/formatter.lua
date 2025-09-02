return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
        formatters_by_ft = {
            python = { "ruff_format" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
    },
}
