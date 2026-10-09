# 开发与构建

面向修改源码或自行构建的开发者。日常使用见 [README](README.md)。

## 本地构建

需要完整 Xcode（完成许可确认与首次组件初始化）、Git、Python 3（含 PyYAML，上游文档构建脚本需要），以及命令行 Lua（仅用于检查和测试）。无需安装其他平台模拟器。上游依赖已随固定 checkout 提供，不在第一次构建时自动升级 CocoaPods。

```sh
git clone https://github.com/jrchhoo/Nivlet.git Nivlet
cd Nivlet
sh scripts/fetch-runtime.sh
lua tests/preferences.lua
lua tests/runtime.lua
lua tests/input_method.lua
lua tests/clipboard.lua
lua tests/clipboard_images.lua
lua tests/sys_info.lua
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer sh scripts/build-dev.sh
open build/DerivedData/Build/Products/Debug/Nivlet.app
```

fetch-runtime.sh 下载固定 Hammerspoon 1.1.1 commit 并应用 patch；已有 vendor 目录时拒绝覆盖。build-dev.sh 不启动 App，不改变全局 xcode-select。产物使用本地 ad-hoc 签名；不等于 Developer ID 签名或公证。


## 全部自动测试

```sh
for test_file in tests/*.lua; do lua "$test_file" || exit 1; done
git diff --check
```

## 实现与验证

- 内置定制 Hammerspoon 1.1.1 Runtime，独立 Bundle ID / preferences domain 为 `dev.local.DesktopToolkit`。
- bootstrap 位于 `~/Library/Application Support/dev.local.DesktopToolkit/init.lua`，只加载应用内置资源。
- 不读取个人 `~/.hammerspoon`，不自动 reload 个人配置。
- 浏览器仅声明 HTTP/HTTPS 处理能力，需用户手动选择系统默认浏览器；不接管 mailto。
- 当前设置内容使用 WebView，并非完整 AppKit 控件实现。
- 运行构建版和安装版时先核实实际进程路径，避免重复实例；替换前注意未持久化的剪贴板历史会随退出丢失。
- ad-hoc 签名变化可能要求重新授予辅助功能权限，仅操作 Nivlet 的权限条目。
- 分项证据和未验证流程见 [VALIDATION.md](VALIDATION.md)，以最新日期章节为准。

## 发布前仍需完成

稳定签名身份、Developer ID、公证、Gatekeeper 下载流程、其他 macOS / Intel / 多显示器验证，以及完整第三方 notices。当前已提供未公证的 arm64 预发布安装包，正式稳定版尚未发布。

## 名称兼容

品牌名为 Nivlet，展示名称为 Nivlet for Mac；仓库和应用文件名保持 Nivlet。已有开发用户的 Bundle ID、设置键和数据目录沿用 `dev.local.DesktopToolkit` / `desktoptoolkit.*`，避免改名清空设置与历史。它们是兼容标识，不是界面名称。上游 Hammerspoon 名称保留在来源、许可证和开发接口说明中。

## 首版候选包

产品版本读取根目录 `VERSION`，`NIVLET_BUILD_NUMBER` 指定 build（默认 1），避免显示 Runtime 上游版本。开发构建后运行 `sh scripts/package-local.sh`，在 `build/packages/` 生成本机 ZIP/DMG 与 SHA-256。当前为开发签名，不是正式分发链路；发布门槛见 [RELEASE-1.0.0.md](RELEASE-1.0.0.md)。

## 免费的 Release 构建准备

无需付费开发者账号即可验证 Release 配置；此流程仍使用 ad-hoc 签名，不启动或安装 App：

```sh
NIVLET_BUILD_NUMBER=4 DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer sh scripts/build-release.sh
NIVLET_BUILD_CONFIGURATION=Release sh scripts/package-local.sh
```

产物位于 `build/DerivedData/Build/Products/Release/Nivlet.app`，安装包名称带 `-release`，与 Debug 包区分。正式签名、公证及测试者验收见 [分发准备](DISTRIBUTION.md)，许可核查见 [第三方许可工程核查](THIRD-PARTY-AUDIT.md)。
