# Nivlet for Mac 1.0.1 · Build 20

A smaller Apple Silicon package and clearer settings, with the existing tools retained.

## Requirements and downloads

- **Apple Silicon Mac (arm64), macOS 13.0 or later. Intel Macs (x86_64/x86) are not supported by this release.** Intel users can keep v1.0.0 / Build 18; the update feed retains that release and restricts Build 20 to arm64.
- Download either the DMG or ZIP. The ZIP is 10,953,691 bytes (about 10.45 MiB), **45.5% smaller** than Build 18. A SHA-256 file covers both downloads.
- No separate Hammerspoon installation is needed. Export saved settings before upgrading and keep the previous installer for recovery.

## Changes

- Removed Intel slices, reduced the bundled About icon, and stripped verified symbols while preserving required exports and matching debug symbols.
- Grouped General and Clipboard settings; moved secondary instructions into expandable sections and privacy information into About.
- Simplified the optional ⌘ + L Sleep label and removed its extra explanatory paragraph.
- Browser routing now shows a green status when Nivlet handles system web links. Default-browser setup buttons appear only when setup is needed; Accessibility refresh no longer changes this status.
- Put Website first in About links, removed duplicate separators, and improved compact English navigation and unsaved-change hints.
- Corrected the source extraction range in the tab-boundary regression test while retaining its assertions.
- Updated English/Chinese documentation and website compatibility information.

## Validation and limits

Release build, 18 Lua regression files, focused JavaScript/Python checks, and 12 isolated runtime WebView suites passed. ZIP CRC, DMG integrity, SHA-256, arm64 Mach-O inventory, strict ad-hoc code-signature verification, and Sparkle Ed25519 signature/tamper rejection were checked.

This release is **ad-hoc signed, without Developer ID signing or Apple notarization**. macOS may block first launch or require Accessibility permission again. Build 20 has not replaced the developer's installed Build 19; isolated UI checks do not prove a fresh installation. Update cancellation, network interruption, installation failure, other Macs/macOS versions, multiple displays, real Sleep and login startup remain incompletely validated.

---

## 中文更新说明

**1.0.1 / Build 20 仅支持 Apple Silicon Mac（arm64），要求 macOS 13.0 或更高版本；不支持 Intel（x86_64/x86）。** Intel 用户可继续保留 v1.0.0 / Build 18，更新通道保留旧版并限制 Build 20 的架构。

- 安装包移除 Intel 切片、缩小关于页图标、验证后裁剪符号；ZIP 约 10.45 MiB，比 Build 18 缩小 45.5%。
- 通用与剪贴板设置重新分组，次要说明折叠，本地与隐私说明移到关于页。
- 睡眠选项简化为“启用 ⌘ + L 睡眠”，移除下方说明。
- 浏览器默认接管状态显示绿色“已接管系统网页链接”；已接管时隐藏设置默认浏览器按钮，且状态不受辅助功能检测影响。
- 关于页官网排在首位，删除重复分隔线，优化窄窗口英文导航及未保存提示。
- 修复标签边界测试的代码截取范围，保留原断言；同步中英文文档和官网兼容性说明。

DMG、ZIP 任选一个下载，SHA-256 文件用于校验两份附件。升级前建议导出已保存配置并保留旧包。无需另外安装 Hammerspoon。

Release 构建、18 份 Lua 回归、相关 JavaScript/Python 检查、12 组隔离 Runtime WebView 验收和安装包完整性、arm64 架构、ad-hoc 签名、更新签名与篡改拒绝检查通过。仍无 Developer ID 签名和 Apple 公证；Build 20 未替换开发者本机 Build 19。新包安装、更新取消/断网/安装失败、跨机器、多屏、真实睡眠与登录启动仍未完整验收。
