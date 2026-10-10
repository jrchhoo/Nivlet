# Nivlet for Mac

<p align="center">
  <img src="assets/nivlet-icon.png" alt="Nivlet app icon" width="128">
</p>

<p align="center">
  <a href="README.md">简体中文</a> · <strong>English</strong>
</p>

<p align="center">
  Make everyday desktop tasks feel easier.<br>
  Clipboard history, window management, system information, input sources and app shortcuts in your Mac menu bar.
</p>

<p align="center">
  <a href="https://github.com/jrchhoo/Nivlet/releases/tag/v1.0.0-rc.5">Download</a> ·
  <a href="https://github.com/jrchhoo/Nivlet/issues">Report an issue</a> ·
  <a href="ROADMAP.md">Roadmap</a>
</p>

## Current release

Candidate: `v1.0.0-rc.5` / Build 13. Final Accessibility and Telegram-link revalidation is in progress; publication follows acceptance.

**v1.0.0-rc.5 · App 1.0.0 / Build 13 · Pre-release**

DMG, ZIP and SHA-256 files are available for Apple Silicon (arm64). The bundle declares macOS 13.0 as its minimum; other macOS versions, Intel, multiple displays and installation on other Macs have not been fully validated.

> The package uses an ad-hoc development signature. It has no Developer ID signature or Apple notarization, so macOS may block it after download. Consider this limitation before trying it. This is not a stable release yet.

Nivlet is the brand; Nivlet for Mac is the display name. The installed app remains `Nivlet.app`. No separate Hammerspoon installation or code editing is required.

## Features

| Feature | What it does |
| --- | --- |
| Clipboard | Text and image history, search, pause, image previews and optional persistence |
| Window management | 29 actions: halves, quarters, thirds, a 3×3 grid, centering, resizing, display moves and restore |
| System information | Menu bar network speed, plus CPU, memory, disk, network addresses and dates |
| Input sources | Switch to a chosen input source when you activate an app |
| App launcher | Bind shortcuts to launch apps or bring them to the foreground |
| Browser routing | Choose a browser by domain or source app |
| Configuration | JSON import/export, a default example and partial module imports |
| General settings | Chinese/English, appearance, launch at login, permission checks and tab ordering |

## Install and get started

1. Download **either the DMG or the ZIP** from [Releases](https://github.com/jrchhoo/Nivlet/releases/tag/v1.0.0-rc.5).
2. Move `Nivlet.app` to Applications and open it. Run only one copy.
3. Click the menu bar **N icon → Settings…**, or open the app again to access settings. `Command+,` also opens settings while Nivlet is active.
4. Enable the features you need, configure their rules and click **Save Settings in the bottom-right corner**. General switches also require saving. Switching tabs preserves drafts and shows an unsaved-changes hint.

Window management, input-source rules, clipboard recording, browser rules and app launching are disabled by default. Clipboard and system information icons appear on launch; the clipboard icon alone does not mean recording is enabled.

**Permissions:** Window adjustments and Option-click direct paste require Nivlet access under System Settings → Privacy & Security → Accessibility. Clipboard recording, system information and app launching do not require this permission. Development-signature updates may require authorization again.

## Usage

### Clipboard

Enable and save recording in Settings → Clipboard, then copy new content. Open the menu bar clipboard icon: images appear above text, with thumbnails and hover previews; text entries have a T tile. Settings history remains in chronological order.

| Action | How |
| --- | --- |
| Copy an entry | Click it in the menu, then paste into the target app |
| Paste directly | Hold Option and click an entry to paste into the app active before opening the menu; requires Accessibility |
| Search | Use Search History… in the menu or the settings search field; text search only, no image OCR |
| Enlarge an image | Use the preview button on its settings history card |
| Pause | Pause Recording in the menu; resuming captures only new copies |
| Clear | Clear History… in the menu or settings; confirmation deletes history and cache **and clears the current system clipboard. This cannot be undone** |

Text history defaults to 50 entries, with choices from 10 to 100. Retention defaults to 30 minutes; choose 30 minutes, 1/2/4/8/12/24 hours or forever. Forever still respects the count limit. Image history holds up to 10 images, approximately 10 MiB each. Copied files are not recorded; image paste requires target-app support.

History is discarded on exit by default. Persistence across restarts is optional and uses a local plaintext cache. Duplicate content moves to the newest position; content copied before enabling or while paused is not backfilled. Pause before copying sensitive information: app exclusions and filters cannot identify every sensitive item.

### Window management and app launching

Enable the feature, configure key combinations and save. Supported keys include letters, numbers, arrows, Return, `=` and `-`. Letters display in uppercase; Backspace or Delete clears a binding. No shortcuts are assigned by default.

Window actions include halves, quarters, centering, thirds, a 3×3 grid, resizing by 40 points and moving to adjacent displays. Restore returns a window to its position before its first adjustment in the current run. Full-screen windows are unsupported; app minimum sizes may limit small layouts. Display moves do not wrap when no adjacent display exists.

Launcher rules open an app or bring it forward. Adding the same app again highlights the existing entry instead of creating a duplicate; input-source and browser source-app rules also check duplicates. Conflicting shortcuts within Nivlet block saving, but not every third-party shortcut can be detected.

### Browser routing

1. In Settings → Browser, choose a fallback browser and add domain or source-app rules.
2. Enable and save. Use the match check and open-by-rule actions to test; a simulated source can check app rules.
3. To route links from other apps, manually set **Nivlet as the macOS default web browser**. Switch back to your previous browser to stop routing.

Priority is **domain → source app → fallback**. Domain rules match from top to bottom, support subdomains and can be reordered with ↑ / ↓. Installed Safari, Chrome, Firefox, Edge and Brave are supported. Only HTTP/HTTPS links are handled. Some apps do not expose an identifiable source; domain rules or the fallback apply in that case.

### System information and input sources

Choose network speed, CPU, memory, disk, IPv4, IPv6, MAC address, calendar date/weekday and lunar date in System Information, then save. Settings show current values; an information entry remains when network speed is hidden. Click addresses or dates in the menu to copy them. macOS may hide the MAC address; “Hidden by system” is unrelated to Accessibility permission.

In Input Sources, add an app and choose one of the system's enabled input sources, then enable and save. The rule applies when you next activate that app; unconfigured apps keep the current input source.

### Appearance, navigation and configuration

- Language: follow system, Simplified Chinese or English. Appearance: follow system, light or dark. Both follow the system by default.
- Hide or show the main N icon independently of clipboard and system information. The intended order is network speed → clipboard → N; positions also depend on macOS's saved state.
- Drag tabs to reorder them. General stays first and About stays last. Tab order saves automatically; other editable settings use the bottom-right save button.
- Launch at login takes effect after saving. Optional Command+L sleep is off by default; enabling it overrides the same shortcut in apps such as browsers.
- Export JSON or a default example from General → Configuration Backup & Migration. Review the replacement scope before importing. Omitted modules stay unchanged; failures restore the previous configuration. History, caches, permissions, login items and the system default browser are excluded. See the [configuration guide](CONFIGURATION.md) (Chinese).

## Privacy

No account is required. Configuration, clipboard contents and system information are processed locally and are not uploaded to a server. Core desktop tools work offline. Persistent clipboard history is a **local plaintext cache**; protect exported configuration files yourself.

Opening web pages, GitHub or other external links uses the network. No update channel is currently enabled. Nivlet keeps its configuration and history separate from personal Hammerspoon setups and does not read your `~/.hammerspoon` directory.

## FAQ

**No history after copying?** Confirm recording is enabled and saved, check that it is not paused, and copy something new. Files, excluded apps and oversized content are not recorded. You can refresh history in settings.

**Shortcuts or direct paste do nothing?** Check Accessibility, shortcut conflicts and whether the target is a normal window. A development-signature update may require granting permission again.

**An app's links use the wrong browser?** Set Nivlet as the system default browser and confirm rules are enabled and saved. Domain rules take priority over source-app rules.

**Screenshots, a website or automatic updates?** Not available yet. A screenshot tool, website, update checks and optional donations are on the [roadmap](ROADMAP.md) (Chinese).

## Documentation and feedback

These detailed documents are currently in Chinese:

- [Configuration guide](CONFIGURATION.md)
- [Release scope and known limitations](RELEASE-1.0.0.md)
- [Validation records](VALIDATION.md)
- [Installation and upgrade test checklist](DISTRIBUTION.md) (Chinese)
- [Development and building](DEVELOPMENT.md)
- [Roadmap](ROADMAP.md)

Report issues or suggestions through [GitHub Issues](https://github.com/jrchhoo/Nivlet/issues). Include the app version, macOS version, reproduction steps and actual result. Do not include sensitive clipboard contents, personal configurations or credentials.

## License and acknowledgements

The project uses the [MIT License](LICENSE). Its embedded Runtime is based on [Hammerspoon](https://github.com/Hammerspoon/hammerspoon); users do not need to install it separately. Third-party components retain their own licenses; see [third-party notices](THIRD-PARTY-NOTICES.md). Collected dependency notices are also available in the app's About page.
