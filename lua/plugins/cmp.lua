return {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        completion = {
            menu = {
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } }
                }
            },
        },
        signature = {
            enabled = true,
        },
        fuzzy = {
            sorts = {
                "exact",
                "score",
                "sort_text",
            },
        },
        cmdline = {
            completion = {
                menu = {
                    auto_show = function()
                        return vim.fn.getcmdtype() == ":"
                    end
                },
            },
        },
        sources = {
            min_keyword_length = 2
        },
    },
}
