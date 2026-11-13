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
-- (bỏ qua buffer không sửa được -> tránh lỗi E21; bỏ qua buffer đặc biệt như oil;
--  giữ nguyên vị trí con trỏ)
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*",
    callback = function(e)
        local bo = vim.bo[e.buf]
        if not bo.modifiable or bo.binary or bo.buftype ~= "" then return end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns keepjumps silent! %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Tự load lại file khi bị sửa từ ngoài (Claude Code, git checkout...)
-- autoread mặc định đã bật, nhưng nvim chỉ kiểm tra khi có sự kiện -> gọi checktime.
-- Buffer đang có thay đổi chưa lưu thì nvim sẽ hỏi chứ không ghi đè.
local function checktime()
    -- không chạy trong cmdline / cmdwin (E11)
    if vim.fn.mode():match("[cr!t]") or vim.fn.getcmdwintype() ~= "" then return end
    vim.cmd("silent! checktime")
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
    group = group,
    callback = checktime,
})

-- Kiểm tra định kỳ: thấy code mới ngay cả khi đang đứng yên trong nvim, không chuyển pane
local timer = vim.uv.new_timer()
if timer then timer:start(1000, 1000, vim.schedule_wrap(checktime)) end

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = group,
    callback = function(e)
        vim.notify("File đã đổi trên đĩa, đã load lại: " .. vim.fn.fnamemodify(e.file, ":~:."), vim.log.levels.INFO)
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
