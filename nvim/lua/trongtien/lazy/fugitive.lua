return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
    vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
    vim.keymap.set("n", "<leader>gl", "<cmd>Gclog<CR>", { desc = "Git log" })
    vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })

    local Trongtien_Fugitive = vim.api.nvim_create_augroup("Trongtien_Fugitive", {})

    local autocmd = vim.api.nvim_create_autocmd
    autocmd("BufWinEnter", {
      group = Trongtien_Fugitive,
      pattern = "*",
      callback = function()
        if vim.bo.ft ~= "fugitive" then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>p", function()
          vim.cmd.Git "push"
        end, opts)

        -- rebase always
        vim.keymap.set("n", "<leader>P", function()
          vim.cmd.Git { "pull", "--rebase" }
        end, opts)

        -- set the branch to push and its tracking when it is not set up yet
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
      end,
    })

    vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
    vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
  end,
}
