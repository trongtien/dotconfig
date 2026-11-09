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

vim.diagnostic.config({
    virtual_text = true,
    float = { border = "rounded", source = true },
})
