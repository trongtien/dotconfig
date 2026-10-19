local map = vim.keymap

-- Save and quit current file quicker
map.set("n", "<leader>w", ":w<cr>", { silent = true, noremap = true, desc = "Save current file" })
map.set("n", "<C-s>", ":w<cr>", { silent = true, noremap = true, desc = "Save current file" })


map.set({ "n", "t" }, "<leader>q", ":q<cr>", { silent = true, noremap = true, desc = "Quit current buffer" })
map.set("n", "<leader>d", "<C-w>d", { remap = true, desc = "Show diagnostic float" })

-- Navigate through buffers
map.set("n", "<S-l>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
map.set("n", "<S-h>", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- Close currently active buffer
map.set("n", "<C-c>", ":bwipeout<CR>", { silent = true, desc = "Close current buffer" })

-- Paste without replacing paste with what you have highlighted over
map.set("n", "<leader>p", '"_dP', { desc = "Paste without replacing register" })

-- Yank to system clipboard
map.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map.set("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
map.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Open buffer to the right
map.set("n", "<leader>sv", ":vsplit<CR>", { silent = true, desc = "Vertical split" })

-- Disable Space bar since it will be used as the leader key
map.set({ "n", "v" }, "<leader>", "<nop>", { desc = "Disable leader key default" })

map.set("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
map.set("i", "<C-l>", "<Right>", { desc = "Move cursor right" })

-- Swap between split buffers (cross tmux panes at edge)
local navigate_split = function(dir)
	local cur = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. dir)
	if vim.api.nvim_get_current_win() == cur and vim.env.TMUX ~= nil then
		vim.fn.system("tmux select-pane -" .. dir)
	end
end
map.set("n", "<C-h>", function()
	navigate_split("h")
end, { silent = true, desc = "Left split / tmux pane" })
map.set("n", "<C-j>", function()
	navigate_split("j")
end, { silent = true, desc = "Below split / tmux pane" })
map.set("n", "<C-k>", function()
	navigate_split("k")
end, { silent = true, desc = "Above split / tmux pane" })
map.set("n", "<C-l>", function()
	navigate_split("l")
end, { silent = true, desc = "Right split / tmux pane" })

map.set("n", "<leader>rr", ":wincmd r<CR>", { silent = true, desc = "Rotate split buffers" })
map.set("n", "<leader>re", ":restart<CR>", { silent = true, desc = "Restart Neovim" })

-- Resize splits: mỗi lần nhấn thay đổi 5 dòng/cột (mặc định là 1)
map.set("n", "<C-w>+", "5<C-w>+", { silent = true, desc = "Increase split height +5" })
map.set("n", "<C-w>-", "5<C-w>-", { silent = true, desc = "Decrease split height -5" })
map.set("n", "<C-w><", "5<C-w><", { silent = true, desc = "Decrease split width -5" })
map.set("n", "<C-w>>", "5<C-w>>", { silent = true, desc = "Increase split width +5" })

-- Move selection up and down
map.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
