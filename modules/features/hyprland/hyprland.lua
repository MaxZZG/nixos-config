-- =============================================================
-- Hyprland 配置（Lua 格式）
--
-- 自 Hyprland 0.55 起 hyprlang（hyprland.conf）已废弃，改为 Lua。
-- 官方原文：Since Hyprland 0.55, hyprlang is deprecated in favor of lua.
-- upstream 将在后续版本移除对 .conf 的支持。
--
-- 由 home-manager 读入，生成到 ~/.config/hypr/hyprland.lua
-- 保存后 rebuild 生效，或执行 `hyprctl reload` 热重载
-- 语法参考：https://wiki.hypr.land/Configuring/Start/
-- =============================================================

-------------------
---- 常用程序 ----
-------------------
local terminal = "kitty"
local menu = "wofi --show drun"
local mainMod = "SUPER" -- Win 键

-------------------
---- 显示器 ----
-------------------
-- output 留空为兜底规则（匹配所有未单独指定的显示器）
-- 多显示器请各写一个 hl.monitor()，名称用 `hyprctl monitors` 查看
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-------------------------
---- 环境变量 ----
-------------------------
-- 让 Qt / GTK / SDL / Clutter 走 Wayland 原生，避免 XWayland 下模糊
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- Electron 应用默认走 X11，设为 1 提示其使用 Wayland
hl.env("NIXOS_OZONE_WL", "1")

-- 光标
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-------------------
---- 自启动 ----
-------------------
-- 会话级服务（输入法、通知等）依赖 graphical-session.target，
-- 该 target 由 home-manager 的 systemd 集成拉起，这里无需手动处理。
--
-- 需要自启动普通程序时，取消下面注释并按需要增删：
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("waybar")
--     hl.exec_cmd("hyprpaper")
-- end)
--
-- 注意：hl.exec_cmd() 是异步的，末尾不需要加 &

-----------------------
---- 外观与行为 ----
-----------------------
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = "rgba(7fc8ffee)",
			inactive_border = "rgba(595959aa)",
		},
		layout = "dwindle",
		resize_on_border = false,
		allow_tearing = false,
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.95,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			tap_to_click = true,
		},
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0, -- 0 或 1 关闭动漫娘壁纸，-1 为随机
		-- vfr 不在 misc 下！它属于 debug 类目（默认 true，官方建议保持启用，故无需显式设置）
	},
})

-- 自定义动画曲线
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "easeOutQuint" })

-- 三指横向滑动切换工作区
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-------------------
---- 键位 ----
-------------------

-- 启动程序
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- 退出 / 重载
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- 窗口控制
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- 移动焦点（方向键 + vim 风格）
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- 移动窗口
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- 工作区 1-10：切换 / 移动窗口到该工作区
for i = 1, 10 do
	local key = i % 10 -- 10 映射到按键 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- 鼠标滚轮切换工作区
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- 拖拽移动 / 缩放窗口（按住 拖拽）
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- 音量（PipeWire + WirePlumber）
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- 亮度
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- 媒体控制（需要 playerctl）
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-----------------------
---- 窗口规则 ----
-----------------------

-- 让 XWayland 下拖动窗口更正常
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- 音量控制等小工具浮动显示
hl.window_rule({
	name = "float-pavucontrol",
	match = { class = "^(pavucontrol)$" },
	float = true,
})

hl.window_rule({
	name = "float-nm-connection-editor",
	match = { class = "^(nm-connection-editor)$" },
	float = true,
})
