# 第三方许可工程核查

> 2026-10-10 后续核查发现原脚本漏收 LICENSE.SimplePing、LICENSE.timeout3 和 LICENSE-examples。收集规则已修复并补回归，现收集 81 个许可文件；补充原文见 [THIRD-PARTY-SUPPLEMENT.md](THIRD-PARTY-SUPPLEMENT.md)。补充声明已作为 rc.5 独立附件发布，发布说明已同步更新；当前安装版及原 DMG/ZIP 仍为原声明，尚未重新打包；不能将此前“文件一致”解读为声明完整。


## Build 13 工程复核（2026-10-10）

- 对 `/Applications/Nivlet.app` 与 rc.5 ZIP 只读核验，未修改已安装 App。
- `collect-notices.py` 重新生成声明与安装版逐字节一致，ZIP 内同文件也一致。SHA-256：`0822dbcff96dc6fc9c0fce71348ec233430b68a02d28265a4569e88f999b47ed`。
- 收集 78 个许可文件，另含 Pods acknowledgements 与 Lua 5.4.7 README；10 项 Pods 依赖均有 acknowledgements 章节，版本以 Podfile.lock 为准。
- 101 个 Mach-O 文件均含 x86_64 与 arm64；严格签名验证通过，未发现 /Users 或 /opt/homebrew 加载依赖。架构存在不证明 Intel 实机行为正常。
- ZIP 未检出个人迁移配置、clipboard-history、preferences.plist、.git 或 .env 标记路径；名称筛查不是完整秘密审计。

| 二进制/资源来源 | 本轮映射与证据 | 状态 |
| --- | --- | --- |
| 主程序与 hs 扩展 | 固定 Hammerspoon checkout 与定制 patches；合并声明保留上游 MIT | 来源已固定，逐扩展特殊条款待完整人工映射 |
| LuaSkin.framework / Lua | 上游 LuaSkin 与 Lua 5.4.7 README 已纳入声明 | 声明已匹配 |
| Sparkle.framework | Podfile.lock 2.6.4，acknowledgements 保留 Sparkle 声明 | 声明已匹配，不代表启用了自动更新 |
| Pods 静态链接组件 | ASCIImage、CocoaAsyncSocket、CocoaHTTPServer、CocoaLumberjack、MIKMIDI、ORSSerialPort、PocketSocket、Sentry、SocketRocket | acknowledgements 章节齐全，逐二进制静态来源及附加条款复核仍开放 |

本轮完成可复现的声明一致性与包检查，未将完整法律/许可审查标记完成。保持上游版权、许可与修改来源，后续依赖升级必须重做对应核查。

## 当前来源

Runtime 固定为 Hammerspoon 1.1.1，commit `1469832361b4c3687ec7d589c1b4efe4d3b742ee`，含 Nivlet 定制补丁；不是未修改的上游官方安装包。固定依赖由 `scripts/fetch-runtime.sh` 准备，不自动跟随上游更新。

| 来源 | 声明收集方式 |
| --- | --- |
| Hammerspoon | 根目录 THIRD-PARTY-NOTICES.md 保留上游 MIT 声明 |
| CocoaPods 依赖 | Pods-Hammerspoon-acknowledgements.markdown 整体收集，含 ASCIImage、CocoaAsyncSocket、CocoaHTTPServer、CocoaLumberjack、MIKMIDI、ORSSerialPort、PocketSocket、Sentry、SocketRocket、Sparkle |
| Runtime 扩展及附带库 | 收集 checkout 中 LICENSE、LICENSE.md、LICENSE.txt、COPYING、COPYRIGHT 文件，排除 .git 和 Headers 重复目录 |
| Lua 5.4.7 | 单独收集 README 中的版权与许可 |
| Nivlet | 自有 LICENSE 随包保留，不能替代第三方许可证 |

`scripts/collect-notices.py` 生成合并声明，放在应用 `Contents/Resources/Toolkit/THIRD-PARTY-NOTICES.md`；“关于”页读取此文件。当前构建收集日志为 78 个许可文件，另含 CocoaPods acknowledgements 和 Lua README；数量本身不证明全部义务已经满足。

## 发布前核查

- 对照当前包中 Framework、动态库、辅助程序和链接依赖，确认每个来源有对应声明，不能只按界面上实际启用的模块统计。
- 更新依赖后重新收集声明；检查非标准名称的许可文件、嵌入版权和附加分发条款，文件名扫描可能遗漏这些内容。
- 保留上游版权和定制修改来源；不宣称本项目得到 Hammerspoon 官方背书。
- 校验合并声明与最终 ZIP/DMG 中的文件一致；安装包不带个人数据或凭据。
- 本文是工程检查记录，不是法律意见；发现不明确的分发条款时先核实再发布。

## 当前边界

已检查收集流程、固定来源和依赖 acknowledgements；完整二进制来源映射和所有特殊条款的人工复核仍是正式发布门槛。不得仅因收集脚本成功就将“第三方许可全面审查”标为完成。
