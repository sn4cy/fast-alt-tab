-- Merge these bindings into your existing Hyprland Lua configuration.
-- Replace any existing Alt+Tab bindings to avoid duplicate actions.
local switcher = os.getenv("HOME") .. "/.local/bin/fast-alt-tab"
local function action(command)
    return hl.dsp.exec_cmd(string.format("%q %s", switcher, command))
end
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start fast-alt-tab.service")
end)
hl.bind("ALT + Tab", action("next"))
hl.bind("ALT + SHIFT + Tab", action("reverse"))
hl.bind("ALT + Escape", action("cancel"))
local release = {
    release = true,
    ignore_mods = true,
    transparent = true,
    submap_universal = true,
    non_consuming = true,
}
hl.bind("Alt_L", action("commit"), release)
hl.bind("Alt_R", action("commit"), release)
