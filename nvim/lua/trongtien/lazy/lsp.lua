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

local ts_inlay_hints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
    "j-hui/fidget.nvim",
  },

  config = function()
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities {
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
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
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
        typescript = { inlayHints = ts_inlay_hints },
        javascript = { inlayHints = ts_inlay_hints },
      },
    })

    require("fidget").setup {}
    require("mason").setup()
    require("mason-lspconfig").setup {
      ensure_installed = servers,
      automatic_enable = false,
    }
    vim.lsp.enable(servers)

    vim.diagnostic.config {
      -- nvim 0.11+ hides diagnostic messages at the end of the line by default
      virtual_text = { prefix = "\u{f445}" },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    }
  end,
}
