return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "c", "cpp", "rust", "go",
        "python", "bash", "fish",
        "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "html", "css", "javascript", "typescript",
        "sql", "regex", "diff",
        "gitignore", "make", "dockerfile",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<TAB>",
          node_decremental = "<S-TAB>",
        },
      },
    })
  end,
}
