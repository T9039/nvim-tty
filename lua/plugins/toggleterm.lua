return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 12,
      open_mapping = [[<C-\>]],
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
    })
  end,
}
