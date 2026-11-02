return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- loaded at startup so `nvim <dir>` opens oil instead of netrw
  lazy = false,
  opts = {
    default_file_explorer = true,
    float = {
      padding = 2,
      max_width = 90,
      max_height = 0.9,
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    -- oil only closes the float for its own select; a file opened from inside it
    -- (telescope, harpoon, gf, :e) moves to the window oil was opened from
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = vim.api.nvim_create_augroup("OilFloatOpenFile", {}),
      callback = function(args)
        local float = vim.api.nvim_get_current_win()
        if not vim.w[float].is_oil_win or vim.bo[args.buf].buftype ~= "" then
          return
        end
        vim.schedule(function()
          if not vim.api.nvim_win_is_valid(float) then
            return
          end
          local target = vim.w[float].oil_original_win
          if not (target and vim.api.nvim_win_is_valid(target)) then
            target = vim.fn.win_getid(1)
          end
          local cursor = vim.api.nvim_win_get_cursor(float)
          vim.api.nvim_win_set_buf(target, args.buf)
          vim.api.nvim_win_set_cursor(target, cursor)
          vim.api.nvim_win_close(float, true)
          vim.api.nvim_set_current_win(target)
        end)
      end,
    })
  end,
  keys = {
    { "<leader>pv", "<cmd>Oil --float<CR>", desc = "Open oil (floating)" },
  },
}
