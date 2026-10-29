-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "tundra",
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
  integrations = { "cmp" },
}

M.ui = {
  cmp = {
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = true, -- TailwindCSS color in cmp
      lsp = true,
    },
  },
  telescope = { style = "borderless" },
  statusline = {
    theme = "default",
    separator_style = "default",
  },
  tabufline = {
    lazyload = true,
  },
}

M.nvdash = { load_on_startup = true }

M.term = {
  winopts = { number = false },
  sizes = { sp = 0.3, vsp = 0.2 },
  float = {
    relative = "editor",
    row = 0.3,
    col = 0.25,
    width = 0.5,
    height = 0.4,
    border = "single",
  },
}

-- Auto signature help khi trong function
M.lsp = {
  signature = true,
}

-- Colorify: hiện màu hex + LSP vars (tailwind, css...)
M.colorify = {
  enabled = true,
  mode = "virtual",
  virt_text = "󱓻 ",
  highlight = { hex = true, lspvars = true },
}

-- Theme picker hiện đại (volt)
M.themepicker = {
  style = "bordered",
}

-- Mason pkgs bổ sung ngoài auto-detect từ lspconfig/conform
M.mason = {
  pkgs = {
    "tailwindcss-language-server",
    "eslint-lsp",
  },
}

M.cheatsheet = {
  theme = "grid",
}

return M
