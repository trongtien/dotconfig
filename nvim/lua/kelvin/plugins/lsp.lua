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

-- Server được cài qua Mason và tự bật (vim.lsp.enable)
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "gopls", "ts_ls", "pyright", "bashls" },
    automatic_enable = true,
})

vim.diagnostic.config({
    virtual_text = true,
    float = { border = "rounded", source = true },
})
