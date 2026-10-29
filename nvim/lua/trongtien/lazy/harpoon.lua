return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require "harpoon"

    harpoon:setup()

    vim.keymap.set("n", "<leader>A", function()
      harpoon:list():prepend()
    end)
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end)
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    -- Alt+1..9 belong to tmux (select window), so files 1..4 are on <leader>1..4
    for i = 1, 4 do
      vim.keymap.set("n", "<leader>" .. i, function()
        harpoon:list():select(i)
      end)
    end
  end,
}
