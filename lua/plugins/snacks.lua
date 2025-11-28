return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        statuscolumn = { enabled = true, folds = { open = true, git_hl = true, } },
        lazygit = { enabled = true },
        explorer = { enabled = true, replace_netrw = true },
        picker = { enable = true },
        input = { enable = true },
        indent = { enable = true, animate = { enabled = false } },
        dashboard = { enabled = true },
    },
}
