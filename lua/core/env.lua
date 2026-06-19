local env = {}

env.has_24bit = vim.env.COLORTERM == "truecolor"
  or vim.env.COLORTERM == "24bit"
  or vim.fn.has("termguicolors") == 1

env.is_linux_tty = vim.env.TERM == "linux"
env.use_icons = not env.is_linux_tty and env.has_24bit

return env
