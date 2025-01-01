
return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "clangd", -- C
        "lua_ls", -- Lua
        "pyright", -- Python
        "jedi_language_server" -- Python alternative
      },
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- C: clangd setup
      require("lspconfig").clangd.setup({
        capabilities = capabilities,
      })

      -- Lua: lua-language-server setup
      require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT", -- Lua runtime
            },
            diagnostics = {
              globals = { "vim" }, -- Recognize Neovim's global `vim`
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Python: pyright setup with type-checking disabled
      require("lspconfig").pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off", -- Disable type-checking
              diagnosticMode = "workspace", -- Limit diagnostics to workspace
              useLibraryCodeForTypes = false,
            },
          },
        },
      })

      -- Python alternative: jedi_language_server setup with diagnostics disabled
      require("lspconfig").jedi_language_server.setup({
        capabilities = capabilities,
        init_options = {
          diagnostics = {
            enable = false, -- Disable diagnostics entirely
          },
        },
      })
    end,
  },
}
