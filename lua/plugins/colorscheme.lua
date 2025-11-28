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
        end
    }
}
