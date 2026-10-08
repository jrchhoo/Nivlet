# DesktopToolkit

范围克制的 macOS 桌面工具，基于定制 Hammerspoon Runtime。运行 App 不需要另装 Hammerspoon 或编辑 Lua。

**当前为开发预览，尚未提供已签名、公证的下载安装包。** 当前验证平台为 Apple Silicon + Xcode 27.0，最低目标 macOS 13；其他系统尚未实测。

## 当前功能

- 共用菜单栏入口 `DT` 与图形设置界面。
- 窗口左半屏、右半屏、最大化、恢复原位置。
- 自定义快捷键：Control / Option / Command / Shift 与字母或数字。
- 窗口管理默认关闭，所有快捷键默认留空。
- 重复组合、系统占用和绑定失败时显示错误；其他 App 冲突可能无法检测。

剪贴板、输入法、应用启动等尚未加入。不会导入个人 Hammerspoon 配置。

## 本地构建

需要完整 Xcode（完成许可确认与首次组件初始化）、Git、Python 3（含 PyYAML，上游文档构建脚本需要），以及命令行 Lua（仅用于检查和测试）。无需安装其他平台模拟器。上游依赖已随固定 checkout 提供，不在第一次构建时自动升级 CocoaPods。

```sh
git clone https://github.com/jrchhoo/DesktopToolkit.git
cd DesktopToolkit
sh scripts/fetch-runtime.sh
lua tests/preferences.lua
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer sh scripts/build-dev.sh
open -n build/DerivedData/Build/Products/Debug/DesktopToolkit.app
```

fetch-runtime.sh 下载固定 Hammerspoon 1.1.1 commit 并应用 patch；已有 vendor 目录时拒绝覆盖。build-dev.sh 不启动 App，不改变全局 xcode-select。产物使用本地 ad-hoc 签名；不等于 Developer ID 签名或公证。

## 使用

1. 启动开发 App。首次需要在「系统设置 → 隐私与安全性 → 辅助功能」允许 DesktopToolkit；窗口管理依赖这项权限。
2. 点击菜单栏 `DT → 设置…`。
3. 勾选启用窗口管理，选择每项操作的修饰键并填入一个字母或数字，保存。
4. 聚焦普通应用窗口后按对应组合。恢复原位置仅针对本次运行中已调整的窗口。
5. 留空按键可解除该操作的绑定；关闭模块并保存会解除所有绑定。

不要照搬个人 Hammerspoon 已使用的快捷键。无默认睡眠快捷键，无浏览器路由，无滚轮监听，无剪贴板记录。

## 隔离与数据

- Bundle ID / preferences domain：`dev.local.DesktopToolkit`（开发身份，正式发布前会确定稳定身份）。
- 固定 bootstrap：`~/Library/Application Support/dev.local.DesktopToolkit/init.lua`。
- 设置保存在该 App 独立 preferences domain，bootstrap 只加载 App 内置资源。
- 不读取 `~/.hammerspoon`，不自动 reload 个人配置，不更改默认浏览器。
- 无应用代码主动请求公网接口，移除了上游 URL handlers、Services 和更新源，关闭上游 crash reporting 初始化。
- 退出 App 会解除快捷键。移除 App 后，可在系统设置撤销其辅助功能权限；偏好和 bootstrap 保留，方便重新安装。

## 验证与限制

基础 Runtime 已验证：内置 Lua 加载、独立目录/domain、与个人 Hammerspoon 并行、测试窗口实际移动缩放、实体键盘快捷键回调。自动化合成快捷键没有触发回调，不能替代实体键盘验收。

跨屏布局、第三方 App 的窗口限制、全屏/Space、多个窗口恢复与 Intel 尚需更多实测。不支持全屏窗口；应用的最小尺寸可能限制调整结果。UI 中仍残留部分 Hammerspoon 原生菜单文字。此版本不是生产就绪的安装包。

## 源码与许可

Toolkit/ 和项目脚本为新实现；没有复制个人配置模块或不明许可的剪贴板代码。Runtime 按固定上游版本获取，vendor 和 build 不进入本项目 Git。

Hammerspoon 主项目使用 MIT；详见 [上游许可证](https://github.com/Hammerspoon/hammerspoon/blob/1.1.1/LICENSE)。Lua、CocoaPods 等依赖各自保留其许可，公开分发 Runtime 二进制前需完整打包第三方 notices。当前只发布本项目源码和 patch，不发布 Runtime 安装包。

### 开发签名说明
当前 ad-hoc 签名随构建内容变化，macOS 可能要求重新授权辅助功能。只为
DesktopToolkit 授权，不更改原 Hammerspoon 的条目。正式发布需要稳定签名与公证。

### 设置界面验收
已验证界面实际显示、重复快捷键拒绝、关闭状态保存、未授权时拒绝启用。
已在开发版自己的普通窗口验证左/右半屏、最大化和恢复原位置，设置保存后的绑定注册与关闭后的删除也已验证。实体键盘回调已在基础 Runtime 阶段通过；尚未对所有第三方 App 做端到端验证。

具体证据与边界见 [VALIDATION.md](VALIDATION.md)。
