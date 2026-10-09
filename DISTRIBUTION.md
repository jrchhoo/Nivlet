# Nivlet for Mac 分发准备与验收

本清单区分免费可完成的工程准备和需要 Apple Developer Program 的正式分发步骤。GitHub 测试包不等于已通过 Apple 公证的稳定版。

## 无付费账号的本地构建

已按 DEVELOPMENT.md 准备固定 Runtime 和 Xcode 后运行：

```sh
NIVLET_BUILD_NUMBER=4 DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer sh scripts/build-release.sh
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
