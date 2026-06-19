# nvim-tty — Headless server Neovim config

A self-contained Neovim config for Pi 4's, VPS boxes, and any headless server.
All UI elements use ASCII text — zero Nerd Font or GUI glyph dependencies.
Built-in terminal detection disables 24-bit color automatically on the Linux
framebuffer console (`TERM=linux`).

## Features

| Feature | Details |
|---|---|
| LSP support | 20+ language servers via Mason (auto-installs) |
| Autocompletion | nvim-cmp with snippets, buffer, path sources |
| Syntax highlighting | Treesitter with 25+ language parsers |
| Fuzzy finding | Telescope with fzf-native (files, grep, buffers, help, diagnostics) |
| Statusline | lualine with LSP/diagnostics/git-branch sections |
| File explorer | nvim-tree (no-icon mode) |
| Terminal | toggleterm, toggle with `<C-\>` |
| Format on save | Enabled for lua, py, go, rs, c, cpp, ts, js |

## Prerequisites

### System packages (Debian / Raspberry Pi OS)

```bash
sudo apt update
sudo apt install -y neovim git curl unzip gcc make ripgrep fd-find \
  nodejs npm python3 python3-pip golang-go
```

### Optional: Rust (for rust-analyzer)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Quick install

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USER/nvim-tty.git ~/.config/nvim

# 2. Launch Neovim — plugins + parsers install automatically
nvim

# 3. Install LSP servers from Mason
:Mason        # opens the GUI — press `i` on any server to install
:MasonInstall lua_ls pyright bashls jsonls yamlls taplo marksman
```

## Step-by-step

### 1. System dependencies

Install the packages listed under Prerequisites above. If you're on a minimal
server (like Alpine or Arch), adapt the package names accordingly:

| Distro | Command |
|---|---|
| Debian / Ubuntu / Raspberry Pi OS | `apt install` |
| Arch / Manjaro | `pacman -S` |
| Alpine | `apk add` |
| Fedora | `dnf install` |

### 2. Place the config

Clone directly into Neovim's config directory:

```bash
git clone https://github.com/YOUR_USER/nvim-tty.git ~/.config/nvim
```

Or if you already have an existing config and want to try this alongside it:

```bash
git clone https://github.com/YOUR_USER/nvim-tty.git ~/nvim-tty
alias nvim-tty='nvim -u ~/nvim-tty/nvim-tty.lua'   # add to ~/.bashrc
```

### 3. First launch

```bash
nvim
```

On first run:
1. **lazy.nvim** bootstraps itself and installs all plugins (~30s)
2. **Treesitter** auto-installs language parsers for syntax highlighting
3. **Mason** prompts you to install LSP servers — press `q` to close, or
   install what you need with `:MasonInstall <server>`

### 4. Verify everything

| Check | Command | Expected |
|---|---|---|
| LSP is working | Open a `.py` file, then `:LspInfo` | Shows `pyright` as active |
| Telescope | `<leader>ff` | File picker opens |
| Treesitter | `:TSModuleInfo` | Parsers show `✓` |
| Statusline | Normal mode | Shows mode, branch, diagnostics, LSP names |
| jk escape | Press `jk` in insert mode | Returns to normal mode |
| Terminal | `<C-\>` | Toggle terminal opens/closes |

### 5. Install more LSP servers

Inside Neovim:

```bash
:Mason
```

Navigate with `j`/`k`, press `i` to install, `d` to uninstall, `q` to quit.
Servers pre-configured in the config:

`lua_ls` `pyright` `rust_analyzer` `gopls` `clangd` `bashls` `jsonls`
`yamlls` `taplo` `marksman` `lemminx` `dockerls` `sqls` `tsserver`
`eslint` `cssls` `html` `jdtls`

## Key bindings

| Key | Action |
|---|---|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Switch buffer |
| `<leader>fh` | Search help |
| `<leader>td` | Show diagnostics |
| `<leader>e` | Toggle file tree |
| `gd` / `gD` | Go to definition / declaration |
| `gr` / `gi` | Find references / implementation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `K` | Hover documentation |
| `[d` / `]d` | Previous / next diagnostic |
| `jk` or `kj` (quickly) | Escape insert/visual mode |
| `<C-\>` | Toggle terminal |

## Customization

The config is a single `nvim-tty.lua` file. Edit it directly — all sections
are labeled with comment headers:

- `4. Core editor options` — tabs, wrapping, mouse, etc.
- `5. Keymaps` — add or change bindings here
- `6. Plugins` — add or remove plugins from lazy.nvim's setup
- `7. Miscellaneous improvements` — autocmds for format, trim, etc.

## TTY compatibility notes

- On the Linux framebuffer console (Ctrl+Alt+F1–F6), `TERM=linux` is
  detected and 24-bit color + icons are disabled automatically.
- Over SSH from a modern terminal (kitty, Alacritty, iTerm2, etc.),
  `COLORTERM=truecolor` is detected and true color is enabled.
- All glyphs are plain ASCII — no patched fonts required anywhere.
