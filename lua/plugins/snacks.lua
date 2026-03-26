return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
        statuscolumn = { enabled = true },
        lazygit = { enabled = true },
        explorer = { enabled = true, replace_netrw = true },
        picker = { enable = true },
        input = { enable = true },
        indent = { enable = true, animate = { enabled = false } },
        dashboard = { enabled = true },
    },
}
