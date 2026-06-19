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
| Leader key | `<Space>` (not backslash) |

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

Or to try it alongside an existing config:

```bash
git clone https://github.com/YOUR_USER/nvim-tty.git ~/nvim-tty
alias nvim-tty='nvim -u ~/nvim-tty/init.lua'   # add to ~/.bashrc
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
|---|---|---|
| `<Space>ff` | Find files (Telescope) |
| `<Space>fg` | Live grep |
| `<Space>fb` | Switch buffer |
| `<Space>fh` | Search help |
| `<Space>td` | Show diagnostics |
| `<Space>e` | Toggle file tree |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `gd` / `gD` | Go to definition / declaration |
| `gr` / `gi` | Find references / implementation |
| `<Space>rn` | Rename symbol |
| `<Space>ca` | Code action |
| `K` | Hover documentation |
| `[d` / `]d` | Previous / next diagnostic |
| `jk` or `kj` (quickly) | Escape insert/visual mode |
| `<C-\>` | Toggle terminal |

## Customization

The config is split into modules under `lua/`:

```
init.lua               Entry point, bootstrap, loads everything
lua/
├── core/
│   ├── env.lua        Terminal capability detection
│   ├── symbols.lua    ASCII text symbols (no Nerd Font)
│   ├── options.lua    Editor options & netrw disable
│   ├── keymaps.lua    All keybindings
│   └── autocmds.lua   Autocommands & user commands
└── plugins/
    ├── colorscheme.lua
    ├── treesitter.lua
    ├── lsp.lua         Mason + lspconfig
    ├── cmp.lua         Autocompletion
    ├── telescope.lua   Fuzzy finder
    ├── lualine.lua     Statusline
    ├── nvim-tree.lua   File explorer
    └── toggleterm.lua  Terminal
```

Edit any module directly — lazy.nvim picks up changes on restart.

## TTY compatibility notes

- On the Linux framebuffer console (Ctrl+Alt+F1–F6), `TERM=linux` is
  detected and 24-bit color + icons are disabled automatically.
- Over SSH from a modern terminal (kitty, Alacritty, iTerm2, etc.),
  `COLORTERM=truecolor` is detected and true color is enabled.
- All glyphs are plain ASCII — no patched fonts required anywhere.
