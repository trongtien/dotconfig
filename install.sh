#!/usr/bin/env bash
# install.sh - install everything needed to use these dotfiles (~/.config)
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  echo "need root or sudo" >&2
  exit 1
fi

echo "==> pacman: packages"
$SUDO pacman -S --needed --noconfirm \
  git curl starship tmux ripgrep tree-sitter-cli neovim foot ttf-jetbrains-mono-nerd \
  gopls tailwindcss-language-server typescript-language-server \
  lua-language-server yaml-language-server

echo "==> mise: version manager (~/.config/mise/config.toml)"
if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
if [ -f "$HOME/.config/mise/config.toml" ]; then
  mise install
fi

echo "==> templ (Go templ language server)"
if ! command -v templ >/dev/null 2>&1; then
  GOBIN="$HOME/.local/share/mise/shims" go install github.com/a-h/templ/cmd/templ@latest
fi

echo "==> bash: shims (login -> ~/.config/bash/bashrc)"
if ! grep -qF '.config/bash/bashrc' "$HOME/.bashrc" 2>/dev/null; then
  printf '%s\n' \
    '# All shell config lives in ~/.config' \
    '[ -f "$HOME/.config/bash/bashrc" ] && . "$HOME/.config/bash/bashrc"' \
    > "$HOME/.bashrc"
fi
if ! grep -qF '.bashrc' "$HOME/.bash_profile" 2>/dev/null; then
  printf '%s\n' \
    '# Login shells: load ~/.bashrc' \
    '[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"' \
    > "$HOME/.bash_profile"
fi

echo "==> tmux: TPM + plugins"
# repair: plugin dirs must be real git clones (TPM rejects non-git dirs)
PLUGIN_DIR="$HOME/.config/tmux/plugins"
for p in tpm tmux; do
  if [ -d "$PLUGIN_DIR/$p" ] && [ ! -d "$PLUGIN_DIR/$p/.git" ]; then
    echo "    repairing broken plugin dir: $p"
    rm -rf "$PLUGIN_DIR/$p"
  fi
done
TPM="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
fi
CREATED=0
if ! tmux ls >/dev/null 2>&1; then
  tmux new-session -d -s _tpm_install
  CREATED=1
fi
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$PLUGIN_DIR/"
tmux run-shell "$TPM/bin/install_plugins" || true
if [ "$CREATED" -eq 1 ]; then
  tmux kill-session -t _tpm_install 2>/dev/null || true
fi

echo "==> nvim: bootstrap plugins + parsers (first time only)"
if command -v nvim >/dev/null 2>&1; then
  if [ ! -d "$HOME/.local/share/nvim/site/pack/core/opt" ] \
     || [ -z "$(ls -A "$HOME/.local/share/nvim/site/pack/core/opt" 2>/dev/null)" ]; then
    nvim --headless -c 'sleep 60000' -c 'qa!' || true
  else
    echo "    plugins already present, skipped"
  fi
fi

echo ""
echo "Done. Open a new WT tab (Arch tmux) to use everything."