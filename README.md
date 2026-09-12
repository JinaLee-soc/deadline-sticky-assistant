# Research Desk

A small, local-first macOS research planner with customizable project stages, a floating companion window, a separate deadline checklist, and a cat assistant with optional Codex conversation. English and Korean are supported throughout the interface. Prebuilt macOS installers are available. This early release is ad-hoc signed; it is not Apple Developer ID signed or notarized.

## Install

### Download the Mac app / 맥 앱 다운로드

**[Download Research Desk for macOS](https://github.com/JinaLee-soc/deadline-sticky-assistant/releases/latest/download/Research-Desk-macOS-universal.pkg)** · macOS 12+ · Apple Silicon & Intel

1. Download the `.pkg` file and double-click it. Follow the macOS Installer steps.
2. Open **Applications → Research Desk** and choose **English** or **한국어**.
3. For updates, quit Research Desk before installing. Your projects and chats are retained in `~/Library/Application Support/Research Desk Share/`.

**한국어:** 위 링크에서 `.pkg`를 다운로드하고 더블클릭해 설치하세요. 설치 후 **응용 프로그램 → Research Desk**를 열면 언어를 선택할 수 있습니다. Xcode·터미널·개발 도구는 필요하지 않습니다. 업데이트 전 앱을 종료하세요. 기존 프로젝트와 대화 기록은 유지됩니다.

Because this release is not notarized, macOS may block the installer or the app on first open. After trying to open the downloaded file, use **System Settings → Privacy & Security → Open Anyway** for that specific file, if available. The app may require the same one-time approval after installation. On older macOS versions this is under **System Preferences → Security & Privacy**. Managed Macs may require an administrator. See [Apple’s opening instructions](https://support.apple.com/en-us/102445). Do not disable Gatekeeper or system-wide security protections.

**보안 안내:** 아직 Apple 공증을 받지 않아 처음 열 때 차단될 수 있습니다. 열기를 시도한 뒤 **시스템 설정 → 개인정보 보호 및 보안 → 확인 없이 열기**에서 해당 파일을 허용하세요. 설치 파일과 설치된 앱에 각각 한 번 필요할 수 있습니다. 보안 기능 전체를 끄지 마세요.

No paid API key, Node.js runtime, cloud account, or subscription is needed for the planner. Optional AI conversation requires an installed Codex app or CLI, a ChatGPT login with Codex access, and internet access; your account usage limits apply.

### Build from source (optional)

Developers need Apple's Xcode Command Line Tools (`xcode-select --install`). Run `zsh Install.command` to build for this Mac and install to `~/Applications`; this source installer will not replace an existing app. If switching from a source installation to the downloaded package, keep only the desired app in use to avoid opening an older copy.

Run `zsh package.sh` to build the universal installer and `dist/SHA256SUMS.txt`. Release builds explicitly target macOS 12 and include both `arm64` and `x86_64`. The installer installs only the app in `/Applications`, contains no installation scripts, and does not bundle personal data or credentials.

Change language anytime using the selector at the top right. Direct first launch without the installer shows a language chooser. Project names, task text, stage states and identifiers do not change when switching languages.

## Research progress

Each project is one horizontal row with the same eleven stages, in the original tracker's order:

| # | English | 한국어 |
|---|---|---|
| 1 | Planning | 기획 |
| 2 | Data collection | 자료 수집 |
| 3 | Analysis | 분석 |
| 4 | Abstract | 초록 |
| 5 | Figures & tables | 도표 |
| 6 | First draft | 초고 |
| 7 | Polishing | 다듬기 |
| 8 | Submission | 투고 |
| 9 | Revision | 수정 |
| 10 | Resubmission | 재투고 |
| 11 | Publication | 게재 |

Choose **+ Project**, enter a name and priority, and check any stages already completed. Clicking a matrix cell toggles only that stage. Click a **project name** to edit its name, priority, and eleven stage settings. Each stage can have a project-specific name and a separate **Not applicable / 해당 없음** flag. Blank names use the English/Korean default when you switch languages; custom names stay exactly as entered. A dash and hatching distinguish not-applicable cells from completed ones. Marking a stage not applicable preserves its previous completion state, so unchecking it restores that state. Changing settings does not claim new work or reset reminder history.

Completion values remain explicit booleans; this edition does not import unknown/unrecorded stage states from private trackers.

One applicable unfinished stage equals one point. Not-applicable stages are excluded from scores and next-stage suggestions. The total and average include projects only, including completed projects in the average denominator. These numbers are planning indicators, not estimates of hours, research quality, validation, or scientific adoption. The red outline marks the assistant's suggested next stage when its selected target is a project.

## Sticky notes

Use **+ Task / deadline** for reviews, applications, messages and other to-dos. Dates and project links are optional. Check a task to mark it complete and strike through its title. Sort by priority or due date; undated items sort last in the date view. Completed items appear after open items.

Linked deadlines appear as supplementary project information. Completing a deadline never automatically completes a project stage, and vice versa. To-do items never contribute to project scores. Dates are date-only in the Mac's local calendar; school-specific deadline times and time zones are not implemented in this edition.

## Cat reminders and conversation

The assistant considers unfinished projects and to-dos together. The current deterministic rule orders by priority and then deadline. Recorded inactivity, approaching deadlines and explicit postponements increase reminder intensity, capped at three levels:

- Apricot: a gentle reminder, seated pose.
- Yellow: focus requested, pointing pose.
- Red: urgent attention, raised-hand pose.

Messages rotate daily through three localized phrases per intensity level (not a new AI generation each day). Korean reminders and Codex replies use respectful polite speech, including firm reminders. With no newly recorded progress, reminder intensity rises after three days and again after six days, capped at level three; approaching deadlines and repeated postponements can increase it sooner. Completing a stage records progress and resets that project's postponement count; completed items leave the reminder queue. The app measures **days without recorded progress**, not whether you actually worked. It does not monitor your screen, keyboard, files or calendar. Urgency near a deadline can remain high even after progress.

## Floating small window

The small window opens with the app, stays above ordinary windows, and follows desktop Spaces. Drag its title bar to move it; its position and size are remembered. Use **Small window / 작은 창** or Command–2 to hide/show it, and **Open desk / 전체 책상** or Command–1 to return to the main window. Closing the main window leaves the small window running; closing all windows quits the app.

It shows the cat, up to three suggested next actions, and open deadlines in the next 30 days (including overdue items). Suggestions use the same priority-then-deadline rule as the main desk, not AI or a fixed schedule. If a project has open linked tasks, those tasks represent it in the small list. The deadline area scrolls so additional deadlines remain available. Saved changes and local date changes refresh the small window. It cannot appear over the macOS lock screen; it does not schedule notifications while the app is closed.

## AI conversation with your Codex

The bottom conversation box connects to **your installed Codex** by default. Install the Codex app or Codex CLI and sign in there with **ChatGPT**, then type a question in Research Desk. Common app and Homebrew locations and the inherited executable search path are supported. This app does not install Codex, copy credentials, request an API key, or fall back to API-key billing. It starts an ephemeral session through the official [Codex App Server](https://developers.openai.com/codex/app-server) using your configured default model with the OpenAI provider.

On first send, the app explains the connection and asks to proceed. Each send includes project names, priorities, stage names/states, recorded progress dates, postponements, tasks/deadlines, today's local date, and the last 12 chat messages. This context leaves the device for the Codex service. No automatic AI calls run in the background. The rest of the planner works without AI. The interface distinguishes actual connection errors from replies; it never substitutes a canned answer for a failed AI response.

Enter sends; Shift–Enter inserts a newline. Composing Korean text does not send prematurely. **Cancel** stops the active response while preserving the user message. Replies and sent messages are saved locally with the desk, retaining the last 100 messages across restarts; the unsent input is not retained. **Clear chat** removes the displayed/stored conversation on the next save (the previous-file backup may still contain it). Late replies to a cleared or cancelled conversation are ignored.

The assistant can discuss what to work on and why, but cannot change desk records. Shell, web, file-writing, apps, plugins, skills and external MCP tools are disabled for this session; unexpected tools, approval requests or external instructions stop the response. This is a constrained app integration, not a general security certification for every future Codex version/configuration. Missing installations, ChatGPT login, compatibility errors, connection/usage failures and the two-minute timeout have visible messages. Update Codex if its app-server protocol is incompatible.

Calendar, wiki access, multi-device sync and system notifications are still optional future extensions.

## Local data and backup

The app starts empty. It does not ship the original author's research records, wiki, calendars, email addresses, conversations or credentials.

Data is saved on explicit UI changes to:

```text
~/Library/Application Support/Research Desk Share/desk.json
```

Version 0.2 reads the original version-1 desk and writes version 2 on the next explicit save. Project IDs and completion history are retained. Older app builds reject the new format rather than interpreting not-applicable stages incorrectly; use a pre-upgrade backup if downgrading.

`desk.previous.json` retains the previous saved version. Quit the app before manually restoring a backup. Back up this folder regularly; the single previous version is not a complete history. Invalid or unreadable data disables editing rather than replacing the file. Save failures are displayed in the footer. The app uses a separate bundle identifier and storage folder from the private Jina's Desk app.

Quit the app and move the application bundle to Trash to uninstall it. Data is deliberately retained. Delete the data folder only if you want to permanently remove your records.

## Recommended optional integrations

For a more personalized assistant, consider adding the following integrations in your own fork. **They are recommendations, not installed connectors or working features of this release.** The embedded UI blocks remote network requests. Optional Codex conversation uses a native subprocess after consent; these integrations are separate from that conversation.

### Your personal research wiki

Connect an Obsidian vault or another local Markdown wiki to give the assistant project context and recent work records. Start with read-only access to one explicitly chosen folder. Preserve source links and distinguish actual work updates from automatic file regeneration. Do not treat a file timestamp as proof that work happened. Ask for confirmation before writing stages, deadlines, or research decisions back to the wiki.

### Your work calendar

Read a work calendar to suggest realistic time blocks. Use the provider's official authorization flow with minimal read-only scopes; keep tokens outside the repository. Let users exclude personal calendars **before fetching events or free/busy data**. Explain that excluded calendars may still contain conflicts, so proposed time slots need user review. Calendar writes should be a separate opt-in feature.

### Supabase for Mac–phone synchronization

Supabase can provide authentication and a shared database if you want a mobile companion. Require authenticated ownership for every record and enable Row Level Security on all relevant tables. Test that another account cannot read or modify records. Never ship a service-role key or commit database credentials. A client publishable key alone is not access control. Upload only the fields needed for synchronization; do not upload an entire wiki or conversation archive by default. Define offline behavior and conflict handling before enabling two-way sync.

Any integration that sends research content to a model or cloud service should disclose what leaves the device and require the user's consent. Calendar/provider and hosting plans may impose costs and usage limits.

## Development

```sh
zsh build.sh
node tests/model.cjs
node --check Resources/app.js
node --check Resources/mini.js
xcrun swiftc -swift-version 5 -module-cache-path .build/module-cache CodexChat.swift tests/ChatChecks.swift -o .build/chat-checks
.build/chat-checks
# Optional: sends ONLY a synthetic test prompt through your Codex account
.build/chat-checks --live
```

The app uses AppKit and WKWebView with local HTML/CSS/JavaScript. There are no third-party JavaScript packages. Node.js is only used for development tests. Build output goes to `dist/`, ignored by Git. Do not commit the generated app, runtime data, credentials, logs containing private content, or personal integration configuration.

## Artwork and licensing

The white cat mascot was created with Codex image generation and refined through Jina Lee's art direction. The included character images are free to reuse, modify, and redistribute, including commercially. Attribution is appreciated but not required; see [ASSETS.md](ASSETS.md) for the permission and provenance details.

The application code and documentation are licensed under **Apache License 2.0 with Commons Clause License Condition v1.0**, copyright 2026 Jina Lee. Read the complete combined terms in [LICENSE](LICENSE). This is **source-available**, not unmodified Apache-2.0 or OSI-approved open source.

Personal, research, and internal business use, modification, and free redistribution are permitted subject to the license. The Commons Clause restricts providing a paid product or service whose value derives entirely or substantially from this software. Its definition of sale can include related hosting, consulting, or support; it is not a blanket prohibition on every commercial product that uses a component of this code. The license text controls. Requests for a separate sales permission can be raised through this repository.

The cat artwork remains separately free to reuse, modify, redistribute, and sell, with optional attribution, under [ASSETS.md](ASSETS.md). The Commons Clause does not apply to that artwork. This repository is maintained separately from the private research workspace.

For isolated manual QA, run `zsh build.sh --qa`. The separate **Research Desk QA.app** has its own bundle identifier and always uses `/private/tmp/research-desk-share-qa`, even if launched without environment variables. For other developer fixture paths, the regular build also supports `RESEARCH_DESK_SHARE_DATA`. Do not use a real data directory for tests. The chat test uses a local synthetic protocol server for success, login, tool-blocking, failure, timeout and cancellation cases; only `--live` contacts Codex.
