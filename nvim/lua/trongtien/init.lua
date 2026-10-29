require "trongtien.set"
require "trongtien.remap"
require "trongtien.lazy_init"

local augroup = vim.api.nvim_create_augroup
local TrongtienGroup = augroup("Trongtien", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.hl.on_yank {
      higroup = "IncSearch",
      timeout = 40,
    }
  end,
})

autocmd("BufWritePre", {
  group = TrongtienGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
  group = TrongtienGroup,
  callback = function(e)
    local function opts(desc)
      return { buffer = e.buf, desc = "LSP " .. desc, silent = true }
    end
    local map = vim.keymap.set

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    map("n", "gr", vim.lsp.buf.references, opts "References")
    map("n", "gi", vim.lsp.buf.implementation, opts "Implementation")
    map("n", "gt", vim.lsp.buf.type_definition, opts "Type definition")
    map("n", "K", vim.lsp.buf.hover, opts "Hover docs")
    map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts "Workspace symbol")
    map("n", "<leader>vrr", vim.lsp.buf.references, opts "References")

    -- Code
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
    map("n", "<leader>vca", vim.lsp.buf.code_action, opts "Code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, opts "Rename")
    map("n", "<leader>vrn", vim.lsp.buf.rename, opts "Rename")
    map("n", "<leader>lf", function()
      vim.lsp.buf.format { async = true }
    end, opts "Format")

    -- Diagnostics
    map("n", "<leader>de", vim.diagnostic.open_float, opts "Line diagnostics")
    map("n", "<leader>vd", vim.diagnostic.open_float, opts "Line diagnostics")
    map("n", "<leader>pe", function()
      vim.diagnostic.jump { count = -1, float = true }
    end, opts "Prev diagnostic")
    map("n", "<leader>ne", function()
      vim.diagnostic.jump { count = 1, float = true }
    end, opts "Next diagnostic")
    map("n", "<leader>dl", vim.diagnostic.setloclist, opts "Diagnostics to loclist")

    -- Signature help
    map("i", "<C-k>", vim.lsp.buf.signature_help, opts "Signature help")
  end,
})
