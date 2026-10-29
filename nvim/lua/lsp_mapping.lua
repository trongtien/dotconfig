-- LSP keymaps (chỉ set khi attach LSP)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  callback = function(ev)
    local function opts(desc)
      return { buffer = ev.buf, desc = "LSP " .. desc, silent = true }
    end
    local map = vim.keymap.set

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    map("n", "gr", vim.lsp.buf.references, opts "References")
    map("n", "gi", vim.lsp.buf.implementation, opts "Implementation")
    map("n", "gt", vim.lsp.buf.type_definition, opts "Type definition")
    map("n", "K", vim.lsp.buf.hover, opts "Hover docs")

    -- Code
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
    map("n", "<leader>rn", function()
      require("nvchad.lsp.renamer")()
    end, opts "Rename")
    map("n", "<leader>lf", function()
      vim.lsp.buf.format { async = true }
    end, opts "Format")

    -- Diagnostics
    map("n", "<leader>de", vim.diagnostic.open_float, opts "Line diagnostics")
    map("n", "<leader>pe", vim.diagnostic.goto_prev, opts "Prev diagnostic")
    map("n", "<leader>ne", vim.diagnostic.goto_next, opts "Next diagnostic")
    map("n", "<leader>dl", vim.diagnostic.setloclist, opts "Diagnostics to loclist")

    -- Signature help
    map("i", "<C-k>", vim.lsp.buf.signature_help, opts "Signature help")
  end,
})





