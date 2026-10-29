# Arch WSL Dotfiles

All shell config lives under `~/.config`:

```
~/.config/
├── bash/
│   └── bashrc          # starship loader (sourced by ~/.bashrc shim)
├── starship.toml       # prompt: → dir git:(branch), plain & fast
├── tmux/
│   ├── tmux.conf       # prefix C-a, rose-pine theme, status bar bottom
│   └── plugins/        # TPM + plugins (gitignored)
├── tmux-sessionizer/
│   └── tmux-sessionizer.conf  # search paths + session commands
├── nvim/               # ThePrimeagen/init.lua layout: lua/trongtien/{set,remap,lazy/*}
└── README.md
~/.bashrc               # tiny shim -> ~/.config/bash/bashrc
~/.bash_profile         # login shells -> ~/.bashrc (WSL needs this)
~/.local/bin/tmux-sessionizer  # ThePrimeagen/tmux-sessionizer @7edf821 (install.sh)
```


## Install

### 1. Packages (Arch)

```sh
sudo pacman -S --needed starship tmux fzf git
```

### 2. Apply configs

Copy `.config` tree to `~/.config`, then shims:

```sh
echo '[ -f "$HOME/.config/bash/bashrc" ] && . "$HOME/.config/bash/bashrc"' > ~/.bashrc
echo '[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"' > ~/.bash_profile
```

Reload: open a new tab (or `source ~/.bashrc`).

## Verify

```sh
starship --version      # prompt binary
starship prompt         # renders: → <dir> git:(branch)
tmux new -As main       # tmux with status bar at the bottom
```

## Customize

- Prompt: `~/.config/starship.toml` (scan_timeout=5, plain text — keep it minimal for speed)
- Shell load order: `~/.config/bash/bashrc`
- tmux: `~/.config/tmux/tmux.conf` (TPM plugins + rose-pine theme)
- tmux-sessionizer: `C-a f` (or `C-f` in nvim) picks a project with fzf; search
  paths and `TS_SESSION_COMMANDS` live in `~/.config/tmux-sessionizer/tmux-sessionizer.conf`;
  `Alt+h` in nvim opens (or jumps to) a shell split, `C-a M-h` a shell in window 69
- nvim: `~/.config/nvim`, laid out like [ThePrimeagen/init.lua](https://github.com/ThePrimeagen/init.lua)
  (lazy.nvim, telescope, harpoon2, Mason, trouble, undotree, dap/neotest, rose-pine);
  oil (`<leader>pv`), the old keymaps and the old blink.cmp + autopairs completion are kept

## Install mise (manager package)
```sh
curl https://mise.run | sh
```

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

## mise (tool versions)

Config lives at `~/.config/mise/config.toml` (mise default):

```toml
[tools]
bun = "latest"
go = "latest"
node = "lts"
"npm:typescript" = "latest"
```

Loaded via shims in `~/.config/bash/bashrc` (zero startup cost):

```sh
export PATH="$HOME/.local/share/mise/shims:$PATH"
```

Manage: `mise install` / `mise use -g <tool>` (edits the toml above).
## Install script

One-shot setup on a fresh Arch WSL:

```sh
~/.config/install.sh
```

Installs (idempotent, safe to re-run): pacman packages (starship, tmux, fzf,
ripgrep, tree-sitter-cli, neovim), mise + tools from
`~/.config/mise/config.toml`, bash shims, TPM + tmux plugins,
tmux-sessionizer, nvim plugins (`lazy-lock.json`) + Mason tools.