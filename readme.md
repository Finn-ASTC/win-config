# readme由ds编写

# 桌面配置套件

---

## 必需软件

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| **GlazeWM** | 平铺窗口管理器 | `scoop install glazewm` 或 [GitHub](https://github.com/glzr-io/glazewm) |
| **Zebar** | GlazeWM 配套状态栏 | `scoop install zebar` 或 [GitHub](https://github.com/glzr-io/zebar) |
| **YASB** | 顶部信息栏 (workspace/天气/硬件/系统托盘) | [GitHub](https://github.com/amnweb/yasb) |
| **tacky-borders** | 窗口边框美化 (粉色渐变+阴影+发光) | `scoop install tacky-borders` |
| **Windhawk** | 系统 UI 模组 (任务栏/开始菜单/图标主题等) | [windhawk.net](https://windhawk.net) |
| **WezTerm** | 终端模拟器 | `scoop install wezterm` |
| **Starship** | Shell 提示符美化 | `scoop install starship` |
| **fastfetch** | 系统信息展示 | `scoop install fastfetch` |
| **CAVA** | 音频可视化 (YASB 内嵌) | `scoop install cava` |

## 字体

| 字体 | 用途 | 下载 |
|------|------|------|
| **JetBrainsMono Nerd Font Mono** | WezTerm / YASB / Starship 统一字体 | [nerdfonts.com](https://www.nerdfonts.com/font-downloads) |

几乎所有 Nerd Font 图标（`` `` `󰘬` `` 等）都依赖此字体。

## Windhawk Mod

安装 Windhawk 后需从市场安装以下 mod：

- `chrome-wheel-scroll-tabs` — Chrome 标签页滚轮切换
- `dark-menus` — 深色右键菜单
- `explorer-details-better-file-sizes` — 资源管理器文件大小优化
- `icon-resource-redirect` — 图标主题替换（11 套主题已包含在 `windhawk/icon-resource-redirect/`）
- `taskbar-background-helper` — 任务栏背景辅助
- `taskbar-dock-animation` — 任务栏 Dock 动画
- `taskbar-icon-size` — 任务栏图标大小
- `translucent-windows` — 窗口透明
- `windows-11-file-explorer-styler` — 资源管理器样式
- `windows-11-notification-center-styler` — 通知中心样式
- `windows-11-start-menu-styler` — 开始菜单样式
- `windows-11-taskbar-styler` — 任务栏样式

## 可选软件

| 工具 | 用途 |
|------|------|
| **Nushell** | WezTerm 默认 Shell |
| **MSYS2** | Linux 开发环境 (MINGW64 / UCRT64) |

## 安装后步骤

1. 安装所有必需软件和 JetBrainsMono Nerd Font
2. 将本文件夹各子目录还原到对应位置（见下方表格）
3. 重启对应软件 或 发送 reload 命令

### 还原路径

| 本目录 | 还原到 |
|--------|--------|
| `glazewm/` | `C:\Users\<用户名>\.glzr\glazewm\` |
| `zebar/` | `C:\Users\<用户名>\.glzr\zebar\` |
| `tacky-borders/` | `C:\Users\<用户名>\.config\tacky-borders\` |
| `windhawk/userprofile.json` | `C:\ProgramData\Windhawk\` |
| `windhawk/icon-resource-redirect/` | `C:\ProgramData\Windhawk\Engine\ModsWritable\mod-storage\icon-resource-redirect\` |
| `yasb/` | `C:\Users\<用户名>\.config\yasb\` |
| `wezterm/wezterm.lua` | `C:\Users\<用户名>\.config\wezterm\wezterm.lua` |
| `starship/starship.toml` | `C:\Users\<用户名>\.config\starship.toml` |
| `cava/config` | `C:\Users\<用户名>\.config\cava\config` |
| `fastfetch/` | `C:\Users\<用户名>\.config\fastfetch\` |

## 需要手动调整的路径

以下配置中包含本机硬编码路径，还原到其他机器时需修改：

- `yasb/config.yaml` — `state_storage_path` (VSCode globalStorage)、`image_path` (壁纸目录)、Weather API key、Wallpaper Engine 路径
- `wezterm/wezterm.lua` — MSYS2 路径（默认 `C:\msys64`）
- `glazewm/config.yaml` — Alt+Enter 启动的终端路径

## 透明度逻辑

- 聚焦窗口：100%（不透明）
- 非聚焦窗口：85%
- WezTerm / VSCode：始终 90%（不受焦点状态影响）
