-- ============================================================
-- WezTerm 配置  —  Synthwave 深紫主题
-- 官方文档: https://wezfurlong.org/wezterm/
-- ============================================================

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ---- 路径配置 ----
local home = wezterm.home_dir
local nushell_path = home .. "\\AppData\\Local\\Programs\\nu\\bin\\nu.exe"
local msys2_root = "C:\\msys64"
local bash_path = msys2_root .. "\\usr\\bin\\bash.exe"
local zsh_path = msys2_root .. "\\usr\\bin\\zsh.exe"

local function file_exists(path)
  local f = io.open(path, "r")
  if f ~= nil then io.close(f); return true
  else return false end
end

-- ---- 环境变量 ----
config.set_environment_variables = {
  LANG = "en_US.UTF-8",
  LC_ALL = "en_US.UTF-8",
}

-- ---- 渲染 & 光标 ----
config.front_end = "OpenGL"
config.max_fps = 144
config.animation_fps = 1
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.term = "xterm-256color"

-- ---- 字体 ----
config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font Mono",
  "Segoe UI Symbol",
})
config.custom_block_glyphs = true
config.anti_alias_custom_block_glyphs = true
config.cell_width = 1.0
config.font_size = 12.8

-- ---- 窗口 ----
config.window_background_opacity = 1
config.win32_system_backdrop = "Disable"
config.prefer_egl = true
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.initial_cols = 162
config.initial_rows = 47

-- ---- 标签栏 ----
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 999

-- ---- 配色: 深紫 #0E0A12 + 霓虹粉 #FF9CF0 ----
config.colors = {
  foreground = "#E2D8F5",
  background = "#0E0A12",
  cursor_bg = "#FF9CF0",
  cursor_border = "#FF9CF0",
  cursor_fg = "#0E0A12",
  selection_bg = "#3A2D3E",
  selection_fg = "#E2D8F5",
  ansi = { "#45475A", "#F38BA8", "#A6E3A1", "#F9E2AF", "#89B4FA", "#F5C2E7", "#94E2D5", "#BAC2DE" },
  brights = { "#585B70", "#F38BA8", "#A6E3A1", "#F9E2AF", "#89B4FA", "#F5C2E7", "#94E2D5", "#A6ADC8" },
  tab_bar = {
    background = "#0E0A12",
    active_tab = { bg_color = "#FF9CF0", fg_color = "#0E0A12" },
    inactive_tab = { bg_color = "#0E0A12", fg_color = "#D0C4E5" },
    inactive_tab_hover = { bg_color = "#0E0A12", fg_color = "#FF9CF0" },
    new_tab = { bg_color = "#0E0A12", fg_color = "#D0C4E5" },
    new_tab_hover = { bg_color = "#0E0A12", fg_color = "#FF9CF0" },
  },
}

-- ---- 启动菜单 (Ctrl+Shift+B) ----
config.launch_menu = {
  { label = "Nushell (默认)", args = { nushell_path } },
  { label = "MSYS2 MINGW64", args = { bash_path, "-l", "-i" },
    set_environment_variables = { MSYSTEM = "MINGW64", CHERE_INVOKING = "1", MSYS2_PATH_TYPE = "inherit" } },
  { label = "MSYS2 UCRT64", args = { bash_path, "-l", "-i" },
    set_environment_variables = { MSYSTEM = "UCRT64", CHERE_INVOKING = "1", MSYS2_PATH_TYPE = "inherit" } },
  { label = "PowerShell", args = { "powershell.exe", "-NoLogo" } },
  { label = "CMD", args = { "cmd.exe" } },
}

-- ---- 标签页标题: 半圆形分隔 ----
local tab_colors = { "#FF6B81", "#F9E2AF", "#A6E3A1", "#89B4FA", "#94E2D5", "#F5C2E7", "#FF9CF0", "#F595D8" }

config.status_update_interval = 60000
wezterm.on("update-right-status", function(window, _)
  window:set_right_status(wezterm.format({
    { Text = wezterm.nerdfonts.md_clock .. " " .. wezterm.strftime("%H:%M") },
  }))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title or ""
  local exec_name = tab.active_pane.foreground_process_name or ""
  exec_name = exec_name:gsub("(.*[/\\])(.*)", "%2"):gsub("%.exe$", "")
  local n = exec_name:lower()

  -- 根据进程名匹配图标
  local display_name
  if n:find("wsl") or n:find("wslhost") then display_name = "WSL"
  elseif n:find("nvim") or title:find("%[No Name%]") or title:find(" %- [Nn][Vv][Ii][Mm]") then display_name = "Nvim"
  elseif n:find("yazi") or title:find("[Yy]azi") then display_name = "Yazi"
  elseif n:find("btop") then display_name = "Btop"
  elseif n:find("lazygit") or title:find("[Ll]azygit") then display_name = "Lazygit"
  elseif n:find("zsh") then display_name = "ZSH"
  elseif n:find("bash") then display_name = "Bash"
  elseif n == "nu" then display_name = "Nu"
  elseif n:find("powershell") or n:find("pwsh") then display_name = "PS"
  elseif n:find("cmd") then display_name = "CMD"
  elseif title ~= "" then
    display_name = title:match("([^/\\]+)[/\\]?$") or title
    if #display_name > 12 then display_name = wezterm.truncate_right(display_name, 12) end
  else display_name = exec_name:gsub("^%l", string.upper)
  end
  if display_name == "" then display_name = "Shell" end

  local tab_color = tab_colors[(tab.tab_id % #tab_colors) + 1]
  local result = {}

  if tab.is_active then
    table.insert(result, { Foreground = { Color = "#FF9CF0" } })
    table.insert(result, { Background = { Color = "#0E0A12" } })
    table.insert(result, { Text = "" })
    table.insert(result, { Background = { Color = "#FF9CF0" } })
    table.insert(result, { Foreground = { Color = tab_color } })
    table.insert(result, { Text = "  ◉ " })
    table.insert(result, { Foreground = { Color = "#0E0A12" } })
    table.insert(result, { Text = display_name .. " " })
    table.insert(result, { Foreground = { Color = "#FF9CF0" } })
    table.insert(result, { Background = { Color = "#0E0A12" } })
    table.insert(result, { Text = "" })
  elseif hover then
    table.insert(result, { Background = { Color = "#0E0A12" } })
    table.insert(result, { Foreground = { Color = "#FF9CF0" } })
    table.insert(result, { Text = " " .. wezterm.nerdfonts.fa_circle_o .. " " .. display_name .. " " })
  else
    table.insert(result, { Background = { Color = "#0E0A12" } })
    table.insert(result, { Foreground = { Color = tab_color } })
    table.insert(result, { Text = " " .. wezterm.nerdfonts.fa_circle_o .. " " })
    table.insert(result, { Foreground = { Color = "#D0C4E5" } })
    table.insert(result, { Text = display_name .. " " })
  end
  return result
end)

-- ---- 键位绑定 ----
config.keys = {
  -- 分屏
  { key = "h", mods = "CTRL|SHIFT|ALT", action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 } }) },
  { key = "v", mods = "CTRL|SHIFT|ALT", action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 50 } }) },
  -- 切换窗格
  { key = "LeftArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") },
  -- 调整窗格大小
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "UpArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "DownArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  -- 其他
  { key = "W", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "9", mods = "CTRL", action = act.PaneSelect },
  { key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
  -- 透明度切换
  { key = "O", mods = "CTRL|ALT", action = wezterm.action_callback(function(window, _)
      local overrides = window:get_config_overrides() or {}
      overrides.window_background_opacity = overrides.window_background_opacity == 1.0 and 0.9 or 1.0
      window:set_config_overrides(overrides)
    end) },
  -- 启动菜单
  { key = "B", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }) },
  -- 字体大小
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
}

-- ---- 动态快捷键 (仅当程序存在时注册) ----
if file_exists(nushell_path) then
  table.insert(config.keys, { key = "N", mods = "CTRL|SHIFT", action = act.SpawnCommandInNewTab({ args = { nushell_path } }) })
  table.insert(config.keys, { key = "n", mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 }, command = { args = { nushell_path } } }) })
end

if file_exists(bash_path) then
  table.insert(config.keys, { key = "M", mods = "CTRL|SHIFT",
    action = act.SpawnCommandInNewTab({ label = "MSYS2 MINGW64", args = { bash_path, "-l", "-i" },
      set_environment_variables = { MSYSTEM = "MINGW64", CHERE_INVOKING = "1", MSYS2_PATH_TYPE = "inherit" } }) })
  table.insert(config.keys, { key = "m", mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 },
      command = { args = { bash_path, "-l", "-i" }, set_environment_variables = { MSYSTEM = "MINGW64", CHERE_INVOKING = "1", MSYS2_PATH_TYPE = "inherit" } } }) })
end

if file_exists(zsh_path) then
  table.insert(config.keys, { key = "U", mods = "CTRL|SHIFT",
    action = act.SpawnCommandInNewTab({ label = "MSYS2 UCRT64", args = { zsh_path, "-l", "-i" },
      set_environment_variables = { MSYSTEM = "UCRT64", CHERE_INVOKING = "1", MSYS2_PATH_TYPE = "inherit" } }) })
  table.insert(config.keys, { key = "u", mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 },
      command = { args = { zsh_path, "-l", "-i" }, set_environment_variables = { MSYSTEM = "UCRT64", CHERE_INVOKING = "1", MSYS2_PATH_TYPE = "inherit" } } }) })
end

table.insert(config.keys, { key = "P", mods = "CTRL|SHIFT",
  action = act.SpawnCommandInNewTab({ label = "PowerShell", args = { "powershell.exe", "-NoLogo" } }) })
table.insert(config.keys, { key = "p", mods = "CTRL|SHIFT|ALT",
  action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 }, command = { args = { "powershell.exe", "-NoLogo" } } }) })

-- ---- 窗口框架 ----
config.window_frame = {
  font = wezterm.font({ family = "JetBrainsMono Nerd Font Mono", weight = "Regular" }),
  active_titlebar_bg = "#0E0A12",
  inactive_titlebar_bg = "#0E0A12",
}

-- ---- 默认 Shell ----
if file_exists(nushell_path) then
  config.default_prog = { nushell_path }
else
  config.default_prog = { "powershell.exe", "-NoLogo" }
end

return config
