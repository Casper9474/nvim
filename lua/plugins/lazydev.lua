return {
    "folke/lazydev.nvim",
    dependencies = { { "DrKJeff16/wezterm-types", version = false } },
    ft = "lua",
    opts = {
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "snacks.nvim",        words = { "Snacks" } },
            { path = "lazy.nvim",          words = { "LazyVim" } },
            { path = 'wezterm-types',      mods = { 'wezterm' } }
        },
    },
}
