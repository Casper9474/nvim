return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" }
        },
        tabline = {
            lualine_a = { "buffers" },
        },
        sections = {
            lualine_x = {
                { "lsp_status", icon = "", symbols = { done = "", separator = "" }, show_name = false },
                "encoding",
                "filetype"
            },
            lualine_y = { "progress" },
            lualine_z = { "location" }
        }
    }
}
