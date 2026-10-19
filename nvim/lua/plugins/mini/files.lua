require('mini.files').setup({
  content = { filter = nil, highlight = nil, prefix = nil, sort = nil },
  mappings = { close = 'q', go_in = 'l', go_out = 'h' },
  options = { permanent_delete = true, use_as_default_explorer = true },
  windows = { max_number = math.huge, preview = false, width_focus = 50 }
})


vim.keymap.set("n", "<leader>e", function()
		MiniFiles.open()
end, { silent = true, desc = "Explorer (right side)" })
