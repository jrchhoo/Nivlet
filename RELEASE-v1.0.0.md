# Nivlet for Mac 1.0.0

首个 GitHub 正式发行版，应用 1.0.0 / Build 18。

剪贴板文字与图片历史、29 项窗口操作、系统信息、按应用切换输入法、快捷启动与浏览器分流，集中在 Mac 菜单栏。支持中英文、深浅色、规则排序和 JSON 配置导入导出。

## 本版变化

- 内置项目、反馈、版本记录和许可证链接统一为 `wivnelo/Nivlet`。
- 关于页加入官网入口，统一链接区布局。
- 加入 Sparkle 2.10.0 签名更新：手动检查，确认后自动下载、覆盖安装与重启；有未保存草稿时先提示处理。
- 同一版本号也按 Build 比较更新；默认不后台检查、不静默安装。

- 沿用 rc.5 / Build 13 已验收的功能，不加入新功能。
- 将补充的第三方许可原文合入应用内声明，共收集 81 份许可文件。
- 同机另一 macOS 用户重新配置与使用暂无重大问题；该结果不等于跨机器验收。

## 安装与限制

下载 DMG，将 Nivlet.app 拖入 Applications；无需单独安装 Hammerspoon。升级前保存草稿并导出配置，退出旧应用后替换 App。窗口管理与 Option 直接粘贴需要辅助功能；浏览器分流需要主动将 Nivlet 设为默认浏览器。

**本包仍为 ad-hoc 签名，未 Developer ID 签名及 Apple 公证，macOS 可能阻止首次打开。** 请按 [安装指南](https://github.com/wivnelo/Nivlet/blob/main/INSTALLATION.md) 操作，不要全局关闭 Gatekeeper。

二进制包含 arm64 与 x86_64；本机 Apple Silicon 已有使用证据，Intel、其他 macOS、跨机器及多屏未全面验证。最低声明 macOS 13.0。配置与剪贴板保存在本机。

官网已上线：https://wivnelo.github.io/Nivlet/ 。配置文件重载、WAN IP 与截图工具尚未实现。问题请通过 GitHub Issues 反馈，不上传私人配置或敏感剪贴板。

## English

First GitHub release, app 1.0.0 / Build 18. It preserves the accepted rc.5 features and embeds the complete collected third-party notices (81 license files).

Build 18 updates all built-in GitHub links to `wivnelo/Nivlet`, adds the website entry and signed Sparkle 2.10.0 updates. Check manually, then confirm to download, replace and restart. Unsaved settings must be saved or cancelled first. Background checks and silent installation are disabled by default.

Download the DMG and drag Nivlet.app to Applications. No separate Hammerspoon is required. Save drafts and export settings before upgrading. Accessibility is required for window management and Option-paste; browser routing requires choosing Nivlet as the default browser.

**Ad-hoc signed; no Developer ID signature or Apple notarization. macOS may block first launch.** See the installation guide. The binary contains arm64 and x86_64; Intel, other Macs/macOS versions and multiple displays are not fully validated. Declared minimum: macOS 13.0.
