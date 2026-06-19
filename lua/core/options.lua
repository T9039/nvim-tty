local env = require("core.env")
local sym = require("core.symbols")

vim.g.mapleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.wrap           = false
vim.opt.mouse          = "a"
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.clipboard      = "unnamedplus"
vim.opt.signcolumn     = "yes"
vim.opt.updatetime     = 300
vim.opt.timeoutlen     = 500
vim.opt.completeopt    = "menuone,noselect"
vim.opt.cursorline     = true
vim.opt.scrolloff      = 4
vim.opt.sidescrolloff  = 8
vim.opt.undofile       = true
vim.opt.hlsearch       = false
vim.opt.incsearch      = true
vim.opt.showmode       = false
vim.opt.shortmess:append("sI")

vim.opt.fillchars:append({
  eob      = " ",
  foldopen = sym.tab,
  foldclose = sym.tab,
  horiz    = sym.tab,
  horizup  = sym.tab,
  horizdown = sym.tab,
  vert     = "|",
  vertleft = "|",
  vertright = "|",
})

if not env.has_24bit then
  vim.opt.termguicolors = false
  vim.opt.pumblend = 0
  vim.opt.winblend = 0
end
