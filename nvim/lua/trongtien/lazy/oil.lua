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
  keys = {
    { "<leader>pv", "<cmd>Oil --float<CR>", desc = "Open oil (floating)" },
  },
}
