vim.g.mapleader = " "

local map = vim.keymap.set

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "=ap", "ma=ap'a")
map("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- greatest remap ever
map("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map({ "n", "v" }, "<leader>d", [["_d]])

map("i", "<C-c>", "<Esc>")
map("i", "jk", "<Esc>")
map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "Q", "<nop>")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
map("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

map("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
map("n", "<leader>ea", [[oassert.NoError(err, "")<Esc>F";a]])
map("n", "<leader>ef", [[oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\n", err.Error())<Esc>jj]])
map("n", "<leader>el", [[oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i]])

map("n", "<leader><leader>", function()
  vim.cmd "so"
end)

-- Buffer
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Buffer next" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer prev" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer new" })
map("n", "<leader>bq", "<cmd>bdelete<CR>", { desc = "Buffer close" })
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Buffer close" })
map("n", "<leader>ba", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      pcall(vim.cmd.bdelete, buf)
    end
  end
end, { desc = "Buffer close all" })

-- Save / Quit all
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>wa", "<cmd>wa<CR>", { desc = "Save all" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all force" })
