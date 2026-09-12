# Research Desk

A small, local-first macOS research planner with an eleven-stage project matrix, a separate deadline checklist, and a beaver assistant. English and Korean are supported throughout the interface. This is an early source-build release, not a signed or notarized App Store application.

## Install

Requirements: macOS 12 or later and Apple's Xcode Command Line Tools. Install the tools with `xcode-select --install` if needed. No paid API key, Node.js runtime, cloud account, or subscription is needed to run the app.

1. Download the repository ZIP from GitHub and extract it.
2. Open Terminal in the extracted folder and run `zsh Install.command` (or double-click the executable command file).
3. Choose **English** or **한국어** in the installer.
4. The installer builds locally, copies the app to `~/Applications/Research Desk.app`, and opens it.

The installer will not replace an existing app. For an update, quit Research Desk, rename the previous application as a backup, then run the installer again. The data folder is separate and is retained. Builds are for the current Mac architecture, not universal binaries. Signing is ad hoc, not Developer ID signing. Review the source before building. Do not disable Gatekeeper or system-wide security protections to install it.

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

Choose **+ Project**, enter a name and priority, and check any stages already completed. Clicking a matrix cell toggles only that stage. All stages are explicit booleans; this edition does not import unknown/unrecorded stage states from private trackers.

One unfinished stage equals one point. The total and average include projects only, including completed projects in the average denominator. These numbers are planning indicators, not estimates of hours, research quality, validation, or scientific adoption. The red outline marks the assistant's suggested next stage when its selected target is a project.

## Sticky notes

Use **+ Task / deadline** for reviews, applications, messages and other to-dos. Dates and project links are optional. Check a task to mark it complete and strike through its title. Sort by priority or due date; undated items sort last in the date view. Completed items appear after open items.

Linked deadlines appear as supplementary project information. Completing a deadline never automatically completes a project stage, and vice versa. To-do items never contribute to project scores. Dates are date-only in the Mac's local calendar; school-specific deadline times and time zones are not implemented in this edition.

## Beaver reminders and conversation

The assistant considers unfinished projects and to-dos together. The current deterministic rule orders by priority and then deadline. Recorded inactivity, approaching deadlines and explicit postponements increase reminder intensity, capped at three levels:

- Apricot: a gentle reminder, seated pose.
- Yellow: focus requested, pointing pose.
- Red: urgent attention, raised-hand pose.

Messages rotate daily from a small localized library. Completing a stage records progress and resets that project's postponement count; completed items leave the reminder queue. The app measures **days without recorded progress**, not whether you actually worked. It does not monitor your screen, keyboard, files or calendar. Urgency near a deadline can remain high even after progress.

The bottom conversation box currently provides **rule-based example suggestions**, not free-form AI answers. It does not contact a model, use the question to perform semantic reasoning, or create changes on your behalf. AI integration is a possible future extension, not a bundled feature. No promises of free unlimited AI are made.

Dates and reminders refresh while the app is running, including after the local calendar date changes. There are no background jobs or system notifications when the app is closed. Always-on-top compact windows, full chat history and multi-device sync are not implemented in this release.

## Local data and backup

The app starts empty. It does not ship the original author's research records, wiki, calendars, email addresses, conversations or credentials.

Data is saved on explicit UI changes to:

```text
~/Library/Application Support/Research Desk Share/desk.json
```

`desk.previous.json` retains the previous saved version. Quit the app before manually restoring a backup. Back up this folder regularly; the single previous version is not a complete history. Invalid or unreadable data disables editing rather than replacing the file. Save failures are displayed in the footer. The app uses a separate bundle identifier and storage folder from the private Jina's Desk app.

Quit the app and move the application bundle to Trash to uninstall it. Data is deliberately retained. Delete the data folder only if you want to permanently remove your records.

## Recommended optional integrations

For a more personalized assistant, consider adding the following integrations in your own fork. **They are recommendations, not installed connectors or working features of this release.** This app currently blocks remote network requests in its embedded UI.

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
```

The app uses AppKit and WKWebView with local HTML/CSS/JavaScript. There are no third-party JavaScript packages. Node.js is only used for development tests. Build output goes to `dist/`, ignored by Git. Do not commit the generated app, runtime data, credentials, logs containing private content, or personal integration configuration.

## Artwork and licensing

The beaver mascot was created with the help of [IP as Logo](https://github.com/s1dashu/ip-as-logo-skill) by s1dashu and Codex image generation. The included character images are free to reuse, modify, and redistribute, including commercially. Attribution is appreciated but not required; see [ASSETS.md](ASSETS.md) for the permission and provenance details.

An open-source license for the application code has not yet been selected. The artwork permission does not license the code. This repository is maintained separately from the private research workspace.
