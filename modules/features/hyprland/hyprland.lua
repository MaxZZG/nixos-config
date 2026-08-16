-- Hyprland Lua 配置（独立文件，由 home-manager 部署到 ~/.config/hypr/config.lua）
-- 实际加载由 features/hyprland/nixos.nix 通过 HYPRLAND_CONFIG 指定。
-- 参考官方示例：https://wiki.hypr.land/Configuring/Start/

local mainMod = "SUPER"
local terminal = "kitty"

-----------------------
---- ENVIRONMENT -----
-----------------------
hl.env("XCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col = {
      -- 注意：Lua 配置里颜色用 rgba(rrggbbaa)，不能用 0xff... 写法
      active_border = "rgba(89b4faff)",
      inactive_border = "rgba(45475aff)",
    },
    layout = "dwindle",
  },
})

-----------------------
---- AUTOSTART --------
-----------------------
-- 在 Hyprland 启动时拉起状态栏与通知守护（& 让其在后台运行）
hl.on("hyprland.start", function ()
  hl.exec_cmd("waybar &")
  hl.exec_cmd("dunst &")
end)

-----------------------
---- KEYBINDINGS ------
-----------------------
-- Super+Enter 打开终端
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
-- Super+Q 关闭当前窗口
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- Super+R 启动程序启动器（wofi）。有它在，即使终端打不开也能跑命令，避免死循环
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi --show drun"))

-- 方向键移动焦点
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Super+[1-9,0] 切换工作区；Super+Shift+[1-9,0] 把窗口移到对应工作区
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
