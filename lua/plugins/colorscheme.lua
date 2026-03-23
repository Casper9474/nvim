return {
    {
        "savq/melange-nvim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("melange")
        end,
    }
}
