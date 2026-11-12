vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Di chuyển dòng đang chọn lên/xuống
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Dán đè mà không mất nội dung register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Copy ra clipboard hệ thống
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Xoá không ghi vào register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quickfix / location list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Thay thế từ dưới con trỏ trong cả file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)

-- Lưu / đóng
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Lưu file" })
vim.keymap.set("n", "<leader>Q", "<cmd>confirm qa<CR>", { desc = "Đóng tất cả, thoát nvim" })
vim.keymap.set("n", "<leader>q", function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].modified then
        vim.notify("Buffer chưa lưu (<leader>w để lưu)", vim.log.levels.WARN)
        return
    end
    -- Buffer đặc biệt (neo-tree, help, quickfix...): xoá thẳng
    if vim.bo[buf].buftype ~= "" then return vim.cmd.bdelete(buf) end
    -- Chuyển sang buffer khác trước rồi mới xoá, để không đóng luôn cửa sổ (giữ split/neo-tree)
    vim.cmd.bprevious()
    if vim.api.nvim_get_current_buf() == buf then vim.cmd.enew() end
    vim.cmd.bdelete(buf)
end, { desc = "Đóng buffer hiện tại" })
