return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gs = require "gitsigns"
    gs.setup {}

    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.nav_hunk "next"
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.nav_hunk "prev"
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Prev hunk" })

    vim.keymap.set("n", "<leader>gP", gs.preview_hunk, { desc = "Preview hunk" })
    vim.keymap.set("n", "<leader>gB", function()
      gs.blame_line { full = true }
    end, { desc = "Blame line" })
  end,
}
