#!/bin/sh
set -eu
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
sh "$project_dir/scripts/preflight.sh"
upstream_dir="$project_dir/vendor/hammerspoon"
python3 "$project_dir/scripts/prepare-icon.py"
cd "$upstream_dir"
xcodebuild -workspace Hammerspoon.xcworkspace -scheme Hammerspoon -configuration Debug -derivedDataPath "$project_dir/build/DerivedData" CODE_SIGNING_ALLOWED=NO CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER=NO build
app_path="$project_dir/build/DerivedData/Build/Products/Debug/Nivlet.app"
test -d "$app_path"
/usr/libexec/PlistBuddy -c Print:CFBundleIdentifier "$app_path/Contents/Info.plist" | /usr/bin/grep -qx dev.local.DesktopToolkit
mkdir -p "$app_path/Contents/Resources/Toolkit"
cp -R "$project_dir/Toolkit/." "$app_path/Contents/Resources/Toolkit/"
cp "$project_dir/assets/nivlet-icon.png" "$app_path/Contents/Resources/Toolkit/nivlet-icon.png"
cp "$project_dir/LICENSE" "$app_path/Contents/Resources/Toolkit/"
python3 "$project_dir/scripts/collect-notices.py" "$app_path/Contents/Resources/Toolkit/THIRD-PARTY-NOTICES.md"
xcrun clang -fobjc-arc -Wall -Wextra -Werror -arch arm64 -arch x86_64 -mmacosx-version-min=13.0 -framework Foundation "$project_dir/Native/system_probe.m" -o "$app_path/Contents/Resources/Toolkit/system-probe"
# Ad-hoc signing is only for this local probe, not a distribution signature.
python3 "$project_dir/scripts/configure-url-types.py" "$app_path/Contents/Info.plist"
codesign --force --deep --sign - "$app_path"
codesign --verify --deep --strict "$app_path"
echo "Local probe built: $app_path"
echo "App has not been launched. Complete isolation review before running it."
