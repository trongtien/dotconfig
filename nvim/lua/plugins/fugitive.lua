-- vim-fugitive: Git commands trong nvim
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { silent = true, desc = "Git status (fugitive)" })

vim.keymap.set("n", "<leader>p", function()
	vim.cmd.Git("push")
end, { silent = true, desc = "Git push" })

-- Trong diff: gu lay //2 (trai), gh lay //3 (phai)
vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { silent = true, desc = "Diffget //2" })
vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { silent = true, desc = "Diffget //3" })

-- Nhap tiep ten branch: <leader>t -> :Git push -u origin | go ten branch + Enter
vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { silent = true, desc = "Git push -u origin <branch>" })
