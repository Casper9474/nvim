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
            lualine_x = { "encoding", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" }
        }
    }
}
