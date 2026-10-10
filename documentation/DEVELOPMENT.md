# 开发与构建

## 当前工程基准（2026-10-10）

公开正式版为 1.0.0 / Build 18；本机已安装 Build 19（arm64-only，未发布），当前状态以 [BASELINE.md](../BASELINE.md) 为准。旧构建阶段记录已移入归档。

- Runtime 固定来源；构建通过 `scripts/prepare-updater.sh` 准备固定 Sparkle 2.10.0，许可收集包含其原文。
- Release 构建使用完整 Xcode：`DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer NIVLET_BUILD_NUMBER=19 sh scripts/build-release.sh`。19 仅为下一构建示例，实际发布前核对并递增；构建不自动安装。
- 更新入口位于关于页，原生 Sparkle 桥接由 `patches/nivlet-updater.patch` 注入；有草稿先处理，默认手动检查、用户确认安装。
- Feed 为 `docs/appcast.xml`，使用 `scripts/generate-update-feed.py <ZIP>` 生成、`tests/updates.py` 验证。Ed25519 私钥留 Keychain，不导出到源码、日志或安装包。
- 发布顺序：新版本/Build → 构建和回归 → 打包/签名校验 → 上传新附件 → 发布 feed → 实测升级及最新检查 → 保留回滚备份。
- 当前 v1.0.0 附件更新为 Build 18；历史 tag 未重写，GitHub 自动源码归档仍对应原 tag。Build 18 更新实现源码见 main 的 `b0ed084` 及后续文档提交。下一功能版本使用新 tag，避免继续产生源码归档与附件版本差异。
- 本机真实 16 → 18 更新已通过；完整更新异常、其他硬件/macOS及公证仍有待验项，见 [ROADMAP.md](../ROADMAP.md)。GitHub 正式发布与 Apple 信任链分别描述。


## 常用检查

### Build 19 的包体积优化（本机已安装，尚未发布）

- 后续本地构建仅支持 Apple Silicon（arm64）；Build 18 正式发布包仍为双架构，不覆盖旧包或更新通道。
- Xcode 与 `system-probe` 编译为 arm64；打包前遍历所有 Mach-O，去除 Sparkle 等嵌套组件的 Intel 切片，缺少 arm64 时停止构建。
- 关于页 PNG 生成 160 × 160 资源，对应 80 × 80 Retina 显示；原始品牌图、Dock 与菜单栏图标保持原样。
- Release 主程序使用 `strip -S -x`，保留外部符号；裁剪前要求旁边存在匹配 UUID 的 dSYM，裁剪后核对外部符号和 UUID。dSYM 留在构建目录，不进入安装包。动态扩展不额外 strip。
- 可用 `NIVLET_DERIVED_DATA_PATH` 指定独立的绝对构建目录；构建与打包必须传入相同值。例如 `NIVLET_DERIVED_DATA_PATH="$PWD/build/DerivedData-arm64"`，避免覆盖旧双架构构建产物。

从仓库根目录执行：

```sh
for test_file in tests/*.lua; do lua "$test_file" || exit 1; done
python3 tests/dock_activation.py
node tests/launcher_replace.js
git diff --check
```

构建前需要完整 Xcode、Python 3 和固定 Runtime；首次使用 `sh scripts/fetch-runtime.sh` 准备 Runtime，已有目录不自动覆盖。不要自动升级依赖或替换已安装 App。

## 历史记录

详见 [历史工程记录](archive/HISTORY-DEVELOPMENT.md)。
