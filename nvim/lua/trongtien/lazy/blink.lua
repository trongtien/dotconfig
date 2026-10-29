return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
  },
  opts = {
    snippets = { preset = "luasnip" },
    cmdline = { enabled = true },
    appearance = { nerd_font_variant = "mono" },
    fuzzy = { implementation = "prefer_rust" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },

    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },

    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = {
        scrollbar = false,
        border = "single",
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
  },
}
