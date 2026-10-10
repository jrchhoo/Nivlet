# 安装、升级与卸载

适用版本：v1.0.0 / 1.0.0 Build 18，GitHub 正式发行版，仍未通过 Apple 公证。

## 首次安装

1. 从 [GitHub Release](https://github.com/wivnelo/Nivlet/releases/tag/v1.0.0) 下载 DMG 或 ZIP，任选一种；不要运行多个副本。
2. DMG 打开后将 Nivlet.app 拖入 Applications；ZIP 解压后将 App 放入 Applications。
3. 从 Applications 打开，使用菜单栏 N 图标进入设置。无需另外安装 Hammerspoon。
4. 先按需要配置并保存；窗口管理和 Option 直接粘贴需要辅助功能权限，其他模块不因此要求授权。
5. 浏览器规则先保存并测试，再主动设置 Nivlet 为系统默认浏览器；未匹配时使用所选的实际浏览器。

当前 ad-hoc 签名可能触发系统拦截。记录提示并反馈；不要全局关闭 Gatekeeper 或运行来源不明的绕过命令。本项目尚不能保证所有系统都能直接打开。

`/Applications` 的 App 可由多个 macOS 用户共享，而用户配置与历史各自独立。提示 App 完全一致时无需重复覆盖；同机新用户测试不代表新硬件兼容性通过。

## 校验下载

把 ZIP、DMG 及同版本的 .sha256 文件放在同一文件夹，在该文件夹运行：

```sh
shasum -a 256 -c Nivlet-1.0.0-build13-x86_64-arm64-local-release.sha256
```

两个安装包都在时应各显示 OK；缺少其中一个会报该文件不存在，不代表另一个损坏。校验文件检测传输一致性，不替代 Apple 签名公证。

## 升级

1. 保存或取消所有页面草稿；通过通用页导出已保存配置。
2. 退出 Nivlet，再替换 Applications 中的 App，保留旧安装包以便恢复。
3. 不删除用户数据目录；启动后检查规则、快捷键、标签排序和权限状态。
4. 非持久剪贴板历史退出即清空；持久历史仍受原保留时间与数量限制，不承诺所有历史永远保留。
5. 开发签名更新后，辅助功能可能失效。系统中选择 `/Applications/Nivlet.app`，再在通用页重新检测，不要选择 build 或备份副本。

当前已发布包不覆盖修改。未来构建使用新 Build 号；如果新配置格式不兼容旧版，必须先验证恢复流程，不能直接假定降级安全。

## 卸载与恢复

1. 如果 Nivlet 是默认网页浏览器，先在 macOS 默认浏览器设置中改回 Safari 或其他浏览器，避免链接交给已删除应用。
2. 关闭登录自启动并保存；退出 Nivlet。
3. 将 `/Applications/Nivlet.app` 移入废纸篓。不清空废纸篓即可保留 App 恢复机会。
4. 仅移走 App 不清空用户设置。若希望完整删除配置与历史，应先导出/备份，再单独确认删除范围；本文不提供批量清空命令。

用户数据位于 `~/Library/Application Support/dev.local.DesktopToolkit`，偏好使用 `dev.local.DesktopToolkit` domain。不要修改或删除个人 Hammerspoon 的数据。配置 JSON 不包含历史、系统授权、登录项或系统默认浏览器。

## 已知限制与反馈

- 尚无 Developer ID 签名和 Apple 公证；下载首次安装、Gatekeeper、Intel、其他 macOS、多屏与跨机器测试未完整覆盖。
- 同机新用户配置使用已由用户反馈暂无明显重大问题；登录启动按反馈转观察，暂不继续排查。
- 关于页更新通道、官网与捐赠尚未接入；新版本暂通过 GitHub Releases 手动获取。
- 报告问题请提供应用版本/Build、macOS、芯片、操作步骤与提示；不要上传敏感剪贴板内容、完整私人配置或凭据。

现有模块使用方式见 [README](README.md)，当前验证状态见 [BASELINE](BASELINE.md)，工程验收见 [DISTRIBUTION](DISTRIBUTION.md)。

## 应用内更新（Build 18 起）

打开“关于 → 检查更新…”。发现新版后点击“安装更新”，软件会下载并校验签名，再提示安装与重新启动。更新仅替换应用，保留本地配置；先保存或取消所有页面草稿。默认不后台检查、不静默安装。Build 17 及更早版本需要先手动下载本版一次。

更新签名与 Apple 公证不同。当前仍为 ad-hoc，更新后 macOS 可能要求重新开启辅助功能权限；安装权限不足时按系统提示操作，不需要全局关闭安全机制。
