local sym = require("core.symbols")

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        prompt_prefix = sym.search .. " ",
        selection_caret = sym.arrow .. " ",
        path_display = { "smart" },
        layout_config = {
          horizontal = { preview_width = 0.5 },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
