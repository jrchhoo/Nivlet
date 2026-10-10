<p align="center">
  <img src="assets/nivlet-icon.png" alt="Nivlet app icon" width="112">
</p>

<h1 align="center">Nivlet for Mac</h1>

<p align="center">
  <strong>Make everyday desktop tasks feel easier.</strong><br>
  Clipboard history, window management, app shortcuts and browser routing in your Mac menu bar.
</p>

<p align="center">
  <a href="README.md">简体中文</a> · <strong>English</strong>
</p>

<p align="center">
  <a href="https://wivnelo.github.io/Nivlet/">Website</a> ·
  <a href="https://github.com/wivnelo/Nivlet/releases/latest">Download</a> ·
  <a href="USAGE.en.md">User guide</a> ·
  <a href="https://github.com/wivnelo/Nivlet/issues">Report an issue</a>
</p>

---

Nivlet is a free, open-source macOS menu bar utility that brings everyday desktop actions together. Enable the tools you need and choose your own shortcuts. No coding or separate Hammerspoon installation required.

## What you can do

| Feature | Highlights |
| --- | --- |
| **Clipboard history** | Keep text and images with search, thumbnails, larger previews and Option-click paste; pause recording, exclude apps and choose retention limits |
| **Window management** | 29 actions for halves, quarters, thirds, a 3×3 grid, centering, resizing, display moves and restore |
| **App shortcuts** | Launch apps or bring them forward; replace apps, drag to reorder and check shortcut conflicts |
| **Browser routing** | Choose the browser for a link based on its domain or source app |
| **Input sources** | Assign an input source to an app and switch automatically when you activate it |
| **System information** | See network speed in the menu bar and choose CPU, memory, disk, network addresses and dates to display |
| **Personalization & migration** | Chinese and English, light and dark appearances, tab ordering and JSON configuration import/export |

## Get started

1. Download **either the DMG or ZIP** from [GitHub Releases](https://github.com/wivnelo/Nivlet/releases/latest).
2. Move `Nivlet.app` to Applications and open it.
3. Click the menu bar **N icon → Settings…**, enable your tools and configure their rules.
4. Click **Save Settings** in the bottom-right corner. Switching tabs keeps drafts; an orange dot marks unsaved pages.

Features are opt-in, and shortcuts are yours to configure. Window management and Option-click paste require **Accessibility permission**. Browser routing requires choosing **Nivlet as your default browser**.

> **Installation note:** This release has no Developer ID signature or Apple notarization; macOS may block first launch. See the [installation, upgrade and removal guide](INSTALLATION.md) (Chinese). Declared minimum: macOS 13.0. The package includes Apple Silicon and Intel architectures; Intel, other macOS versions and multiple displays have not been fully validated.

## Local processing, optional recording

No account required. Settings, clipboard contents and system information are processed locally without being uploaded to a server. Core desktop tools work offline; opening websites and external links uses the network.

Clipboard history is cleared on exit by default. Optional persistence uses a **local plaintext cache**; pause recording before copying sensitive content. Clearing history also clears the current system clipboard, with a confirmation prompt.

## Learn more

- [User guide](USAGE.en.md) · [Configuration import/export](CONFIGURATION.md) (Chinese)
- [Releases](https://github.com/wivnelo/Nivlet/releases) · [Roadmap](ROADMAP.md) (Chinese)
- [Development & building](DEVELOPMENT.md) (Chinese)

Report problems or suggestions through [GitHub Issues](https://github.com/wivnelo/Nivlet/issues). Include the app version, macOS version and reproduction steps. Do not upload sensitive clipboard contents, personal configurations or credentials.

## License & acknowledgements

Nivlet uses the [MIT License](LICENSE). Its embedded Runtime is based on [Hammerspoon](https://github.com/Hammerspoon/hammerspoon). Third-party components retain their own licenses; see [third-party notices](THIRD-PARTY-NOTICES.md).
