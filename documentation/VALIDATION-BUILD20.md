# 1.0.1 / Build 20 本地打包验收

日期：2026-10-10。此为 1.0.1 / Build 20 arm64 Release 发布包。本机安装仍为 1.0.0 / Build 19，未自动替换。

## 修改范围

- 设置页说明分层：通用、剪贴板、浏览器优先展示常用操作，教程按需展开，保留数据清空与本地明文缓存提醒。
- 睡眠开关简化为“启用 ⌘ + L 睡眠”；通用和关于页移除重复分隔线。
- 默认浏览器已接管时显示绿色“已接管系统网页链接”，仅保留重新检测；失去接管后恢复设置入口。浏览器状态与辅助功能刷新独立。
- 关于页链接顺序为官网、GitHub 项目、问题反馈、版本记录、MIT License。
- 中英双语、窄窗口导航、草稿状态提示及控件间距同步调整。
- 延续 arm64-only、小图标和主程序符号裁剪；包内安装说明明确不支持 Intel，版本文字取自 VERSION。

## 验证

- 18 项 Lua、3 项 Node、Dock 与第三方许可 Python 回归通过；日志 `build/validation-build20/regression.log`。
- 12 组真实 Runtime 隔离 WebView 回归通过，使用合成数据和无写入 bridge，不改个人设置或历史；日志 `build/validation-build20/ui-regression.log`。包括接管入口隐藏/恢复、权限刷新隔离、链接安全入口、草稿、取消、冲突及双语。
- 中文深色和英文浅色实际预览通过；检查 980×750 和 800×650 页面及滚动访问。
- Release 构建成功，包中 Toolkit 与回归所用源码逐字节一致；版本为 1.0.1 / Build 20。
- 101 个 Mach-O 全部 arm64；主程序 4,880,320 bytes，关于图标 160×160 / 30,197 bytes。裁剪前后外部符号、UUID 一致，外置 dSYM 匹配。
- 严格 ad-hoc codesign、ZIP CRC、DMG 校验和及 SHA-256 通过；包中无 Git、运行日志或 profile 文件。
- ZIP 10,953,691 bytes；DMG 12,812,038 bytes。文件前缀 `build/packages/Nivlet-1.0.1-build20-arm64-local-release`。
- `git diff --check` 通过。

## 边界

未启动新构建、未替换安装版。公开发行见 [v1.0.1](https://github.com/wivnelo/Nivlet/releases/tag/v1.0.1)。Build 19 已有的原生及用户实体验收不能当成 Build 20 新安装验收；新包安装启动、更新取消/断网/安装失败、跨机器、多屏、睡眠与真实登录启动仍按现有边界保留。此包是 ad-hoc 签名，未 Developer ID 签名或公证；发布前已生成 Sparkle Ed25519 签名，签名验证和篡改拒绝通过；appcast 限定 arm64，并保留旧 Build 18。
