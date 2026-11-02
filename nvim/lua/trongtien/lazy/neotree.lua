return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>vv", "<cmd>Neotree toggle<CR>", desc = "Toggle neo-tree" },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    window = {
      mappings = {
        ["<space>"] = "none",
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    filesystem = {
      -- oil stays the directory handler for `nvim <dir>` and :e <dir>
      hijack_netrw_behavior = "disabled",
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = { ".git" },
      },
    },
  },
}
