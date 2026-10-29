return {
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- blink.cmp (thay nvim-cmp)
  { import = "nvchad.blink.lazyspec" },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        list = {
          selection = { preselect = false, auto_insert = false },
        },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
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
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "gopls",
        "lua-language-server",
        "typescript-language-server",
        "pyright",
        "clangd",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "bash-language-server",
        "tailwindcss-language-server",
        "eslint-lsp",
        -- Formatters
        "gofumpt",
        "goimports",
        "stylua",
        "prettierd",
      },
    },
  },

  -- fzf fuzzy finder
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
    },
  },

  -- file explorer
  {
    "stevearc/oil.nvim",
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
  },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
    config = function(_, opts)
      require("gitsigns").setup(opts)

      local gs = require "gitsigns"
      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Next hunk" })

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Prev hunk" })

      vim.keymap.set("n", "<leader>gP", gs.preview_hunk, { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>gB", function()
        gs.blame_line { full = true }
      end, { desc = "Blame line" })
    end,
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "Gclog" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff" },
      { "<leader>gl", "<cmd>Gclog<CR>", desc = "Git log" },
      { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
    },
  },
}
