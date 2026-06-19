-- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Auto-resize splits
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("AutoResize", { clear = true }),
  command = "tabdo wincmd =",
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.fn.line("$") then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Trim trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- LSP format on save
local format_group = vim.api.nvim_create_augroup("LspFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_group,
  pattern = { "*.lua", "*.py", "*.go", "*.rs", "*.c", "*.cpp", "*.ts", "*.js" },
  callback = function()
    vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
  end,
})

-- User command: show active LSP clients
vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print("No active LSP clients")
    return
  end
  for _, c in ipairs(clients) do
    print(c.name .. " (" .. c.id .. ") — " .. (c.config.cmd and table.concat(c.config.cmd, " ") or "?"))
  end
end, { desc = "Show active LSP clients" })
