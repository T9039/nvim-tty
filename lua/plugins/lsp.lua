return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "gopls",
          "clangd",
          "bashls",
          "jsonls",
          "yamlls",
          "taplo",
          "marksman",
          "lemminx",
          "dockerls",
          "sqls",
          "tsserver",
          "eslint",
          "cssls",
          "html",
          "jdtls",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        "lua_ls", "pyright", "rust_analyzer", "gopls",
        "clangd", "bashls", "jsonls", "yamlls", "taplo",
        "marksman", "lemminx", "dockerls", "sqls",
        "tsserver", "eslint", "cssls", "html", "jdtls",
      }

      for _, server in ipairs(servers) do
        local ok, _ = pcall(lspconfig[server].setup, {
          capabilities = capabilities,
        })
        if not ok then
          vim.notify("LSP server '" .. server .. "' not available", vim.log.levels.WARN)
        end
      end
    end,
  },
}
