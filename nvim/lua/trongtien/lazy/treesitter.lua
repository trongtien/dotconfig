return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      parsers = {
        "vim",
        "lua",
        "vimdoc",
        "query",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "bash",
        "python",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "cpp",
        "c",
        "regex",
        "diff",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
      },
    },
    config = function(_, opts)
      local group = vim.api.nvim_create_augroup("TrongtienTreesitter", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
        group = group,
        callback = function()
          if vim.bo.buftype ~= "" then
            return
          end

          pcall(vim.treesitter.start, 0)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "VeryLazy",
        once = true,
        callback = function()
          require("nvim-treesitter").install(opts.parsers)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
        },
      }

      local select = require "nvim-treesitter-textobjects.select"
      vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end)
    end,
  },
}
