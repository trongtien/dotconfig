-- Neo-tree: cây thư mục bên trái
--   <leader>e  bật/tắt cây, nhảy tới file đang mở
--   <leader>o  focus vào cây (mở nếu đang đóng)
-- Trong cây: <CR> mở, a thêm, d xoá, r đổi tên, c copy, m di chuyển,
--            H hiện file ẩn, / lọc, ? xem toàn bộ phím
require("neo-tree").setup({
    close_if_last_window = true, -- đóng nvim nếu chỉ còn cây
    popup_border_style = "rounded",
    enable_diagnostics = false, -- không vẽ lại cây mỗi lần LSP gửi diagnostic (gây nháy)
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
        -- watcher vẽ lại cây mỗi khi có file đổi (kể cả __pycache__, .ruff_cache) -> nháy.
        -- Tắt thì cây vẫn tự làm mới sau khi lưu; file tạo từ ngoài nvim thì bấm R.
        use_libuv_file_watcher = false,
        -- để oil xử lý <leader>pv / `nvim .`
        hijack_netrw_behavior = "disabled",
        filtered_items = {
            show_hidden_count = false, -- không hiện dòng "(N hidden items)"
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = { "__init__.py" }, -- ẩn, bấm H để hiện lại
            never_show = { ".git" },
        },
    },
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal left<CR>", { desc = "Neo-tree: bật/tắt" })
vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus left<CR>", { desc = "Neo-tree: focus" })
