#!/usr/bin/env bash
set -euo pipefail
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}
for tool in cc quickshell hyprctl systemctl; do
    command -v "$tool" >/dev/null || { printf 'Missing dependency: %s\n' "$tool" >&2; exit 1; }
done
mkdir -p "$config_dir/hypr/alt-tab" "$config_dir/systemd/user" "$HOME/.local/bin"
cc -O2 -Wall -Wextra "$source_dir/client.c" -o "$HOME/.local/bin/fast-alt-tab"
install -m 644 "$source_dir/shell.qml" "$config_dir/hypr/alt-tab/shell.qml"
cat > "$config_dir/systemd/user/fast-alt-tab.service" <<EOF
[Unit]
Description=Fast Alt Tab switcher
After=graphical-session.target

[Service]
ExecStart=/usr/bin/env quickshell -p "%E/hypr/alt-tab"
Restart=on-failure
RestartSec=1
EOF
systemctl --user daemon-reload
printf 'Installed. Add the bindings from examples/hyprland.lua, then restart fast-alt-tab.service.\n'
