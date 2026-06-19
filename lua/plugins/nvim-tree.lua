local sym = require("core.symbols")

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
  },
  config = function()
    require("nvim-tree").setup({
      disable_netrw = true,
      hijack_netrw = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      renderer = {
        icons = {
          glyphs = {
            default = sym.dot,
            symlink = sym.arrow,
            bookmark = sym.check,
            folder = {
              arrow_open = sym.tab,
              arrow_closed = sym.tab,
              default = sym.dot,
              open = sym.dot,
              empty = sym.dot,
              empty_open = sym.dot,
              symlink = sym.arrow,
              symlink_open = sym.arrow,
            },
            git = {
              unstaged = sym.git_mod,
              staged = sym.git_add,
              unmerged = sym.diag_warn,
              renamed = sym.arrow,
              untracked = "?",
              deleted = sym.git_del,
              ignored = sym.ellipsis,
            },
          },
          show = {
            file = false,
            folder = false,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { "node_modules", ".git" },
      },
      git = {
        enable = true,
        ignore = false,
      },
      view = {
        width = 30,
      },
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
      pattern = "NvimTree_*",
      callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})
        if layout[1] == "leaf"
          and vim.api.nvim_buf_get_option(0, "filetype") == "NvimTree" then
          vim.cmd("quit")
        end
      end,
    })
  end,
}
