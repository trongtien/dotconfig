-- VSCode-like file explorer: mini.files pinned to the right edge
require("mini.files").setup({
	windows = {
		width_focus = 35,
		width_nofocus = 25,
		preview = false,
	},
})

local place_right = function(win_id)
	if not vim.api.nvim_win_is_valid(win_id) then
		return
	end
	local has_tabline = vim.o.showtabline == 2
		or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
	local cfg = vim.api.nvim_win_get_config(win_id)
	cfg.anchor = "NE"
	cfg.relative = "editor"
	cfg.col = vim.o.columns
	cfg.row = has_tabline and 1 or 0
	cfg.width = 35
	cfg.height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0)
	cfg.border = "none"
	vim.api.nvim_win_set_config(win_id, cfg)
end

vim.api.nvim_create_autocmd("User", {
	pattern = { "MiniFilesWindowOpen", "MiniFilesWindowUpdate" },
	callback = function(args)
		place_right(args.data.win_id)
	end,
})

vim.keymap.set("n", "<leader>e", function()
	if MiniFiles.close() == nil then
		MiniFiles.open()
	end
end, { silent = true, desc = "Explorer (right side)" })