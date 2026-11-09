-- Conform: format khi lưu + <leader>f
--   :FormatDisable  tắt format khi lưu (thêm ! để chỉ tắt cho buffer hiện tại)
--   :FormatEnable   bật lại
--   :ConformInfo    xem formatter nào đang dùng / lỗi
-- Filetype không có formatter riêng thì dùng LSP (lsp_format = "fallback").

-- Formatter cài qua Mason (bin nằm trong PATH của nvim sau mason.setup())
local tools = { "stylua", "prettierd", "ruff", "shfmt", "goimports" }

local prettier = { "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        vue = prettier,
        json = prettier,
        jsonc = prettier,
        css = prettier,
        scss = prettier,
        html = prettier,
        yaml = prettier,
        markdown = prettier,
    },
    formatters = {
        shfmt = { prepend_args = { "-i", "4", "-ci" } }, -- thụt 4 space như set.lua
        stylua = { prepend_args = { "--indent-type", "Spaces" } }, -- khi project không có stylua.toml
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(buf)
        if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end
        return { timeout_ms = 1000 }
    end,
    notify_no_formatters = false, -- file không có formatter/LSP thì lưu bình thường, không báo lỗi
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- gq cũng dùng conform

vim.keymap.set({ "n", "x" }, "<leader>f", function() require("conform").format({ async = true }) end, { desc = "Format" })

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, { desc = "Tắt format khi lưu (! = chỉ buffer này)", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = "Bật lại format khi lưu" })

-- Tự cài formatter còn thiếu (bỏ qua khi chạy headless)
if #vim.api.nvim_list_uis() > 0 then
    local registry = require("mason-registry")
    registry.refresh(function()
        for _, name in ipairs(tools) do
            local ok, pkg = pcall(registry.get_package, name)
            if ok and not pkg:is_installed() and not pkg:is_installing() then pkg:install() end
        end
    end)
end
