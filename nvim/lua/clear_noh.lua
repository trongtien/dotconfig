-- TODO: Clean all close 
vim.keymap.set("n", "<Esc>", function()
	vim.cmd.nohlsearch()
  MiniFiles.close()

	-- vim.api.nvim_buf_clear_namespace(0, multicursor_ns, 0, -1)
end, { desc = "Clear search highligts & multicursors" })
