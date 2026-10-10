<p align="center">
  <img src="assets/nivlet-icon.png" alt="Nivlet 应用图标" width="112">
</p>

<h1 align="center">Nivlet for Mac</h1>

<p align="center">
  <strong>让常用桌面操作更顺手。</strong><br>
  剪贴板、窗口管理、应用快捷启动与浏览器分流，集中在 Mac 菜单栏。
</p>

<p align="center">
  <strong>简体中文</strong> · <a href="README.en.md">English</a>
</p>

<p align="center">
  <a href="https://nivlet-for-mac.willhoo.chatgpt.site/">官网</a> ·
  <a href="https://github.com/jrchhoo/Nivlet/releases/latest">下载安装</a> ·
  <a href="USAGE.md">使用指南</a> ·
  <a href="https://github.com/jrchhoo/Nivlet/issues">问题反馈</a>
</p>

---

Nivlet 是一款免费开源的 macOS 菜单栏工具，将常用操作放在一处。按需启用功能、配置自己的快捷键，无需编写代码，也无需另外安装 Hammerspoon。

## 能做什么

| 功能 | 用法与亮点 |
| --- | --- |
| **剪贴板历史** | 留存文字与图片，支持搜索、缩略图、放大预览和 Option 直接粘贴；可暂停、排除应用与设置保留期限 |
| **窗口管理** | 29 项操作，覆盖半屏、四角、三分区、九宫格、居中、缩放、跨屏与恢复 |
| **应用快捷启动** | 自定义快捷键，启动应用或切到前台；支持更换应用、拖动排序与冲突检查 |
| **浏览器分流** | 按域名或来源应用选择浏览器，让不同链接去往合适的目标 |
| **输入法切换** | 为应用指定输入法，切换应用时自动切换 |
| **系统信息** | 菜单栏查看网速，按需展示 CPU、内存、磁盘、网络地址和日期 |
| **个性化与迁移** | 中英文、深浅色、标签排序，以及 JSON 配置导入导出 |

## 开始使用

1. 从 [GitHub Releases](https://github.com/jrchhoo/Nivlet/releases/latest) 下载 **DMG 或 ZIP**，任选一个。
2. 将 `Nivlet.app` 放入“应用程序”文件夹并打开。
3. 点击菜单栏 **N 图标 → 设置…**，启用需要的功能并配置规则。
4. 点击右下角 **保存设置**。切换页面会保留草稿，未保存的页面有橙点提示。

功能按需开启，快捷键由你配置。窗口管理和 Option 直接粘贴需要**辅助功能权限**；浏览器分流需要将 **Nivlet 设为默认浏览器**。

> **安装提示：**当前版本尚未经过 Developer ID 签名与 Apple 公证，macOS 可能阻止首次打开。请查看 [安装、升级与卸载指南](INSTALLATION.md)。最低声明 macOS 13.0；安装包包含 Apple Silicon 与 Intel 架构，Intel、其他 macOS 和多屏兼容性尚未全面验证。

## 本地处理，按需记录

无需账号。配置、剪贴板与系统信息在本机处理，不上传服务器；核心桌面工具可离线使用。打开网页与外部链接会联网。

剪贴板历史默认退出后清空，可选择跨重启保留；持久历史使用**本地明文缓存**，复制敏感内容前可以暂停记录。清空历史会同时清空系统当前剪贴板，操作前会提示确认。

## 了解更多

- [使用指南](USAGE.md) · [配置导入导出](CONFIGURATION.md)
- [版本记录](https://github.com/jrchhoo/Nivlet/releases) · [开发计划](ROADMAP.md)
- [开发与构建](DEVELOPMENT.md)

遇到问题或有建议，请提交 [GitHub Issue](https://github.com/jrchhoo/Nivlet/issues)，附上应用版本、macOS 版本与复现步骤。请勿上传敏感剪贴板、私人配置或凭据。

## 许可证与致谢

Nivlet 使用 [MIT License](LICENSE)。内置 Runtime 基于 [Hammerspoon](https://github.com/Hammerspoon/hammerspoon)；第三方组件保留各自许可证，见 [第三方声明](THIRD-PARTY-NOTICES.md)。
