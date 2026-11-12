require("lazydev").setup({
    library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
})

-- Completion
--   <CR> / <C-y>         chấp nhận gợi ý (luôn chọn sẵn mục đầu tiên)
--   <Tab> / <S-Tab>      nhảy trong snippet, không thì xuống/lên trong menu
--   <C-n>/<C-p>, ↓/↑     xuống / lên
--   <C-space>            mở menu / bật tắt tài liệu
--   <C-e>                đóng menu (rồi <CR> để xuống dòng)
--   <C-b>/<C-f>          cuộn tài liệu,  <C-k> chữ ký hàm
require("blink.cmp").setup({
    keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        accept = { auto_brackets = { enabled = true } }, -- tự thêm () khi chọn hàm
        menu = {
            border = "rounded",
            draw = {
                treesitter = { "lsp" },
                columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
        ghost_text = { enabled = true }, -- hiện mờ phần còn lại của gợi ý đang chọn
    },
    signature = { enabled = true, window = { border = "rounded" } },
    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            buffer = { score_offset = -3 }, -- ưu tiên LSP/snippet hơn từ trong buffer
        },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Mặc định fidget chạy spinner 10 khung/giây ~3s sau MỖI lần sửa (pyright báo "Analyzing")
-- -> màn hình chớp liên tục. Bỏ qua pyright, các server khác vẫn hiện tiến trình.
require("fidget").setup({
    progress = {
        ignore = { "pyright", "basedpyright" },
        suppress_on_insert = true, -- không hiện khi đang gõ
        ignore_done_already = true, -- bỏ qua tiến trình đã xong ngay khi tới
    },
})
require("mason").setup()

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Python dùng basedpyright thay cho pyright: pyright gốc KHÔNG có code action "thêm import"
-- (tính năng của Pylance) và ở diagnosticMode=openFilesOnly không gợi ý auto-import class
-- trong file chưa mở. basedpyright (fork của pyright) có cả hai.
-- Lưu ý: auto-import chỉ hoạt động khi mọi thư mục trên đường dẫn module là tên Python
-- hợp lệ (vd value_object, KHÔNG phải value-object).
--
-- Pyright/basedpyright không tự tìm virtualenv của project -> dùng python hệ thống và báo lỗi
-- import. Trỏ pythonPath vào .venv/venv trong root (thư mục chứa pyproject.toml), nếu có.
vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            analysis = {
                -- mặc định "recommended" rất gắt (báo cả thiếu type, Any...) -> giữ mức như pyright
                typeCheckingMode = "standard",
            },
        },
    },
    before_init = function(_, config)
        if not config.root_dir then return end
        for _, dir in ipairs({ ".venv", "venv", "env" }) do
            local python = vim.fs.joinpath(config.root_dir, dir, "bin", "python")
            if vim.uv.fs_stat(python) then
                config.settings.python = config.settings.python or {}
                config.settings.python.pythonPath = python
                return
            end
        end
    end,
})

-- Server được cài qua Mason và tự bật (vim.lsp.enable)
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "gopls", "ts_ls", "basedpyright", "bashls" },
    -- pyright cũ có thể vẫn còn trong Mason -> không bật, tránh chạy 2 server Python cùng lúc
    automatic_enable = { exclude = { "pyright" } },
})

-- Hiển thị lỗi/cảnh báo của LSP:
--   - chữ mờ cuối dòng (virtual_text) + icon ở cột trái (signs) + gạch chân chỗ lỗi
--   - lỗi nặng hơn được ưu tiên hiện trước (severity_sort)
--   - không cập nhật khi đang gõ ở insert mode (đỡ nhảy chữ), cập nhật khi về normal
local sev = vim.diagnostic.severity
vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
    signs = {
        text = {
            [sev.ERROR] = " ",
            [sev.WARN] = " ",
            [sev.INFO] = " ",
            [sev.HINT] = "󰌵 ",
        },
    },
    float = { border = "rounded", source = true },
})

-- Di chuyển giữa các lỗi / cảnh báo (bỏ qua info/hint), tự mở popup chi tiết sau khi nhảy
--   <leader>ne   lỗi kế tiếp          <leader>pe   lỗi trước đó
--   <leader>re   xem chi tiết lỗi trên dòng hiện tại
--   <leader>pd   danh sách lỗi của cả project (Telescope)
-- (Mặc định của nvim vẫn còn: ]d / [d, ]D / [D, <C-w>d)
local function jump(count)
    return function()
        vim.diagnostic.jump({
            count = count,
            severity = { min = sev.WARN },
            on_jump = function(_, bufnr)
                vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
            end,
        })
    end
end
vim.keymap.set("n", "<leader>ne", jump(1), { desc = "Diagnostic: lỗi kế tiếp" })
vim.keymap.set("n", "<leader>pe", jump(-1), { desc = "Diagnostic: lỗi trước đó" })
vim.keymap.set("n", "<leader>re", function() vim.diagnostic.open_float({ scope = "line" }) end, {
    desc = "Diagnostic: xem chi tiết lỗi trên dòng",
})
vim.keymap.set("n", "<leader>pd", function() require("telescope.builtin").diagnostics() end, {
    desc = "Diagnostic: danh sách lỗi (Telescope)",
})
