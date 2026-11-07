# dotconfig

Cấu hình Arch Linux của mình: **i3 (X11)** + kitty + tmux + zsh + Neovim (`vim.pack`), gõ tiếng Việt bằng fcitx5-unikey. Có kèm cấu hình Hyprland/waybar/wofi để dự phòng.

Repo này **chính là thư mục `~/.config`**. File `.gitignore` liệt kê đúng những thư mục được theo dõi; mọi thứ khác trong `~/.config` (dữ liệu trình duyệt, cache, cookie…) bị bỏ qua.

```
~/.config/
├── i3/config               # WM chính, phím tắt giống Hyprland, $mod = phím Windows
├── i3status/config         # thanh trạng thái
├── kitty/kitty.conf        # terminal, Ctrl +/-/0 để zoom chữ
├── tmux/tmux.conf          # prefix Ctrl-a, phím kiểu vim
├── nvim/                   # Neovim 0.12, quản lý plugin bằng vim.pack
│   ├── init.lua
│   ├── nvim-pack-lock.json # khoá phiên bản plugin
│   └── lua/kelvin/{set,remap,pack}.lua, plugins/*.lua
├── fcitx5/                 # bộ gõ: Unikey, Telex
├── personal/               # alias, hàm, PATH (được ~/.zsh_profile source)
├── hypr/ waybar/ wofi/     # Hyprland (Wayland), không dùng mặc định
├── Thunar/ xfce4/          # file manager
├── brave-flags.conf, mimeapps.list
├── home/                   # file nằm ngoài ~/.config → install.sh symlink về $HOME
│   ├── .zshrc .zsh_profile .xprofile
│   ├── .local/scripts/{tmux-sessionizer,monitor-setup,screenshot}
│   └── .local/share/applications/screenshot.desktop   # mục "Screenshot" trong rofi
├── etc/X11/xorg.conf.d/30-touchpad.conf   # → /etc (chạm để click)
└── install.sh
```

---

## Mục lục

1. [Boot USB Arch và kết nối Wi-Fi (không cần cài gì)](#1-boot-usb-arch-và-kết-nối-wi-fi-không-cần-cài-gì)
2. [Cài Arch Linux](#2-cài-arch-linux)
3. [Lần đầu khởi động: Wi-Fi + user](#3-lần-đầu-khởi-động-wi-fi--user)
4. [Lấy dotfiles và chạy install.sh](#4-lấy-dotfiles-và-chạy-installsh)
5. [Khởi động lại vào i3](#5-khởi-động-lại-vào-i3)
6. [Neovim](#6-neovim)
7. [Gõ tiếng Việt](#7-gõ-tiếng-việt)
8. [GitHub: đăng nhập một lần](#8-github-đăng-nhập-một-lần)
9. [Phím tắt](#9-phím-tắt)
10. [Xử lý sự cố](#10-xử-lý-sự-cố)

---

## 1. Boot USB Arch và kết nối Wi-Fi (không cần cài gì)

USB cài Arch có sẵn `iwctl` (iwd), không cần cài thêm package nào.

```sh
# Bỏ chặn Wi-Fi nếu bị khoá (phím airplane)
rfkill unblock wifi

iwctl
```

Trong prompt `[iwd]#`:

```
device list                      # xem tên card, thường là wlan0
station wlan0 scan
station wlan0 get-networks       # danh sách Wi-Fi
station wlan0 connect "Tên-WiFi" # nhập mật khẩu khi được hỏi
exit
```

Kiểm tra mạng:

```sh
ping -c 3 archlinux.org
```

> Có dây LAN thì cắm vào là có mạng, bỏ qua bước này.

---

## 2. Cài Arch Linux

> Cách nhanh: chạy `archinstall` (chọn profile *minimal*, network *NetworkManager*, bootloader *GRUB*), rồi nhảy tới [bước 3](#3-lần-đầu-khởi-động-wi-fi--user). Dưới đây là cách cài tay, giống máy hiện tại (UEFI + GRUB, ổ ext4).

### 2.1 Đồng hồ và phân vùng

```sh
timedatectl set-ntp true
lsblk                 # tìm tên ổ: /dev/sda hoặc /dev/nvme0n1
cfdisk /dev/sda       # chọn gpt
```

Tạo 2 phân vùng:

| Phân vùng | Kích thước | Type |
|---|---|---|
| `/dev/sda1` | 1G | EFI System |
| `/dev/sda2` | phần còn lại | Linux filesystem |

> Ổ NVMe thì tên là `/dev/nvme0n1p1`, `/dev/nvme0n1p2`.

### 2.2 Format và mount

```sh
mkfs.fat -F32 -n EFI /dev/sda1
mkfs.ext4 -L arch-root /dev/sda2

mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot/efi
```

### 2.3 Cài hệ thống gốc

`networkmanager` và `iwd` phải cài ở bước này, nếu không lúc khởi động lại sẽ không có gì để kết nối Wi-Fi.

```sh
pacstrap -K /mnt base base-devel linux linux-firmware \
    networkmanager iwd sudo git neovim zsh grub efibootmgr
# CPU Intel thêm intel-ucode, AMD thêm amd-ucode

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

### 2.4 Cấu hình trong chroot

```sh
# Giờ
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
hwclock --systohc

# Ngôn ngữ: bỏ dấu # trước dòng en_US.UTF-8 UTF-8
nvim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Tên máy
echo "arch" > /etc/hostname

# Mật khẩu root
passwd

# Tạo user (đổi kelvin thành tên của bạn)
useradd -m -G wheel -s /bin/zsh kelvin
passwd kelvin

# Cho nhóm wheel dùng sudo: bỏ dấu # trước dòng  %wheel ALL=(ALL:ALL) ALL
EDITOR=nvim visudo

# Bootloader GRUB (UEFI)
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Bật mạng khi khởi động
systemctl enable NetworkManager

exit
umount -R /mnt
reboot   # rút USB
```

---

## 3. Lần đầu khởi động: Wi-Fi + user

Đăng nhập bằng user vừa tạo (màn hình chữ). Kết nối Wi-Fi bằng NetworkManager (đã cài ở bước 2.3):

```sh
nmcli device wifi list
nmcli device wifi connect "Tên-WiFi" --ask   # nhập mật khẩu
# hoặc giao diện menu: nmtui
ping -c 3 archlinux.org
```

---

## 4. Lấy dotfiles và chạy `install.sh`

Sau khi đăng nhập và **đã có Wi-Fi** (bước 3), chỉ cần 2 lệnh. `git` đã có từ bước 2.3.

```sh
# Clone vào ~/.config (dùng init + checkout vì ~/.config có thể không rỗng)
mkdir -p ~/.config && cd ~/.config
git init -b main
git remote add origin https://github.com/trongtien/dotconfig.git
git fetch origin
git checkout -f -B main origin/main

# Cài tất cả
~/.config/install.sh
```

> Muốn xem trước script sẽ chạy những lệnh gì: `DRY_RUN=1 ~/.config/install.sh`

`install.sh` chạy theo thứ tự, dừng ngay nếu có lỗi. Chạy lại nhiều lần không sao.

| Bước | Việc làm |
|---|---|
| 1. Kiểm tra mạng | Chưa có mạng thì dừng và nhắc lệnh `nmcli` |
| 2. pacman | Cài toàn bộ package chính thức (bảng dưới) |
| 3. yay | Cài `yay` (bản `yay-bin` build sẵn) rồi cài package AUR: `brave-bin` |
| 4. Zsh | Cài Oh My Zsh (giữ `.zshrc` của repo), đặt zsh làm shell mặc định |
| 5. Dotfiles | Symlink `.zshrc`, `.zsh_profile`, `.xprofile`, `~/.local/scripts/*` từ `home/`; copy cấu hình touchpad vào `/etc`. File cũ được đổi tên thành `*.pre-dotconfig` |
| 6. Dịch vụ | Bật `NetworkManager`, `sddm`, pipewire; đặt git lưu token trong gnome-keyring |

Package được cài (sửa danh sách ở đầu `install.sh`, biến `PACMAN_PKGS` và `AUR_PKGS`):

| Nhóm | Package | Dùng cho |
|---|---|---|
| Giao diện | `xorg-server xorg-xrandr xorg-xset i3-wm i3status i3lock xss-lock dex rofi dunst sddm` | i3 (X11), menu ứng dụng, thông báo, màn hình đăng nhập |
| Dòng lệnh | `kitty tmux zsh fzf ripgrep fd xclip unzip wget git` | Terminal và công cụ |
| Neovim | `neovim tree-sitter-cli gcc make nodejs npm go` | Editor, build parser treesitter, Mason cài LSP |
| Font | `ttf-jetbrains-mono-nerd` | Font có icon cho kitty, i3, neo-tree |
| Âm thanh | `pipewire pipewire-audio pipewire-pulse wireplumber` | |
| Mạng, độ sáng | `networkmanager network-manager-applet iwd brightnessctl` | Icon Wi-Fi trên thanh, phím độ sáng |
| Chụp màn hình | `scrot libnotify` | Script `screenshot`, thông báo sau khi chụp |
| Tiếng Việt | `fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-unikey` | |
| File | `thunar thunar-archive-plugin thunar-volman gvfs tumbler ffmpegthumbnailer file-roller` | Quản lý file, ảnh thu nhỏ, giải nén |
| Keyring | `gnome-keyring libsecret` | Lưu token GitHub mã hoá |
| AUR | `brave-bin` | Trình duyệt |

> Muốn dùng thêm Hyprland: `sudo pacman -S hyprland hyprlock waybar wofi mako`

---

## 5. Khởi động lại vào i3

```sh
sudo reboot
```

Ở màn hình SDDM chọn phiên **i3** (góc trái dưới), đăng nhập bằng mật khẩu (đừng bật autologin, để gnome-keyring tự mở khoá).

Khi vào i3:
- `~/.xprofile` đặt biến môi trường cho fcitx5.
- i3 tự chạy: `nm-applet`, `dunst`, `fcitx5`, `xss-lock`, script `monitor-setup`, và mở kitty ở workspace 1.
- `monitor-setup`: có màn **HDMI-1** thì chỉ dùng màn ngoài 1920x1080, không có thì dùng màn laptop (độ sáng 100%). Bấm `Super+p` để chạy lại khi cắm/rút màn. Tên cổng khác thì sửa `INTERNAL`/`EXTERNAL` trong `home/.local/scripts/monitor-setup` (xem tên bằng `xrandr`).
- `screenshot`: chụp bằng `scrot`, lưu `~/Pictures/Screenshots/<ngày_giờ>.png` và copy vào clipboard. Gọi không tham số → menu rofi; hoặc `screenshot region|full|window|delay`. Cũng có mục **Screenshot** trong `Super+r`.
- `xset s off -dpms`: không tự làm tối/tắt màn hình khi để yên.
- Shell: `~/.zshrc` → Oh My Zsh → `~/.zsh_profile` → `~/.config/personal/*` (alias, PATH), phím fzf, `Ctrl-f` mở tmux-sessionizer.

---

## 6. Neovim

Mở `nvim` lần đầu, `vim.pack` (có sẵn trong Neovim 0.12) tự tải toàn bộ plugin theo `nvim-pack-lock.json`, không hỏi. Sau đó:
- **nvim-treesitter** tự build parser (cần `tree-sitter-cli` + `gcc`).
- **Mason** tự cài LSP: `lua_ls`, `gopls`, `ts_ls`, `pyright`, `bashls` (cần `nodejs`, `npm`, `go`). Xem tiến độ: `:Mason`.

Plugin: rose-pine, telescope, harpoon, treesitter, undotree, fugitive, conform, neo-tree, blink.cmp, lazydev, fidget, mason + lspconfig.

```vim
:lua vim.pack.update()         " cập nhật plugin (mở buffer xem trước, :w để xác nhận)
:lua vim.pack.del({ "tên" })   " gỡ plugin (nhớ xoá luôn dòng trong lua/kelvin/pack.lua)
:checkhealth                   " kiểm tra lỗi
```

Thêm plugin mới: thêm vào danh sách `vim.pack.add` trong `nvim/lua/kelvin/pack.lua`, tạo file cấu hình trong `nvim/lua/kelvin/plugins/` và `require` nó ở cuối `pack.lua`.

---

## 7. Gõ tiếng Việt

fcitx5 + Unikey, kiểu gõ **Telex** (cấu hình trong `fcitx5/`).
- `Ctrl+Space`: bật/tắt tiếng Việt.
- Cấu hình thêm: chạy `fcitx5-configtool`.
- kitty dùng `GLFW_IM_MODULE=ibus` (đặt trong `~/.xprofile`) để gõ được tiếng Việt. i3 đợi fcitx5 sẵn sàng rồi mới mở kitty đầu tiên.

---

## 8. GitHub: đăng nhập một lần

Dùng Personal Access Token, lưu mã hoá trong gnome-keyring (`install.sh` đã đặt `credential.helper`). Chỉ cần khai báo tên/email cho commit:

```sh
git config --global user.name  "Tên của bạn"
git config --global user.email "email@example.com"
```

1. Tạo token: https://github.com/settings/tokens → **Generate new token (classic)** → tick `repo` (và `workflow` nếu sửa GitHub Actions) → copy token `ghp_...`.
2. Lần đầu `git push`: *Username* = tên GitHub, *Password* = dán token. Từ đó không hỏi lại.

---

## 9. Phím tắt

### i3 (`Super` = phím Windows)

| Phím | Tác dụng |
|---|---|
| `Super+q` | Mở kitty |
| `Super+r` | Menu ứng dụng (rofi) |
| `Super+e` | Thunar |
| `Super+c` | Đóng cửa sổ |
| `Super+f` | Toàn màn hình |
| `Super+v` | Bật/tắt floating |
| `Super+j` | Đổi hướng chia ngang/dọc |
| `Super+t` | Chuyển layout tabbed |
| `Super+←↓↑→` | Chuyển focus |
| `Super+Shift+←↓↑→` | Di chuyển cửa sổ |
| `Super+1..0` | Sang workspace 1–10 |
| `Super+Shift+1..0` | Đưa cửa sổ sang workspace |
| `Super+s` / `Super+Shift+s` | Hiện / cất vào scratchpad |
| `Super+Shift+r` | Chế độ resize (mũi tên, `Esc` để thoát) |
| `Super+p` | Chạy lại cấu hình màn hình |
| `Print` | Menu chụp màn hình (Region / Full screen / Active window / Full screen in 3s / Open folder) |
| `Shift+Print` | Chụp vùng chọn bằng chuột |
| `Super+Print` | Chụp cửa sổ đang focus |
| `Super+Escape` | Khoá màn hình |
| `Super+w` | Khởi động lại i3 |
| `Super+Shift+c` | Nạp lại config i3 |
| `Super+m` | Thoát i3 |
| `Super+cuộn chuột` | Chuyển workspace |

### kitty

| Phím | Tác dụng |
|---|---|
| `Ctrl+=` / `Ctrl+-` | Tăng / giảm cỡ chữ |
| `Ctrl+0` | Cỡ chữ mặc định |
| `Ctrl+cuộn chuột` | Zoom |
| `Ctrl+Shift+F5` | Nạp lại config |

### tmux (prefix = `Ctrl-a`)

| Phím | Tác dụng |
|---|---|
| `prefix h/j/k/l` | Chuyển pane |
| `prefix ^` | Về window trước |
| `prefix f` hoặc `Ctrl-f` (ở zsh) | tmux-sessionizer: chọn project bằng fzf |
| `prefix r` | Nạp lại config |
| `prefix [` rồi `v` … `y` | Copy kiểu vim vào clipboard |

### Neovim (`<leader>` = `Space`)

| Phím | Tác dụng |
|---|---|
| `<leader>e` / `<leader>o` | Neo-tree: bật/tắt / focus |
| `<leader>pv` | netrw |
| `<leader>pf` / `Ctrl-p` | Tìm file / file trong git |
| `<leader>ps` | Live grep |
| `<leader>pws` | Grep từ dưới con trỏ |
| `<leader>pb` / `<leader>vh` | Buffers / help |
| `<leader>a` / `Ctrl-e` | Harpoon: thêm file / menu |
| `<leader>1..4` | Harpoon: mở file 1–4 |
| `<leader>u` | Undotree |
| `<leader>gs` | Git status (fugitive) |
| `<leader>f` | Format |
| `gd` / `K` | Tới định nghĩa / xem tài liệu |
| `<leader>vrn` / `<leader>vca` | Đổi tên / code action |
| `<leader>vrr` / `<leader>vd` | References / xem lỗi |
| `<leader>y` / `<leader>p` | Copy ra clipboard / dán không mất register |
| `Ctrl-y` / `Ctrl-n` / `Ctrl-p` | Completion: chọn / xuống / lên |

---

## 10. Xử lý sự cố

| Vấn đề | Cách xử lý |
|---|---|
| Không có Wi-Fi sau khi cài | `sudo systemctl enable --now NetworkManager`, rồi `nmtui`. Không có NetworkManager thì boot lại USB, `arch-chroot` và `pacman -S networkmanager`. |
| Màn hình tự tối/tắt sau 10 phút | Cài `xorg-xset`, `Super+w`. Nếu màn ngoài vẫn tự tối khi đang dùng: tắt ECO / Dynamic Contrast / Auto Brightness trong menu của màn. |
| Không gõ được tiếng Việt trong kitty | Đăng xuất/đăng nhập lại để `~/.xprofile` có hiệu lực; kiểm tra `fcitx5-remote` trả về số. |
| Treesitter không highlight | `which tree-sitter gcc`, rồi trong nvim `:TSUpdate`. |
| LSP không chạy | `:Mason` xem lỗi; thường do thiếu `nodejs`/`npm`/`go`. |
| `git push` hỏi mật khẩu mãi | Phiên đăng nhập bằng autologin nên keyring bị khoá; tắt autologin hoặc dùng `git config --global credential.helper store`. |
