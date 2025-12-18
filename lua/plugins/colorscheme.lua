return {
    {
        "sainnhe/sonokai",
        lazy = false,
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("sonokai")
        end,
        config = function()
            vim.g.sonokai_menu_selection_background = "green"
            vim.g.sonokai_dim_inactive_windows = true
        end
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            -- vim.cmd.colorscheme("kanagawa")
        end,
    },
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            -- vim.cmd.colorscheme("dracula")
        end
    }
}
