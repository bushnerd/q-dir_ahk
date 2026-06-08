# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目性质

一个 AutoHotKey v1.1 单文件脚本（`q-dir_ahk.ahk`），为 Q-Dir 文件管理器以及其他常用 Windows 应用（TIM、OneMessage、MuMuPlayer、Telegram、Thunderbird、Obsidian、VSCode）重新映射快捷键，提升操作效率。脚本编译为独立 `q-dir_ahk.exe` 后台运行。

## 构建

构建依赖本地 Scoop 安装的 AutoHotKey v1.1（路径 `D:\scoop\apps\autohotkey1.1\current\`），由 `build.bat` 驱动：

- `build.bat` —— 编译 `q-dir_ahk.ahk` 为 `q-dir_ahk.exe`（使用 `ahk2exe.exe` /compress 0，关闭压缩以加快启动）
- `build.bat /t` —— 先启动脚本做手动测试（`-quiet` 模式），再编译；`errorlevel >= 1` 时打印 `testLogs\*` 后中止
- GitHub Actions（`.github/workflows/main.yml`）在 push/PR 到 `master` 时通过 `nekocodeX/GitHub-Ack2Exe` 自动构建并上传 release 资产

`.gitignore` 已排除 `q-dir_ahk.exe` 和 `.idea/`，但仓库当前仍 tracked 一份 `q-dir_ahk.exe`。

## VSCode 调试

`.vscode/launch.json` 已配置 AutoHotKey 调试器（F5 直接运行当前打开的 `.ahk` 文件），运行时使用 `AutoHotkeyU64.exe`。

## 脚本架构

`q-dir_ahk.ahk` 是单一扁平文件，所有逻辑顺序排列。理解它的关键在于以下三个贯穿全文的模式：

### 1. 上下文敏感的热键（`#If` / `#IfWinActive`）

AHK 1.1 的 `#If` 指令使紧跟其后的热键仅在指定窗口激活时生效。脚本以"目标进程"为分组单位——每一组 `#If WinActive("ahk_exe <ProcessName>.exe")` 块对应一个应用的快捷键集。修改或新增某个应用的热键时，定位到对应的 `#If` 块即可。

主要目标进程：

- `Q-Dir_x64.exe` —— 核心：四面板切换、导航键重映射、暂停/恢复
- `TIM.EXE` / `OneMessage.exe` —— `Ctrl+F` 模拟点击搜索框
- `MuMuPlayer.exe` —— 鼠标右键映射为 Esc（用于模拟器内返回）
- `Telegram.exe` / `thunderbird.exe` —— 通过 `!3` / `!1` 全局唤起或关闭
- `Obsidian.exe` / `code.exe` —— `Ctrl+Space` 切换输入法

### 2. Q-Dir 的状态机（`state` 变量）

`state` 变量跟踪 Q-Dir 是否处于"重命名输入"状态（`Normal` ↔ `Rename`），以避免在重命名时把 `←`/`→` 错误地映射为上一级/进入：

- 进入重命名：`~F2`（保留原 F2 行为，仅翻转 state）
- 退出重命名：`~Esc` 或 `~Enter`
- 仅当 `state = "Normal"` 时 `←`/`→` 才被重映射为 BackSpace/Enter

新增 Q-Dir 热键时必须把 `(state = "Normal")` 加入 `#If` 条件。

### 3. 按计算机名分支（`currentComputerName`）

`A_ComputerName` 在脚本启动时读取一次，存到 `currentComputerName`。P14（84 键笔记本布局）与其他机器（104 键）的物理键位不同，脚本据此为某些热键选择不同的源键。例如：

- P14：`!+Shift` 切到右上面板；其他机器：`!End`
- P14：`RShift` 打开 Quick-Links；其他机器：`End`
- P14：`/` 自动调整列宽；其他机器：`!PgDn`
- 此外 TIM/OneMessage 的搜索框点击坐标也按主机分别写死

修改前先确认目标键在 84 键与 104 键上的可用性，必要时保留 `if (currentComputerName = "P14")` 分支或新增分支。

## 修改注意事项

- 热键块结尾必须是 `Return`，且 `Return` 前不要缩进进 `#If` 内（脚本里很多块的 `Return` 是左对齐的——这是 AHK 1.1 的合法写法，但风格不一致，新增时保持与所在块一致即可）
- `Send, {LControl Down}` 序列必须成对释放（`{LControl Up}`），否则修饰键会卡住
- 路径硬编码为 `D:\scoop\...`（Telegram/Thunderbird 的可执行文件），改机器或改 scoop 路径时要同步更新
