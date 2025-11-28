local set = vim.keymap.set
local function cmd(opts)
    local ok, err = pcall(vim.api.nvim_cmd, opts, {})
    if not ok then
        vim.api.nvim_echo({ { err:sub(#"Vim:" + 1) } }, true, { err = true })
    end
end

set({ "n", "x" }, "<leader>qb", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

set({ "n", "x" }, "<leader>t", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, desc = "Toggle inlay hints and diagnostics" })

set({ "n" }, "<Esc>", ":noh<CR>",
    { silent = true, desc = "Clear highlights" })

set("n", "<leader>=", function()
    require("conform").format()
end, { silent = true, desc = "Format current buffer" })

set("n", "<s-tab>", function()
    cmd({ cmd = "bprevious", count = vim.v.count1 })
end, { desc = ":bprevious" })

set("n", "<tab>", function()
    cmd({ cmd = "bnext", count = vim.v.count1 })
end, { desc = ":bnext" })

set({ "n", "x" }, "-", function()
    Snacks.explorer()
end, { silent = true, desc = "File explorer" })

set({ "n", "x" }, "<leader>lg", function()
    Snacks.lazygit()
end, { silent = true, desc = "Enter lazygit" })

set({ "n", "x" }, "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Goto definition" })

set({ "n", "x" }, "gD", function()
    Snacks.picker.lsp_declarations()
end, { desc = "Goto declaration" })

set({ "n", "x" }, "gr", function()
    Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })

set({ "n", "x" }, "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto implementation" })

set({ "n", "x" }, "gt", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto type definition" })

set({ "n", "x" }, "<leader>qf", function()
    Snacks.picker.qflist()
end, { desc = "Quickfix List" })

set({ "n", "x" }, "<leader>fb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })

set({ "n", "x" }, "<leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find config file" })

set({ "n", "x" }, "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find files" })

set({ "n", "x" }, "<leader>sk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymaps" })

set({ "n", "x" }, "<leader>/", function()
    Snacks.picker.grep()
end, { desc = "Grep" })

set({ "n", "x" }, "<leader>cd", "<cmd>cd %:h<CR>",
    { silent = true, desc = "Change directory to current file" })
