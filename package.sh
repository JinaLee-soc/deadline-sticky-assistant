#!/bin/zsh
# Build a standalone, universal macOS Installer package. No install scripts.
set -euo pipefail
cd -- "${0:A:h}"
ARCHS="arm64 x86_64" zsh build.sh
app='dist/Research Desk.app'
version=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist")
staging=$(mktemp -d "${TMPDIR:-/tmp}/research-desk-package.XXXXXX")
trap 'rm -rf -- "$staging"' EXIT
mkdir -p "$staging/root/Applications"
ditto "$app" "$staging/root/Applications/Research Desk.app"
# Disable bundle relocation: upgrades always target /Applications, never a build checkout.
pkgbuild --analyze --root "$staging/root" "$staging/components.plist"
/usr/libexec/PlistBuddy -c 'Set :0:BundleIsRelocatable false' "$staging/components.plist"
/usr/libexec/PlistBuddy -c 'Set :0:BundleOverwriteAction upgrade' "$staging/components.plist"
pkgbuild --root "$staging/root" --component-plist "$staging/components.plist" --identifier org.researchdesk.share.installer --version "$version" --install-location / --ownership recommended "$staging/component.pkg"
cat > "$staging/distribution.xml" <<'XML'
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
  <title>Research Desk</title>
  <options customize="never" require-scripts="false" hostArchitectures="arm64,x86_64"/>
  <domains enable_anywhere="false" enable_currentUserHome="false" enable_localSystem="true"/>
  <volume-check><allowed-os-versions><os-version min="12.0"/></allowed-os-versions></volume-check>
  <welcome file="Welcome.txt"/>
  <choices-outline><line choice="default"/></choices-outline>
  <choice id="default" visible="false"><pkg-ref id="org.researchdesk.share.installer"/></choice>
  <pkg-ref id="org.researchdesk.share.installer">component.pkg</pkg-ref>
</installer-gui-script>
XML
mkdir "$staging/resources"
cat > "$staging/resources/Welcome.txt" <<'TEXT'
Research Desk — macOS 12 or later · Apple Silicon & Intel

Installs Research Desk.app in Applications. Quit an existing Research Desk before updating.
Open Research Desk from Applications after installation and select English or 한국어.
Your projects and chats are stored separately and are retained when updating.
No developer tools are required. Codex installation/login is needed only for optional AI chat.
This release is ad-hoc signed, not Apple Developer ID signed or notarized.

Research Desk.app을 응용 프로그램에 설치합니다. 업데이트 전 실행 중인 앱을 종료하세요.
설치 후 응용 프로그램에서 Research Desk를 열고 한국어 또는 English를 선택하세요.
프로젝트와 대화 기록은 별도 보관되며 업데이트 시 유지됩니다.
개발 도구는 필요하지 않습니다. AI 대화 기능에만 Codex 설치와 로그인이 필요합니다.
TEXT
productbuild --distribution "$staging/distribution.xml" --package-path "$staging" --resources "$staging/resources" dist/Research-Desk-macOS-universal.pkg
(cd dist && shasum -a 256 Research-Desk-macOS-universal.pkg > SHA256SUMS.txt)
print "Built dist/Research-Desk-macOS-universal.pkg ($version)"
