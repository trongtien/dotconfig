require("option")
require("plugins")
require("remap")
require("clear_noh")
require("autocmds")
require("harpoon")

vim.lsp.enable({
	"html",
	"cssls",
	"tailwindcss",
	"gopls",
	"ts_ls",
	"templ",
	"jsonls",
	"lua_ls",
	"yamlls",
})
