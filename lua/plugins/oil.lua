return {
    "stevearc/oil.nvim",
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
        columns = {
            "icon",
            "size",
            "mtime",
        },
        win_options = { winbar = "%{v:lua.require('oil').get_current_dir()}",
        },
        view_options = {
            show_hidden = true,
        },
        delete_to_trash = true,
    },
    lazy = false,
}
