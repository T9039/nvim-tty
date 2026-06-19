local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>", opts)
map("n", "<leader>Q", "<cmd>qa!<CR>", opts)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
map("n", "<leader>td", "<cmd>Telescope diagnostics<CR>", opts)

-- LSP
map("n", "<leader>gd", vim.lsp.buf.definition, opts)
map("n", "<leader>gD", vim.lsp.buf.declaration, opts)
map("n", "<leader>gi", vim.lsp.buf.implementation, opts)
map("n", "<leader>gr", vim.lsp.buf.references, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>K", vim.lsp.buf.hover, opts)
map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Terminal mode
map("t", "<Esc>", [[<C-\><C-n>]], opts)
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

-- jk / kj escape (insert + visual)
map({ "i", "v" }, "jk", "<Esc>", { desc = "jk -> <Esc>" })
map({ "i", "v" }, "kj", "<Esc>", { desc = "kj -> <Esc>" })
