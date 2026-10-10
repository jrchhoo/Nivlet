# Nivlet for Mac 1.0.0 候选版说明


## 新用户补充验收（2026-10-10）

用户已建立另一 macOS 用户；系统检测已下载 App 与共享的 /Applications/Nivlet.app 一致，因此未覆盖安装。在无原用户配置的环境下，用户重新配置各模块并反馈均已测试，暂无明显重大问题。此证据确认同机新用户配置与日常使用，不等同于首次安装/Gatekeeper、其他硬件或 macOS 的验收。

用户补充登录自启动目前暂无明显问题，要求暂不继续排查；从当前阻塞项移至观察，复发再收集证据。没有单独的注销登录测试记录，不将其写成已独立验证全部登录场景。当前 rc.5 / Build 13 作为冻结预发布基准继续使用，GitHub 已发布，无需重打包或重复发布相同二进制。

当前已发布 **v1.0.0-rc.5 / 应用 1.0.0 / Build 13（Release）**，提交 `44267c6`。本机安装与公开附件一致；最终辅助功能与 TG→Chrome 无闪现验收通过。仍为 ad-hoc 预发布候选，未完成公证和跨机器验收。

当前状态、清理结果及后续优先级以 [BASELINE.md](BASELINE.md) 为准；下方按日期保留阶段证据，旧的待验描述不表示当前仍开放。

## 包含的功能

- 独立内置 Runtime，与个人 Hammerspoon 配置、历史隔离。
- 29 项窗口操作、方向键及特殊按键录入、快捷键冲突检查；按应用切换输入法、快捷启动应用。
- 文本/图片剪贴板：分组菜单、缩略图和悬停/放大预览、搜索、暂停、应用排除、可选本地持久化、清空历史及系统剪贴板。
- 文本默认 50 条、10–100 条下拉；保留 30 分钟至 24 小时或永久，兼容旧自定义值。
- 系统信息显示控制、设置页实时值、MAC 隐藏提示；菜单恢复多项后的截断修复。
- 通用固定最左、关于固定最右，其余标签拖动排序；中英文与跟随系统、深浅色、登录启动、权限检测、单色主图标。
- 每页统一右下角保存，通用开关保存后生效，标签切换保留草稿并提示未保存修改；剪贴板配置与菜单快捷键合并保存。
- 可选 Command+L 睡眠，默认关闭，提示覆盖应用内同名快捷键并检查冲突。
- JSON 完整/部分导入导出、默认示例、预检及失败恢复。登录项、系统权限、系统默认浏览器和历史不进入导出文件。

截图、官网、更新服务和捐赠留到后续版本。

## 验收结果（2026-10-09）

- 17 个 Lua 套件、两项 Node 按键/标签边界回归通过；九组真实 WebView 回归通过，覆盖统一保存、草稿、冲突、配置导入、中英文和剪贴板展示。
- 完整 Xcode Debug 构建、严格签名、ZIP/DMG 完整性及 SHA-256 校验通过；安装版与源 HTML 一致。
- 升级保留配置、历史与未保存输入。最终签名重新授权后，跨进程有效辅助功能检测、Safari 左右半屏/最大化/恢复、CotEditor 真实目标文本粘贴通过，随后恢复测试文字、系统剪贴板和历史。
- 用户确认菜单缩略图、T 方框和悬停预览正常；Build 2 用户确认搜索框可正常输入，关闭原 P0。原间歇失效条件未稳定复现，不能将焦点改动断言为已确认根因；复发时再跟踪。
- 浏览器设置提示系统接管状态；修正 Runtime 发送方 PID 读取。用户把系统默认网页浏览器设为 Nivlet 后，确认 Telegram 来源规则由 Chrome 打开。
- 睡眠注册、冲突、解绑、导入所有权转移和失败恢复由模拟测试覆盖，未实际让电脑睡眠。

## 剩余限制与后续事项

- 正式分发仍需 Developer ID、Release 构建、公证、下载后的 Gatekeeper 和干净用户/其他机器安装升级验证。本机目前没有可用 Developer ID 身份。
- 实体鼠标 Option 点击、多显示器、Intel 和其他 macOS 尚未完整验证；回调真实粘贴通过不能替代实体点击验收。
- 菜单排列非阻塞待核查：网速与剪贴板相邻，剪贴板与 N 主图标之间测得约 48pt 间隔；未确定是否有其他状态项占位，不认定为额外空白，不据此修改代码。
- 包内保留上游声明、依赖 acknowledgements、78 个许可文件和 Lua README；已检查收集结果与打包文件一致。此检查不等同于法律审查。

## 安装包和代码版本

安装包见 [v1.0.0-rc.3 预发布](https://github.com/jrchhoo/Nivlet/releases/tag/v1.0.0-rc.3)，提供 DMG、ZIP 和 SHA-256 文件。仅提供 arm64 包，采用 ad-hoc 开发签名，未公证；下载后可能被 Gatekeeper 阻止。包声明最低 macOS 13.0，但其他 macOS 和其他机器尚未验收。

本机文件位于被 Git 忽略的 `build/packages/`。Git 不收录安装包；仅将上述三个发布文件上传至 Release。包中不含个人迁移配置或剪贴板缓存。旧 v1.0.0-rc.2 标签与发布说明保留。

安装时将 Nivlet.app 拖入 Applications。升级只替换 App，保留数据目录；开发签名变更可能要求重新授权辅助功能。所有可编辑设置在窗口右下角保存，权限检测和历史操作即时执行。来源应用分流需将 macOS 默认网页浏览器选为 Nivlet。

`VERSION` 为产品版本来源，`NIVLET_BUILD_NUMBER` 指定 build。重现本机 Build 4 使用 `NIVLET_BUILD_NUMBER=4 sh scripts/build-release.sh`，再运行 `NIVLET_BUILD_CONFIGURATION=Release sh scripts/package-local.sh`（完整 Xcode 环境按 DEVELOPMENT.md 设置）。详细流程见 [DEVELOPMENT.md](DEVELOPMENT.md)。

## Build 4 阶段补记（2026-10-09）

17 个 Lua 套件及两项 Node 回归通过；Release 完整构建、严格 ad-hoc 签名、ZIP/DMG 完整性及 SHA-256 通过。101 个 Mach-O 文件均含 x86_64/arm64，未发现开发机外部加载路径或 ASan/UBSan 运行库；不能据此声称 Intel 或其他 Mac 已验收。此前 Build 2 的真实窗口/粘贴证据不能替代 Build 4 完整人工验收。

浏览器分流闪现已在 2026-10-10 完成针对性源码修复及隔离回归：恢复隐藏 Dock 策略时不再主动激活 App；未安装候选 Build 5 Release 构建与严格签名检查通过。用户确认闪现前设置窗口仍打开且被遮挡，与该激活路径吻合，但真实接链视觉验收尚未完成，P1 保持开放，详见 STAGE-2026-10-10.md。应用启动即时反馈、目标应用替换、权限区域收敛、WAN 查询和可编辑默认配置均仅进入计划，见 ROADMAP.md。第三方许可已补工程核查文档，完整人工复核未关闭。

## Build 5 修复验收补记（2026-10-10）

本机现为 1.0.0 / Build 5（Release），备份 Build 4 后安装；用户重新授权，通用页确认辅助功能已开启。接链恢复隐藏 Dock 状态时不再主动激活 App。17 个 Lua 套件、两项 Node 回归及新增 Dock 激活隔离回归通过，完整 Release 构建及严格签名通过。用户确认运行中设置被遮挡时连续 TG→Chrome 接链不再闪现；菜单退出并确认无进程后，TG 首链仍由 Chrome 打开且不出现 Nivlet 窗口。冷启动实际路径已核实为正式安装位置；主动打开 App 仍可进入设置，关于页显示 Build 5。

验收中发现系统曾启动同 Bundle ID 的备份/Debug 副本，相关误跑结果不计入验收；已取消 16 个非安装副本的 LaunchServices 登记，保留文件及本地路径清单，再登记正式安装路径。未修改个人 Hammerspoon 配置或浏览器规则。公开安装包仍为 rc.3，本轮未提交或推送；上述通过仅针对本机报告的浏览器闪现，不代表完整功能、Safari 冷启动视觉、多屏或跨机器验收完成。

## 开发与发布顺序（2026-10-10）

当前先完善现有功能与 UI、修复 Bug 并完成最终候选回归，再进行发布验收与发布；新增配置重载、WAN、截图、官网/更新服务和捐赠在发布之后开发。具体阶段 A/B/C、顺序和门槛以 ROADMAP.md 为准。发布依赖未满足时明确记录阻塞，不将预发布称为正式稳定版；新增功能不自动提前。此计划调整不代表授权上传、push 或替换已安装应用。

## 阶段 A Build 7 状态（历史记录）

本机已安装 1.0.0 / Build 7 Release，公开下载仍 rc.3 / Build 3，Git 检查点仍 rc.4，本轮未提交或发布。A1 实体启动提示用户通过；A2 原生更换应用 JSON 回传错误修复，目标替换/快捷键保留/重复拦截/取消恢复通过；A3 通用页主动重新检测确认权限开启，其余模块重复权限区域移除；A4 用户确认菜单顺序和间距正常。输入法与启动规则排序、当前页取消回归通过，用户确认拖动可用。

最新去箭头、仅保留拖动手柄的 UI 调整尚仅源码，11/11 隔离真实 WKWebView 回归通过，待最终候选安装确认。现有安装窗口存在用户未保存草稿，未擅自保存或取消。完整最终版本窗口/直接粘贴、跨机器、多屏、Intel、Developer ID/公证及许可人工复核不能由这些针对性验收替代；正式分发门槛仍按 DISTRIBUTION.md。本节为 Build 7 过程记录，当前状态以 BASELINE.md 为准。

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
