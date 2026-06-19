-- Terminal capability (needs to run before termguicolors)
local env = require("core.env")
vim.opt.termguicolors = env.has_24bit

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.fn.isdirectory(lazypath) then
  local git_ok = vim.fn.executable("git") == 1
  if not git_ok then
    vim.api.nvim_err_writeln(
      "nvim-tty: 'git' not found. Install git (sudo apt install git)"
        .. " then restart nvim."
    )
    return
  end
  local ret = vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln(
      "nvim-tty: Failed to clone lazy.nvim. Check internet.\n" .. ret
    )
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Core settings (no plugin dependencies)
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Plugins via lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = false },
})

-- Startup message
vim.schedule(function()
  print(
    "nvim-tty loaded"
      .. " | " .. (env.has_24bit and "24-bit color" or "16/256 color")
      .. " | Icons: " .. (env.use_icons and "on" or "off")
      .. " | :Mason to install LSPs"
  )
end)
