-- Multi cursor (vim-visual-multi), giống Ctrl+D của VS Code
--   <C-n>          chọn từ dưới con trỏ / thêm lần xuất hiện kế tiếp (visual: chọn đoạn đang bôi)
--   n / N          sang lần xuất hiện kế tiếp / trước đó      q  bỏ qua cái hiện tại, sang cái kế
--   Q              bỏ con trỏ hiện tại                         <Esc>  thoát multi cursor
--   <C-Down>/<C-Up> thêm con trỏ ở dòng dưới/trên
--   \\A            chọn tất cả lần xuất hiện của từ             Tab  đổi qua lại cursor/extend mode
-- Phải đặt trước khi plugin được source (sau init.lua), nên file này được require sau vim.pack.add.
vim.g.VM_maps = {
    ["Find Under"] = "<C-n>",
    ["Find Subword Under"] = "<C-n>",
    ["Add Cursor Down"] = "<C-Down>",
    ["Add Cursor Up"] = "<C-Up>",
}
vim.g.VM_show_warnings = 0
