#!/usr/bin/env bash
# Symlink các dotfile nằm ngoài ~/.config về đúng chỗ, copy file hệ thống vào /etc.
# Chạy lại nhiều lần không sao. File cũ (không phải symlink) được đổi tên thành *.pre-dotconfig
set -euo pipefail

DOT="$HOME/.config"

link() {
    local src="$DOT/home/$1" dst="$HOME/$1"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        mv "$dst" "$dst.pre-dotconfig"
        echo "backup: $dst -> $dst.pre-dotconfig"
    fi
    ln -sfn "$src" "$dst"
    echo "link:   $dst -> $src"
}

link .zshrc
link .zsh_profile
link .xprofile
for f in "$DOT"/home/.local/scripts/*; do
    link ".local/scripts/$(basename "$f")"
done
chmod +x "$DOT"/home/.local/scripts/*

# Touchpad: chạm để click (cần sudo)
if ! cmp -s "$DOT/etc/X11/xorg.conf.d/30-touchpad.conf" /etc/X11/xorg.conf.d/30-touchpad.conf; then
    sudo install -Dm644 "$DOT/etc/X11/xorg.conf.d/30-touchpad.conf" /etc/X11/xorg.conf.d/30-touchpad.conf
    echo "copy:   /etc/X11/xorg.conf.d/30-touchpad.conf"
fi

echo "Xong. Đăng xuất rồi đăng nhập lại (chọn phiên i3 ở SDDM)."
