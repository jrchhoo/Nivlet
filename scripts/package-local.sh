#!/bin/sh
# Local validation artifacts. Developer ID signing and notarization are separate release gates.
set -eu
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
app_path="$project_dir/build/DerivedData/Build/Products/Debug/Nivlet.app"
version=$(cat "$project_dir/VERSION")
build=$(/usr/libexec/PlistBuddy -c Print:CFBundleVersion "$app_path/Contents/Info.plist")
test "$(/usr/libexec/PlistBuddy -c Print:CFBundleShortVersionString "$app_path/Contents/Info.plist")" = "$version"
codesign --verify --deep --strict "$app_path"
arch=$(lipo -archs "$app_path/Contents/MacOS/Nivlet" | tr ' ' '-')
output="$project_dir/build/packages"
mkdir -p "$output"
base="Nivlet-$version-build$build-$arch-local"
stage=$(mktemp -d "$project_dir/build/package-stage.XXXXXX")
trap 'rm -rf "$stage"' EXIT HUP INT TERM
ditto "$app_path" "$stage/Nivlet.app"
ln -s /Applications "$stage/Applications"
cat > "$stage/安装说明-Read-Me.txt" <<'TXT'
Nivlet for Mac 1.0.0 — 本机验收候选包 / Local validation build

将 Nivlet.app 拖入 Applications 后打开。无需另装 Hammerspoon。
在通用设置配置外观和语言；窗口、剪贴板、输入法、浏览器及应用快捷启动按需开启。
窗口管理和 Option 直接粘贴需要在系统设置中允许辅助功能。
配置与历史保存在本机；升级时只替换 App，不删除数据目录。
此包使用开发签名，尚未经过 Developer ID 签名、公证与其他机器验收。

Drag Nivlet.app into Applications. No separate Hammerspoon installation is needed.
Enable modules in Settings. Window management and Option-paste require Accessibility permission.
Settings and history are stored locally. Updating the App does not require deleting its data.
This local build has no Developer ID signature or notarization and has not passed cross-machine validation.
TXT
ditto -c -k --sequesterRsrc --keepParent "$app_path" "$output/$base.zip"
hdiutil create -quiet -volname "Nivlet $version" -srcfolder "$stage" -ov -format UDZO "$output/$base.dmg"
(cd "$output" && shasum -a 256 "$base.zip" "$base.dmg" > "$base.sha256")
printf '%s\n' "$output/$base.zip" "$output/$base.dmg"
