return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup {
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettierd" },
        scss = { "prettierd" },
        less = { "prettierd" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        go = { "goimports", "gofumpt" },
        python = { "black" },
      },
    }

    vim.keymap.set("n", "<leader>f", function()
      require("conform").format { bufnr = 0 }
    end)
  end,
}
