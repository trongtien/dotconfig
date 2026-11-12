-- Oil: sửa thư mục như sửa một buffer text, rồi :w (<leader>w) để áp dụng
--   -  / <leader>pv   mở thư mục chứa file hiện tại (trong oil: lên thư mục cha)
--   Thêm file:        o/O tạo dòng mới, gõ tên (kết thúc bằng / để tạo thư mục)
--   Đổi tên:          sửa tên trên dòng (cw, ciw...)
--   Xoá:              dd  (file vào thùng rác, khôi phục: g\ )
--   Di chuyển:        dd ở thư mục này, p ở thư mục khác
--   Lưu thay đổi:     :w  -> oil hiện danh sách thay đổi, bấm Y để xác nhận
--   <CR> mở, <C-p> xem trước, g. hiện/ẩn file ẩn, g? xem toàn bộ phím
require("oil").setup({
    default_file_explorer = true, -- thay netrw: `nvim .` mở oil
    delete_to_trash = true, -- xoá nhầm vẫn khôi phục được
    skip_confirm_for_simple_edits = true, -- chỉ thêm/đổi tên thì lưu luôn, không hỏi
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name) return name == ".git" or name == ".." end,
    },
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Oil: mở thư mục cha" })
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "Oil: mở thư mục cha" })
