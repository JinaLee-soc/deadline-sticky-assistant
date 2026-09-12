#!/bin/zsh
set -euo pipefail
cd -- "${0:A:h}"
mkdir -p .build 'dist/Research Desk.app/Contents/MacOS' 'dist/Research Desk.app/Contents/Resources'
xcrun swiftc -swift-version 5 -module-cache-path .build/module-cache main.swift -o 'dist/Research Desk.app/Contents/MacOS/ResearchDesk' -framework AppKit -framework WebKit
cp Info.plist 'dist/Research Desk.app/Contents/Info.plist'
cp LICENSE ASSETS.md 'dist/Research Desk.app/Contents/Resources/'
cp Resources/index.html Resources/app.js Resources/model.js Resources/strings.js Resources/style.css Resources/beaver-0.png Resources/beaver-1.png Resources/beaver-2.png 'dist/Research Desk.app/Contents/Resources/'
codesign --force --sign - 'dist/Research Desk.app'
printf 'Built dist/Research Desk.app\n'
