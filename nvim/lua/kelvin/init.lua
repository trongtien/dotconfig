-- Dựa trên https://github.com/ThePrimeagen/init.lua
require("kelvin.set")
require("kelvin.remap") -- phải trước plugin để mapleader có hiệu lực
require("kelvin.pack")

local group = vim.api.nvim_create_augroup("Kelvin", { clear = true })

-- Nháy sáng vùng vừa yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 40 }) end,
})

-- Xoá khoảng trắng thừa cuối dòng khi lưu
-- (bỏ qua buffer không sửa được -> tránh lỗi E21; giữ nguyên vị trí con trỏ)
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*",
    callback = function(e)
        if not vim.bo[e.buf].modifiable or vim.bo[e.buf].binary then return end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns keepjumps silent! %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Phím tắt LSP khi server gắn vào buffer
-- (Neovim 0.11+ đã có sẵn: K, grn, gra, grr, gri, gO, [d, ]d)
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(e)
        local o = { buffer = e.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, o)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, o)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, o)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, o)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, o)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, o)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, o)
    end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
