--[[
  Neovim config for headless/TTY environments (Pi 4, servers, etc.)
  All icons are ASCII-safe — no Nerd Font or GUI dependencies.
  Drop this into ~/.config/nvim/init.lua on the target machine.
--]]

-- ──────────────────────────────────────────────────────────
-- 1. Terminal capability detection
-- ──────────────────────────────────────────────────────────
local function has_24bit_color()
	return vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" or vim.fn.has("termguicolors") == 1
end

local function is_linux_tty()
	return vim.env.TERM == "linux"
end

local use_24bit = has_24bit_color()
local use_icons = not is_linux_tty() and use_24bit -- only icons if we have color + decent term

vim.opt.termguicolors = use_24bit

-- ──────────────────────────────────────────────────────────
-- 2. Bootstrap lazy.nvim
-- ──────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.fn.isdirectory(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ──────────────────────────────────────────────────────────
-- 3. Text-based symbols (no Nerd Font needed)
-- ──────────────────────────────────────────────────────────
local sym = {
	sep = " ",
	lsp = "LSP",
	lsp_ok = "[ok]",
	lsp_err = "[err]",
	diag_err = "X",
	diag_warn = "!",
	diag_info = "i",
	diag_hint = "?",
	git_add = "+",
	git_mod = "~",
	git_del = "-",
	branch = "git:",
	search = "/",
	ellipsis = "...",
	tab = ">",
	check = "[+]",
	dot = ".",
	arrow = "->",
}

-- ──────────────────────────────────────────────────────────
-- 4. Core editor options
-- ──────────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.completeopt = "menuone,noselect"
vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.showmode = false -- we show mode in statusline
vim.opt.shortmess:append("sI") -- no intro message
vim.opt.fillchars:append({
	eob = " ",
	foldopen = sym.tab,
	foldclose = sym.tab,
	horiz = sym.tab,
	horizup = sym.tab,
	horizdown = sym.tab,
	vert = "|",
	vertleft = "|",
	vertright = "|",
})

if not use_24bit then
	vim.opt.termguicolors = false
	vim.opt.pumblend = 0
	vim.opt.winblend = 0
end

-- ──────────────────────────────────────────────────────────
-- 5. Keymaps
-- ──────────────────────────────────────────────────────────
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>", opts)
map("n", "<leader>Q", "<cmd>qa!<CR>", opts)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
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
map("n", "<leader>td", "<cmd>Telescope diagnostics<CR>", opts)

-- Better navigation in terminal mode
map("t", "<Esc>", [[<C-\><C-n>]], opts)
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Escape via jk / kj (insert + visual modes, uses timeoutlen)
map({ "i", "v" }, "jk", "<Esc>", { desc = "jk -> <Esc>" })
map({ "i", "v" }, "kj", "<Esc>", { desc = "kj -> <Esc>" })

-- ──────────────────────────────────────────────────────────
-- 6. Plugins
-- ──────────────────────────────────────────────────────────
require("lazy").setup({
	-- Colorscheme: gruvbox (excellent 256-color TTY support)
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
				terminal_colors = true,
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},

	-- Treesitter (syntax highlighting)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"query",
					"c",
					"cpp",
					"rust",
					"go",
					"python",
					"bash",
					"fish",
					"json",
					"yaml",
					"toml",
					"markdown",
					"markdown_inline",
					"html",
					"css",
					"javascript",
					"typescript",
					"sql",
					"regex",
					"diff",
					"gitignore",
					"make",
					"dockerfile",
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
	},

	-- LSP installer & manager
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	-- LSP config bridge
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- Languages common on a server / Pi
					"lua_ls", -- Lua
					"pyright", -- Python
					"rust_analyzer", -- Rust
					"gopls", -- Go
					"clangd", -- C / C++
					"bashls", -- Bash
					"jsonls", -- JSON
					"yamlls", -- YAML
					"taplo", -- TOML
					"marksman", -- Markdown
					"lemminx", -- XML
					"dockerls", -- Dockerfile
					"sqls", -- SQL
					"tsserver", -- TypeScript / JavaScript
					"eslint", -- Linting
					"cssls", -- CSS
					"html", -- HTML
					"jdtls", -- Java
				},
				automatic_installation = true,
			})
		end,
	},

	-- LSP configuration + keymaps
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			end

			local servers = {
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
			}

			for _, server in ipairs(servers) do
				local ok, _ = pcall(lspconfig[server].setup, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
				if not ok then
					vim.notify("LSP server '" .. server .. "' not available", vim.log.levels.WARN)
				end
			end

			-- LSP progress handler
			vim.api.nvim_create_autocmd("LspProgress", {
				callback = function(ev)
					local msg = vim.lsp.status()
					if msg and msg ~= "" then
						vim.notify(msg, vim.log.levels.INFO, { title = "LSP" })
					end
				end,
			})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					-- No icon fields — uses plain text labels
					format = function(entry, vim_item)
						local kind = vim_item.kind or ""
						vim_item.menu = ({
							nvim_lsp = sym.lsp,
							luasnip = "snip",
							buffer = "buf",
							path = "path",
							cmdline = "cmd",
						})[entry.source.name] or ""
						return vim_item
					end,
				},
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	-- Statusline (TTY-safe, no icons)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true }, -- won't load if no icons
		config = function()
			local function lsp_status()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients == 0 then
					return "none"
				end
				local names = {}
				for _, c in ipairs(clients) do
					table.insert(names, c.name)
				end
				return sym.lsp .. " " .. sym.check .. " " .. table.concat(names, ",")
			end

			local function diagnostics_count()
				local counts = vim.diagnostic.count(0)
				local parts = {}
				if counts[1] and counts[1] > 0 then
					table.insert(parts, sym.diag_err .. " " .. counts[1])
				end
				if counts[2] and counts[2] > 0 then
					table.insert(parts, sym.diag_warn .. " " .. counts[2])
				end
				if counts[3] and counts[3] > 0 then
					table.insert(parts, sym.diag_info .. " " .. counts[3])
				end
				if counts[4] and counts[4] > 0 then
					table.insert(parts, sym.diag_hint .. " " .. counts[4])
				end
				if #parts > 0 then
					return "[ " .. table.concat(parts, " ") .. " ]"
				end
				return ""
			end

			local function branch_name()
				local ok, out = pcall(vim.fn.system, "git branch --show-current 2>/dev/null")
				if ok and out and out ~= "" then
					return sym.branch .. " " .. vim.trim(out)
				end
				return ""
			end

			require("lualine").setup({
				options = {
					theme = "gruvbox",
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "NvimTree", "TelescopePrompt" },
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { branch_name, "diff" },
					lualine_c = {
						{ "filename", path = 1 },
					},
					lualine_x = {
						diagnostics_count,
						lsp_status,
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- File explorer (tree view, no-icon mode)
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
		keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" } },
		config = function()
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_netrw = true,
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				renderer = {
					-- No Nerd Font icons — use ASCII
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

			-- Auto-close nvim-tree when it's the last window
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
				pattern = "NvimTree_*",
				callback = function()
					local layout = vim.api.nvim_call_function("winlayout", {})
					if layout[1] == "leaf" and vim.api.nvim_buf_get_option(0, "filetype") == "NvimTree" then
						vim.cmd("quit")
					end
				end,
			})
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			{ "<leader>ff", desc = "Find files" },
			{ "<leader>fg", desc = "Live grep" },
			{ "<leader>fb", desc = "Buffers" },
			{ "<leader>fh", desc = "Help tags" },
			{ "<leader>td", desc = "Diagnostics" },
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
	},

	-- Better terminal integration
	{
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
	},
})

-- ──────────────────────────────────────────────────────────
-- 7. Miscellaneous improvements
-- ──────────────────────────────────────────────────────────

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Auto-resize splits on focus
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

-- Trim whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
	pattern = "*",
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- LSP format on save (opt-in per filetype)
local format_augroup = vim.api.nvim_create_augroup("LspFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_augroup,
	pattern = { "*.lua", "*.py", "*.go", "*.rs", "*.c", "*.cpp", "*.ts", "*.js" },
	callback = function()
		vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
	end,
})

-- ──────────────────────────────────────────────────────────
-- 8. Commands for quick LSP info / Mason management
-- ──────────────────────────────────────────────────────────
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

-- ──────────────────────────────────────────────────────────
-- 9. Final messages
-- ──────────────────────────────────────────────────────────
vim.schedule(function()
	print(
		"Neovim TTY config loaded. "
			.. (use_24bit and "24-bit color: yes" or "24-bit color: no")
			.. " | Icons: "
			.. (use_icons and "enabled" or "disabled")
			.. " | Run :Mason to install LSP servers"
	)
end)
