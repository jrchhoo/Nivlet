# 验证记录（2026-10-08）

开发预览已在 Apple Silicon、Xcode 27.0 上构建成功。

- 独立 Bundle ID、bootstrap 和 hs.settings domain；个人 Hammerspoon 与开发版并行运行。
- 内置 Lua 启动完成，无加载错误，默认 bindings 为 0。
- 真实设置窗口：默认关闭/留空、重复快捷键拒绝、保存成功、缺少辅助功能权限时拒绝启用。
- Window module 在开发版自己的普通 Console 窗口验证：
  - 左半屏 (0,30,1280,1410)
  - 右半屏 (1280,30,1280,1410)
  - 最大化 (0,30,2560,1410)
  - 恢复 (1565,30,510,487)，与原 frame 相同。
- 自定义快捷键经设置界面保存，日志确认 Enabled；关闭模块清空按键后 Disabled/Deleted。
- 实体键盘组合在基础 Runtime 探针触发一次回调，用户确认提示，日志核对通过；临时绑定已删除。
- Lua 测试覆盖重复组合（修饰键顺序/大小写）、无有效修饰键、无效按键、默认关闭、负坐标屏幕几何。
- Lua/Shell 语法、plist、patch diff、产物 ad-hoc 签名检查通过。
- 个人配置文件哈希保持一致，开发过程未重启个人 Runtime。用户随后主动退出个人 Runtime，未替用户恢复。

限制：测试 webview 不是普通窗口，模块正确拒绝；用普通 Console 完成实际控制验证。CUA 合成组合键未触发 Runtime 回调，不能用它代替实体键盘验收。尚未完成跨显示器、第三方 App 全量回归、Intel、Developer ID 签名、公证或安装包许可审计。
