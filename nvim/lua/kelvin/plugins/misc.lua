-- Fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status (fugitive)" })

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })

-- Conform (format)
require("conform").setup({
    formatters_by_ft = {
        go = { "gofmt" },
    },
    default_format_opts = { lsp_format = "fallback" },
})
vim.keymap.set("n", "<leader>f", function() require("conform").format({ async = true }) end, { desc = "Format" })
