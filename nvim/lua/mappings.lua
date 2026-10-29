require "nvchad.mappings"
require "lsp_mapping"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<C-f>", ":/", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Search map
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")


map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
map("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

-- Buffer
map("n", "<S-l>", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer next" })
map("n", "<S-h>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer prev" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer new" })
map("n", "<leader>bq", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })
map("n", "<leader>ba", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "Buffer close all" })

-- Save / Quit all
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>wa", "<cmd>wa<CR>", { desc = "Save all" })
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all force" })

