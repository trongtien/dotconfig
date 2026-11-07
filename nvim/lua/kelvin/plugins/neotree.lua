-- Neo-tree: cây thư mục bên trái
--   <leader>e  bật/tắt cây, nhảy tới file đang mở
--   <leader>o  focus vào cây (mở nếu đang đóng)
-- Trong cây: <CR> mở, a thêm, d xoá, r đổi tên, c copy, m di chuyển,
--            H hiện file ẩn, / lọc, ? xem toàn bộ phím
require("neo-tree").setup({
    close_if_last_window = true, -- đóng nvim nếu chỉ còn cây
    popup_border_style = "rounded",
    window = {
        width = 32,
        mappings = {
            ["<space>"] = "none", -- nhường phím <leader>
            ["l"] = "open",
            ["h"] = "close_node",
        },
    },
    filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true, -- tự cập nhật khi file thay đổi
        -- giữ netrw cho <leader>pv / `nvim .`
        hijack_netrw_behavior = "disabled",
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { ".git" },
        },
    },
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal left<CR>", { desc = "Neo-tree: bật/tắt" })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus left<CR>", { desc = "Neo-tree: focus" })
