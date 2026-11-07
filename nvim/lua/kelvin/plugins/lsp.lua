require("lazydev").setup({
    library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
})

require("blink.cmp").setup({
    keymap = { preset = "default" }, -- <C-y> chọn, <C-n>/<C-p> lên xuống
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
    },
})

require("fidget").setup({})
require("mason").setup()

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Pyright không tự tìm virtualenv của project -> dùng python hệ thống và báo lỗi import.
-- Trỏ pythonPath vào .venv/venv trong root (thư mục chứa pyproject.toml), nếu có.
vim.lsp.config("pyright", {
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
    ensure_installed = { "lua_ls", "gopls", "ts_ls", "pyright", "bashls" },
    automatic_enable = true,
})

vim.diagnostic.config({
    virtual_text = true,
    float = { border = "rounded", source = true },
})
