require("oil").setup({
	win_options = {
		signcolumn = "yes:2",
	},
	view_options = {
		show_hidden = true,
	},
	watch_for_changes = true,
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["<Tab>"] = "actions.select",
	},
})
require("oil-git-status").setup({
	show_ignored = false,
})

vim.keymap.set("n", "<leader>pv", ":Oil<cr>", { silent = true })

