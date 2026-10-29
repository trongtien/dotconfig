require("nvchad.configs.lspconfig").defaults()

local servers = {
  "gopls", -- Go
  "lua_ls", -- Lua
  "ts_ls", -- TypeScript/JavaScript/TSX
  "pyright", -- Python
  "clangd", -- C/C++
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "bashls",
  "tailwindcss", -- Tailwind CSS
  "eslint", -- ESLint (JS/TS)
}

vim.lsp.config("*", {
  capabilities = {
    workspace = {
      fileOperations = { didRename = true, willRename = true },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        unusedparams = true,
        nilness = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } },
    },
  },
})

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = { "class", "className", "class:list", "classList" },
      includeLanguages = {
        eex = "html-eex",
        elixir = "html-eex",
        heex = "html-eex",
        htmlangular = "html",
        htmlerb = "html-eex",
        templ = "html",
      },
    },
  },
})

vim.lsp.config("eslint", {
  settings = {
    codeAction = {
      disableRuleComment = { enable = true, location = "inline" },
      showDocumentation = { enable = true },
    },
    codeActionOnSave = { enable = false, mode = "" },
    experimental = { useFlatConfig = false },
    format = true,
    nodePath = "",
    onIgnoredFiles = "off",
    problems = { shortenToSingleLine = false },
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = { mode = "auto" },
  },
})

vim.lsp.config("cssls", {
  settings = {
    css = { validate = true, lint = { unknownAtRules = "ignore" } },
    scss = { validate = true },
    less = { validate = true },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      validate = { enable = true },
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
      },
    },
  },
})

vim.lsp.config("ts_ls", {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

vim.lsp.enable(servers)

