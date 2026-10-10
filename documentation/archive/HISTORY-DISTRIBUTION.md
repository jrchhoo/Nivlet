# 分发历史记录

> 历史参考，不代表当前基准；当前入口见 [BASELINE](../../BASELINE.md)。



## Build 18 更新通道

使用固定 Sparkle 2.10.0 官方包（SHA-256 固定在 prepare-updater.sh），替换 Runtime 的 2.6.4。官网源为 docs/appcast.xml，更新包来自 GitHub Releases；私钥在 Keychain 账号 dev.local.DesktopToolkit.updates，严禁提交或输出私钥。公钥写入 Info.plist。新环境首次发布需自行安全配置该签名密钥；普通源码构建不需要私钥。

发布顺序：增加 NIVLET_BUILD_NUMBER → 构建 → 打包 → generate-update-feed.py <ZIP> → tests/updates.py → 上传新附件 → 推送 appcast → 实测旧版更新与最新检查 → 保留回滚副本后移除过期下载附件。新 release tag 应按版本递增，禁止重写历史 tag。当前 v1.0.0 附件经用户授权更新为 Build 18，GitHub 自动生成的源码归档仍对应原 tag；更新实现源码见 main 的 b0ed084 及后续提交。

```sh
python3 scripts/generate-update-feed.py build/packages/Nivlet-1.0.0-build18-x86_64-arm64-local-release.zip
python3 tests/updates.py
```

自动覆盖更新的 Ed25519 签名不能替代 Apple Developer ID/公证；当前 ad-hoc 更新后辅助功能权限仍可能失效。钥匙串私钥须由维护者另行安全备份，丢失后不能继续给现有公钥客户端签发更新。

## GitHub 1.0.0 发行基准（2026-10-10）

用户决定暂不考虑 App Store，采用无需付费账号的 GitHub 正式发行路线。v1.0.0 使用应用 1.0.0 / Build 14，功能与已验收 Build 13 一致，包内补齐 81 份许可文件；rc.5 保留历史。本机 /Applications/Nivlet.app 继续保留 Build 13，不替换、不重签名，不修改个人配置。

GitHub 正式发行状态与 Apple 信任链独立：Build 14 仍为 ad-hoc，未 Developer ID 签名、未公证，首次下载/Gatekeeper、Intel、其他机器与多屏仍未全面验证。完整许可法律审查不能由自动收集替代。Build 14 完整 Release 构建、全部 Lua 回归、许可原文回归、原生 Dock 与按键测试通过；104 个 Mach-O 均含双架构，严格签名、ZIP CRC、DMG 和 SHA-256 通过。未启动或安装 Build 14。正式发布说明见 [RELEASE-v1.0.0.md](../RELEASE-v1.0.0.md)。以下旧状态为历史记录。


> 2026-10-10 后续核查发现原脚本漏收 LICENSE.SimplePing、LICENSE.timeout3 和 LICENSE-examples。收集规则已修复并补回归，现收集 81 个许可文件；补充原文见 [THIRD-PARTY-SUPPLEMENT.md](THIRD-PARTY-SUPPLEMENT.md)。补充声明已作为 rc.5 独立附件发布，发布说明已同步更新；当前安装版及原 DMG/ZIP 仍为原声明，尚未重新打包；不能将此前“文件一致”解读为声明完整。



## 新用户补充验收（2026-10-10）

用户已建立另一 macOS 用户；系统检测已下载 App 与共享的 /Applications/Nivlet.app 一致，因此未覆盖安装。在无原用户配置的环境下，用户重新配置各模块并反馈均已测试，暂无明显重大问题。此证据确认同机新用户配置与日常使用，不等同于首次安装/Gatekeeper、其他硬件或 macOS 的验收。

用户补充登录自启动目前暂无明显问题，要求暂不继续排查；从当前阻塞项移至观察，复发再收集证据。没有单独的注销登录测试记录，不将其写成已独立验证全部登录场景。当前 rc.5 / Build 13 作为冻结预发布基准继续使用，GitHub 已发布，无需重打包或重复发布相同二进制。

> 当前基准为已发布的 v1.0.0-rc.5 / Build 13；最新状态与下一步见 [BASELINE.md](../../BASELINE.md)。以下阶段记录保留当时状态。


本清单区分免费可完成的工程准备和需要 Apple Developer Program 的正式分发步骤。GitHub 测试包不等于已通过 Apple 公证的稳定版。

## 免费准备当前结果

已补齐 [安装、升级与卸载指南](../INSTALLATION.md)；Build 13 的声明一致性、ZIP 路径筛查、101 个 Mach-O 架构及严格签名复核通过，详见 [许可工程核查](../THIRD-PARTY-AUDIT.md)。首次下载/Gatekeeper、完整特殊许可条款、跨机器兼容性仍开放。无需重打包或替换当前应用。

## 无付费账号的本地构建

已按 DEVELOPMENT.md 准备固定 Runtime 和 Xcode 后运行：

```sh
NIVLET_BUILD_NUMBER=14 DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer sh scripts/build-release.sh
NIVLET_BUILD_CONFIGURATION=Release sh scripts/package-local.sh
```

Release 与 Debug 共用资源注入、版本、许可收集和临时签名流程；产物目录分别为 `build/DerivedData/Build/Products/Release/` 和 `Debug/`。Release 使用上游优化配置，显式禁用上游团队签名及开发 scheme 的 Address/Undefined Behavior Sanitizer，修正 Release 品牌配置路径。`build-release.sh` 不启动、不安装应用，也不改系统默认浏览器、权限或个人配置。

Release 配置不等于正式分发签名：这里仍是 ad-hoc，不能据此声称已公证。Release 包文件名增加 `-release`，避免覆盖已有 Debug 包；具体架构以实际包检查结果为准，不能仅凭构建配置声称支持 Intel。

## 本机工程检查

- [ ] Release 完整构建完成，版本/build 与预期一致。
- [ ] 严格签名检查通过；注明 ad-hoc 或 Developer ID，不能混淆。
- [ ] 主程序、动态库、Framework 和辅助程序架构及链接依赖已检查，不依赖开发机器的 Homebrew 或绝对路径。
- [ ] ZIP CRC、DMG 完整性与 SHA-256 通过，解包后名称与内置资源一致。
- [ ] 包内无个人迁移 JSON、剪贴板历史、测试数据、凭据或源码 checkout。
- [ ] 许可声明与当前依赖版本对应，见 THIRD-PARTY-AUDIT.md。

## 从 GitHub 下载的首次安装验收

建议在另一台 Mac 或干净测试用户执行；本机已有授权与配置不能代替首次安装测试。仅测试准备支持的系统和架构，不操作测试者的个人 Hammerspoon 配置。

1. 记录下载链接、文件 SHA-256、Mac 芯片、macOS 版本及 App 版本/build。
2. 用浏览器实际下载，不用本机复制代替；记录系统拦截提示。当前未公证包可能被拦截，不要求测试者全局关闭 Gatekeeper。
3. 将 App 拖入 Applications，首次启动，确认只运行一份且未要求另装 Hammerspoon。
4. 确认默认关闭的模块没有自动记录、注册个人快捷键或接管默认浏览器。
5. 检查菜单入口、设置、深浅色、中英文、保存后生效及通用/关于固定标签。
6. 自行开启辅助功能后，验证窗口布局/恢复和实体 Option 点击粘贴；用临时测试内容，完成后清理。
7. 启用剪贴板后复制测试文字与图片，验证搜索、缩略图、悬停/放大预览、暂停及清空确认。
8. 验证应用启动、输入法切换、系统信息开关与菜单恢复；有多显示器时另测跨屏。
9. 浏览器测试前记录原默认浏览器，用户主动选择 Nivlet 后验证域名及来源分流、冷启动链接；完成后按用户意愿恢复。
10. 导出测试配置，检查不含历史和系统授权；导入后核对规则，损坏 JSON 应提示且不破坏旧配置。

## 升级与恢复验收

1. 导出已保存配置作为备份，记录启用的模块、排序、持久历史设置和版本。默认不持久的历史会随退出丢失，不承诺保留。
2. 退出旧 App，保留旧安装包，仅替换 Applications 中的 App，不删除数据目录。
3. 启动新版，确认保存的配置、快捷键和标签顺序仍在；已启用持久化的历史按原时间/数量限制恢复。
4. 检查辅助功能实际有效性，开发签名更新可能需要重新授权；不能只看旧系统开关。
5. 若失败，退出新版并恢复旧 App；配置恢复使用备份和兼容的导入流程。涉及未来格式变更时必须先验证降级兼容，不能直接保证可回退。

## 测试结果模板

```text
测试日期：
下载链接 / SHA-256：
应用版本 / Build / 签名类型：
Mac 芯片 / macOS / 屏幕数量：
首次安装或升级（旧版本）：
系统拦截及授权情况：
通过项目：
失败项目、复现步骤与实际结果：
是否恢复原默认浏览器及清理测试内容：
```

不要附带敏感剪贴板、完整个人配置或凭据。未执行的项目填写“未测试”，不要勾选通过。

## 付费会员开通后的工作

- 由账号持有人注册个人 Apple Developer Program、完成核验与付款。
- 创建自己的 Developer ID Application 证书，安全保管私钥；不使用上游团队身份，不提交证书私钥到 Git。
- 按由内到外顺序签名嵌套可执行组件，启用 Hardened Runtime 并按实际功能核查最小 entitlements；不能直接照搬上游全部权限。
- 使用 `notarytool` 提交，检查结果与日志；通过后用 `stapler` 附加凭证，再校验最终分发包。
- 重新从 GitHub 下载最终包测试 Gatekeeper、首次授权与升级。公证通过不能替代功能验收。

官方入口：[Developer ID](https://developer.apple.com/developer-id/)、[公证说明](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)。

## 本机准备记录（2026-10-09）

本地 Release 候选为 1.0.0 / Build 4，已安装到原路径并启动，关于页已确认版本；用户重新授权后，通用页已显示辅助功能权限开启。旧 App 与已保存数据已本地备份。Build 4 未上传安装包，当前公开下载仍为 rc.3 / Build 3；源码阶段标签为 v1.0.0-rc.4。整体人工测试未完成。

- Release 完整构建通过；修复上游 Release 的品牌配置引用路径，产物名称和 Bundle ID 保持 Nivlet 兼容身份。
- 使用专用 Release scheme，排除 ASan/UBSan 调试运行库。检查 101 个 Mach-O 文件，全部含 x86_64 与 arm64；未发现指向开发者目录、Homebrew、/usr/local 的外部加载依赖。动态库自身 LC_ID_DYLIB 不作为外部依赖统计。
- 严格 ad-hoc 签名检查通过；17 个 Lua 套件、两项 Node 按键/标签回归通过。
- 这些检查不能证明 Intel 已可用，也不能代替真实运行、Gatekeeper 或另一台 Mac 的验收。

- Build 4 ZIP/DMG 已重新生成并通过 ZIP CRC、DMG 完整性与 SHA-256 校验；包内设置页、版本和许可声明一致，未包含个人迁移配置、剪贴板历史或 Sanitizer 运行库。

## 本机 Build 5 接链验收补记（2026-10-10）

备份后已安装 Build 5，浏览器闪现本机验收通过，见 STAGE-2026-10-10.md。安装升级验收必须核对实际运行路径：相同 Bundle ID 的备份和 Debug 副本可能被 LaunchServices 选中，不能只看应用显示名称或链接最终成功打开。备份优先使用压缩包，避免多个可执行 App 副本长期登记；不为整理登记删除用户备份。本轮取消非安装副本登记但保留文件，未改变默认浏览器标识。Developer ID、公证及跨机器验收状态不变。

## 开发与发布顺序（2026-10-10）

当前先完善现有功能与 UI、修复 Bug 并完成最终候选回归，再进行发布验收与发布；新增配置重载、WAN、截图、官网/更新服务和捐赠在发布之后开发。具体阶段 A/B/C、顺序和门槛以 ROADMAP.md 为准。发布依赖未满足时明确记录阻塞，不将预发布称为正式稳定版；新增功能不自动提前。此计划调整不代表授权上传、push 或替换已安装应用。

## 阶段 A 当前状态（2026-10-10）

本机已安装 1.0.0 / Build 7 Release，公开下载仍 rc.3 / Build 3，Git 检查点仍 rc.4，本轮未提交或发布。A1 实体启动提示用户通过；A2 原生更换应用 JSON 回传错误修复，目标替换/快捷键保留/重复拦截/取消恢复通过；A3 通用页主动重新检测确认权限开启，其余模块重复权限区域移除；A4 用户确认菜单顺序和间距正常。输入法与启动规则排序、当前页取消回归通过，用户确认拖动可用。

最新去箭头、仅保留拖动手柄的 UI 调整尚仅源码，11/11 隔离真实 WKWebView 回归通过，待最终候选安装确认。现有安装窗口存在用户未保存草稿，未擅自保存或取消。完整最终版本窗口/直接粘贴、跨机器、多屏、Intel、Developer ID/公证及许可人工复核不能由这些针对性验收替代；正式分发门槛仍按 DISTRIBUTION.md。此前版本状态为过程记录，以本节和 ROADMAP.md 当前接续点为准。

## Build 8 安装验收（2026-10-10）

用户确认草稿已处理后，正常退出并备份 Build 7 ZIP、Application Support、defaults 至本机 Backups/build8-before-install.cewmxx7j，覆盖安装 Build 8，版本与严格签名通过。安装版实测系统信息 CPU 开关产生 Tab 未保存标记和底部说明，切到应用启动页按钮置灰且系统信息标记保留，返回取消恢复 CPU 与清除标记；未保存测试修改。两模块箭头已从源码与包中移除，只保留手柄。11/11 WKWebView、Lua/Node 回归通过。辅助功能因重新签名再次显示未开启，已请求用户开启，尚待复核。GitHub 下载仍 rc.3，本轮未提交或上传；关闭/退出草稿提醒仍为待办。

Build 8 权限收尾：用户重新开启后，通用页点击“重新检测”，实际返回“检测完成：辅助功能权限已开启”。权限状态复核通过，本次未重新签名或替换应用。此结论仅证明权限检测状态，不等同于 Build 8 窗口管理与 Option 直接粘贴全量复验。

## Build 8 本地分发包核查（2026-10-10）

已生成 build/packages/Nivlet-1.0.0-build8-x86_64-arm64-local-release.zip、同名 DMG 与 .sha256。ZIP CRC、DMG 完整性、SHA-256 通过；ZIP 内 settings.html、init.lua、合并许可声明与安装版逐字节一致，无 tests/.git/Backups 目录。docs.json、lua.json 为 Runtime 文档资源，不是个人配置。104 个 Mach-O 文件均含 x86_64 与 arm64；解析 LC_LOAD/WEAK/REEXPORT/UPWARD 后未发现非系统绝对加载依赖。otool -L 中扩展库 /usr/local/lib 自身 ID 属 LC_ID_DYLIB，不应误判为加载依赖。此静态核查不等于 Intel/其他机器运行通过，仍须验证包内相对依赖解析与实际安装。

包仍为 ad-hoc，本轮未上传 GitHub、未提交推送、未再次替换安装应用。Developer ID/公证、Gatekeeper 下载验收、其他机器/系统与 Intel、多屏和第三方许可完整人工复核仍待完成；本机 Build 8 全部窗口布局/实体 Option 粘贴尚未重跑。关闭/退出草稿提醒继续作为未实现项。

## Build 9：快捷键 UI 与安装目录收敛（2026-10-10）

当前正式本机安装位置改为 /Applications/Nivlet.app（1.0.0 / Build 9 Release）。按用户授权备份 Build 8、本地 Application Support、defaults 于 Backups/build9-before-migration.ynjydf8m 后安装，严格签名通过；实际运行路径已核对。旧 ~/Applications/Nivlet.app 在 ZIP CRC 校验后移除，4 个历史 App 备份改为 ZIP 并取消登记，个人配置与历史未删除。12 个旧安装包文件移至 Backups/old-packages-build9.9u4vtha2 可恢复归档，build/packages 仅保留 Build 9 ZIP、DMG、SHA-256。Debug 与开发构建不等于安装版，不能用于接链验收。

快捷键 UI 统一修饰键间距、70×30 按键框，窗口管理右侧组合紧邻并对齐；方向键与 Return 显示 ← → ↑ ↓ ↩，后端沿用已支持的别名规范化。通用睡眠文字为 ⌘ + L / Command + L。11/11 WKWebView、全部 Lua、键盘录入回归通过；安装版原生显示核查通过。ZIP CRC、DMG 完整性、SHA-256 通过。当前仍 ad-hoc，未上传 GitHub/提交推送；辅助功能检测未开启，已请用户对 /Applications 新路径重新授权，待复核。

Build 9 权限收尾：用户为 /Applications/Nivlet.app 重新授权后，实际设置页点击重新检测，显示“检测完成：辅助功能权限已开启”。新路径权限状态复核通过，本轮未再次替换或签名；窗口/实体粘贴的完整操作复验仍需按验收清单单独确认。

## Build 10：设置窗口的 Dock 生命周期

打开或重开设置前调用 hs.dockicon.show，原生窗口 closing 回调隐藏 Dock，设置继续采用普通窗口层级；关闭不等于退出菜单栏工具。Runtime 新增 dock-settings-lifecycle.patch，将 Dock 可见性改为进程内状态，不写入上游偏好，避免上次打开设置后退出导致下次后台接链继承显示状态。保留 browser-background.patch 的隐藏不主动激活路径。fetch-runtime 可重复应用新补丁。全部 Lua、窗口生命周期与实际 Runtime Dock 隔离编译回归通过。

Build 10 Release 构建/签名通过，安装前无未保存草稿，正常退出并备份 Build 9 ZIP、数据和偏好至 Backups/build10-before-install.yk4mosu2，更新 /Applications/Nivlet.app 并启动。ZIP/DMG/SHA-256 校验通过，旧 Build 9 安装包归档于同备份 previous-packages；当前 packages 仅保留 Build 10。Dock 工具读取超时，已请求用户实测 Dock、Command+Tab、关闭/重开恢复，不能宣称真实视觉验收已通过；辅助功能待用户重新开启与复核。未提交推送或上传 GitHub，未改个人 Hammerspoon。


## Build 11：登录项失败入口与品牌标题栏

Build 10 的 Dock、Command+Tab、关闭与重开设置行为已由用户确认正常，辅助功能也由用户确认开启。Build 11 已备份后安装至 /Applications/Nivlet.app；备份目录为 Backups/build11-before-install.qawfx4v1，配置与历史保留。

- 登录项保存失败时保留草稿并显示“打开登录项设置…”按钮，通过系统 URL 打开 macOS 登录项；成功保存后隐藏入口。中文及英文文案同步。
- 旧 Runtime 使用 LSSharedFileList，当前失败只说明写入后读回不一致；未确认具体系统原因，也未迁移自动启动 API。系统登录项深链接的实际落点和注销登录后自启动仍待验收。
- 原生标题改为 Nivlet for Mac，新增 16px App 图标；实际安装版截图和 Accessibility 均已确认标题与图标显示正常。
- Release 构建、严格签名、12/12 WKWebView 回归通过，包括登录项失败保留草稿、显示入口与成功后隐藏。构建测试不替代真实登录验收。
- Build 11 开发签名替换后辅助功能显示未开启，待用户重新开启；本轮未修改个人 Hammerspoon，未提交推送或发布 GitHub。


Build 12 安装验收（2026-10-10）：用户明确授权后，确认无未保存草稿，正常退出 Build 11；备份 App ZIP（CRC 通过）、Application Support 和 defaults 至 Backups/build12-before-install.vvfc2eed，安装 /Applications/Nivlet.app 并通过严格签名检查。实际启动截图确认 16px 图标与 Nivlet for Mac 紧邻、整体居中，红绿灯保持左侧，Accessibility 可读取图标与标题。安装后辅助功能显示未开启，待重新授权。本轮未再次生成分发包，现有本地包仍为 Build 11；未推送 GitHub。


## Build 13 / v1.0.0-rc.5 发布候选

浏览器页标题统一为“浏览器分流规则”；新增用户主动发起的“设为默认浏览器…”系统请求、重新检测及默认浏览器系统设置入口。未匹配浏览器的标签改为“未匹配时使用”。已接管时隐藏重复设置按钮。默认浏览器未自动修改；尚未实际重测从其他浏览器切换为 Nivlet 的系统确认框。

Release Build 13 已备份 Build 12、本地数据与偏好后安装；备份为 Backups/build13-before-install.h0ex0n1k。实际页面标题、已接管状态、重新检测通过；系统设置备用入口实测落到“桌面与程序坞”，默认网页浏览器为 Nivlet。全部 Lua、原生 Dock、键盘录入及 12/12 WKWebView 回归通过，ZIP CRC、DMG、SHA-256 通过。最终辅助功能已在安装版复核开启；用户确认 TG 链接由 Chrome 打开且 Nivlet 设置不闪现，本机候选验收通过。

仍为 ad-hoc 预发布候选；Developer ID、公证、Gatekeeper 与跨机器验收未完成。登录项原注册失败根因与真实重新登录验证未关闭，不宣称全部缺陷已清零。个人 Hammerspoon 与私人配置未纳入发布包。
