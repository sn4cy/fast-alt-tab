# Fast Alt Tab

A lightweight, Windows-style Alt+Tab window switcher for Hyprland.
A Quickshell interface communicates with a small C client over a UNIX socket,
avoiding the cost of starting Qt or Python for every key press.

## Controls

- **Alt + Tab**: Cycle through windows in the current workspace, ordered by recent use.
- **Alt + Shift + Tab**: Cycle in reverse.
- **Release Alt**: Switch to the selected window.
- **Alt + Escape**: Cancel the selection.
- Click a card to switch directly to that window.

The first Tab selects the previously used window. Quick switches completed within
100 ms do not display the panel. The interface uses a translucent dark panel,
static window previews, a soft blue selection border, and application icons.
There are no headings or keyboard hints in the panel.

## Requirements

- Linux / Wayland
- **Hyprland 0.56.2 with Lua configuration**, the tested environment. The included
  configuration example uses the Lua API rather than the traditional `hyprland.conf` syntax.
- **Quickshell 0.3.1**, the tested version
- A C compiler and systemd user services

## Installation

Run the installer from the repository directory:

```sh
bash install.sh
```

Add the bindings from `examples/hyprland.lua` to your existing Hyprland Lua
configuration. Replace existing Alt+Tab bindings if present.
`transparent = true` is required for selection confirmation when Alt is released.

```sh
systemctl --user restart fast-alt-tab.service
hyprctl reload
```

The startup hook in the example starts the service in subsequent sessions.
The installer leaves editing your Hyprland configuration to you.

## Files

| File | Purpose |
| --- | --- |
| `shell.qml` | Interface, window list, selection, confirmation, and socket server |
| `client.c` | Small client that sends keyboard actions |
| `install.sh` | Compilation and installation into user directories |
| `examples/hyprland.lua` | Startup hook and key bindings |

Ghostty, Firefox, and Zen use application icons installed on your system.
The Zen icon path targets Arch Linux's `zen-browser-bin` package. Other applications
use icons from their desktop entries. Icon images are not bundled in this repository.

## Status and stopping the service

```sh
~/.local/bin/fast-alt-tab status
journalctl --user -u fast-alt-tab.service
systemctl --user stop fast-alt-tab.service
```

To uninstall, remove the added bindings and startup hook, then stop the service.
Delete `~/.local/bin/fast-alt-tab`, `hypr/alt-tab` in your configuration directory,
and `systemd/user/fast-alt-tab.service` in that same directory.
Run `systemctl --user daemon-reload` afterward.

## Limitations

Testing was performed with the versions listed above on a single monitor.
Window previews are static snapshots and do not continuously update during selection.
Applications without a matching desktop entry or available icon may use a generic icon.
