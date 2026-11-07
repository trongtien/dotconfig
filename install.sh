#!/usr/bin/env bash
# Cài đặt sau khi đã cài Arch, đăng nhập user và kết nối Wi-Fi thành công.
# Thứ tự: kiểm tra mạng → package pacman → yay + package AUR → Oh My Zsh
#         → symlink dotfiles → bật dịch vụ.
# Chạy lại nhiều lần không sao (package đã có sẽ bỏ qua).
#
#   ~/.config/install.sh            cài tất cả
#   DRY_RUN=1 ~/.config/install.sh  chỉ in ra lệnh sẽ chạy
set -euo pipefail

DOT="$HOME/.config"

# Package chính thức (pacman)
PACMAN_PKGS=(
    # Giao diện i3 (X11)
    xorg-server xorg-xrandr xorg-xset i3-wm i3status i3lock xss-lock dex rofi dunst sddm
    # Terminal + công cụ dòng lệnh
    kitty tmux zsh fzf ripgrep fd xclip unzip wget git
    # Neovim + build parser treesitter + runtime cho LSP (Mason)
    neovim tree-sitter-cli gcc make nodejs npm go
    # Font có icon
    ttf-jetbrains-mono-nerd
    # Âm thanh
    pipewire pipewire-audio pipewire-pulse wireplumber
    # Mạng, độ sáng
    networkmanager network-manager-applet iwd brightnessctl
    # Gõ tiếng Việt
    fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-unikey
    # Quản lý file
    thunar thunar-archive-plugin thunar-volman gvfs tumbler ffmpegthumbnailer file-roller
    # Lưu token GitHub mã hoá
    gnome-keyring libsecret
)

# Package AUR (yay)
AUR_PKGS=(
    brave-bin
)

# ---------------------------------------------------------------------
c_step=$'\e[1;34m'; c_ok=$'\e[1;32m'; c_err=$'\e[1;31m'; c_off=$'\e[0m'
step() { printf '\n%s==> %s%s\n' "$c_step" "$*" "$c_off"; }
ok()   { printf '%s  ✓ %s%s\n' "$c_ok" "$*" "$c_off"; }
die()  { printf '%s  ✗ %s%s\n' "$c_err" "$*" "$c_off" >&2; exit 1; }
run()  { if [[ -n "${DRY_RUN:-}" ]]; then printf '  $ %s\n' "$*"; else "$@"; fi; }

[[ $EUID -ne 0 ]] || die "Chạy bằng user thường (không dùng sudo), script sẽ tự hỏi sudo khi cần."

# ---------------------------------------------------------------------
step "1/6 Kiểm tra kết nối mạng"
if ! curl -fsS --max-time 10 -o /dev/null https://archlinux.org; then
    die "Chưa có mạng. Kết nối Wi-Fi trước:
      nmcli device wifi connect \"Tên-WiFi\" --ask     (hoặc: nmtui)
    rồi chạy lại script."
fi
ok "Có mạng"

# ---------------------------------------------------------------------
step "2/6 Cài package chính thức (pacman)"
run sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"
ok "${#PACMAN_PKGS[@]} package"

# ---------------------------------------------------------------------
step "3/6 Cài yay và package AUR"
if ! command -v yay >/dev/null; then
    tmp=$(mktemp -d)
    run git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
    if [[ -z "${DRY_RUN:-}" ]]; then
        (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
    else
        printf '  $ (cd %s && makepkg -si --noconfirm)\n' "$tmp/yay-bin"
    fi
    rm -rf "$tmp"
fi
ok "yay"
run yay -S --needed --noconfirm "${AUR_PKGS[@]}"
ok "${AUR_PKGS[*]}"

# ---------------------------------------------------------------------
step "4/6 Zsh + Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    if [[ -z "${DRY_RUN:-}" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    else
        printf '  $ (cài Oh My Zsh --unattended --keep-zshrc)\n'
    fi
fi
ok "Oh My Zsh"
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "/usr/bin/zsh" && "$(getent passwd "$USER" | cut -d: -f7)" != "/bin/zsh" ]]; then
    run chsh -s /usr/bin/zsh
fi
ok "Shell mặc định: zsh"

# ---------------------------------------------------------------------
step "5/6 Symlink dotfiles"
link() {
    local src="$DOT/home/$1" dst="$HOME/$1"
    run mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        run mv "$dst" "$dst.pre-dotconfig"
        echo "  backup: $dst -> $dst.pre-dotconfig"
    fi
    run ln -sfn "$src" "$dst"
    echo "  link:   ~/$1"
}
link .zshrc
link .zsh_profile
link .xprofile
for f in "$DOT"/home/.local/scripts/*; do
    link ".local/scripts/$(basename "$f")"
done
run chmod +x "$DOT"/home/.local/scripts/*

# Touchpad: chạm để click
if ! cmp -s "$DOT/etc/X11/xorg.conf.d/30-touchpad.conf" /etc/X11/xorg.conf.d/30-touchpad.conf; then
    run sudo install -Dm644 "$DOT/etc/X11/xorg.conf.d/30-touchpad.conf" /etc/X11/xorg.conf.d/30-touchpad.conf
fi
ok "Dotfiles"

# ---------------------------------------------------------------------
step "6/6 Bật dịch vụ"
run sudo systemctl enable NetworkManager sddm
run systemctl --user enable pipewire.socket pipewire-pulse.socket wireplumber.service
ok "NetworkManager, sddm, pipewire"

# GitHub: lưu token trong gnome-keyring
run git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

printf '\n%sXong!%s Khởi động lại: %ssudo reboot%s, ở SDDM chọn phiên %si3%s.\n' \
    "$c_ok" "$c_off" "$c_step" "$c_off" "$c_step" "$c_off"
printf 'Lần đầu mở nvim sẽ tự tải plugin và LSP (vài phút).\n'
