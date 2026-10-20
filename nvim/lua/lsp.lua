-- LSP keymaps: chuyen bo g-default (gra/grn/grr/gri/grt/grx/gO)
-- sang <leader>g de de bam hon; K, gq, ]d van giu default nvim
local del = function(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
end

-- Gỡ các default g-keys (set luc nvim khoi dong, truoc config nay)
del("n", "gra")
del("x", "gra")
del("n", "grn")
del("n", "grr")
del("n", "gri")
del("n", "grt")
del("n", "grx")
del("n", "gO")

local set = function(lhs, rhs, desc, mode)
  vim.keymap.set(mode or "n", lhs, rhs, { silent = true, desc = desc })
end

set("gd", vim.lsp.buf.definition, "LSP: definition")
set("gD", vim.lsp.buf.declaration, "LSP: declaration")
set("gr", vim.lsp.buf.references, "LSP: references")
set("gi", vim.lsp.buf.implementation, "LSP: implementation")
set("gt", vim.lsp.buf.type_definition, "LSP: type definition")
set("<leader>ca", vim.lsp.buf.code_action, "LSP: code action", { "n", "x" })
set("<leader>gn", vim.lsp.buf.rename, "LSP: rename")
set("<leader>go", vim.lsp.buf.document_symbol, "LSP: document symbols")
set("<leader>gx", vim.lsp.codelens.run, "LSP: run codelens")
