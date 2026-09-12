#!/bin/zsh
set -euo pipefail
cd -- "${0:A:h}"
app_name='Research Desk'
swift_flags=()
if [[ "${1:-}" == '--qa' ]]; then
  app_name='Research Desk QA'
  swift_flags=(-D RESEARCH_DESK_QA)
fi
bundle="dist/$app_name.app"
mkdir -p .build "$bundle/Contents/MacOS" "$bundle/Contents/Resources"
xcrun swiftc -swift-version 5 -module-cache-path .build/module-cache "${swift_flags[@]}" main.swift CodexChat.swift -o "$bundle/Contents/MacOS/ResearchDesk" -framework AppKit -framework WebKit
cp Info.plist "$bundle/Contents/Info.plist"
if [[ "${1:-}" == '--qa' ]]; then
  /usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier org.researchdesk.share.qa' "$bundle/Contents/Info.plist"
  /usr/libexec/PlistBuddy -c 'Set :CFBundleName Research Desk QA' "$bundle/Contents/Info.plist"
fi
cp LICENSE ASSETS.md "$bundle/Contents/Resources/"
cp Resources/index.html Resources/mini.html Resources/mini.js Resources/app.js Resources/model.js Resources/strings.js Resources/style.css Resources/cat-poses.png "$bundle/Contents/Resources/"
codesign --force --sign - "$bundle"
printf 'Built %s\n' "$bundle"
