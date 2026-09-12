# Research Desk 0.2 verification

Verified on macOS on 2026-09-12 with Codex CLI 0.153.4. Only synthetic project/task data was used for AI and UI checks.

- `node tests/model.cjs`: default stages, old desk compatibility, N/A exclusion/restoration, localized custom names, scores, reminder priorities, compact deadline list, malformed inputs, and chat persistence schema passed.
- `node --check Resources/app.js` and `node --check Resources/mini.js`: passed.
- `zsh build.sh` and `zsh build.sh --qa`: native Swift builds and ad-hoc signing passed.
- `tests/ChatChecks.swift` with `tests/fake-codex.py`: fragmented JSON-RPC response, successful answer, API-key account rejection, unexpected MCP tools, approval/tool requests, failed turn, timeout and cancellation passed.
- `.build/chat-checks --live`: the user's installed Codex answered a synthetic project-planning question using the existing ChatGPT login.
- Native UI: renamed a synthetic project's stage and marked another N/A; the displayed total decreased from 8 to 7. Confirmed custom labels, hatching/dash, suggested stage, Korean translation, and unchanged completed stage history.
- Native AI UI: first-send disclosure appeared; the actual answer correctly identified the synthetic deadline as today and seven applicable unfinished stages, distinguishing N/A from completion.
- Relaunch: custom stage settings and sent user/AI messages were restored. The persisted fixture is version 2; the original project's IDs and completed booleans remain intact.
- Small window: inspected the floating compact window containing the cat, two next actions, today's deadline and a second deadline six days away; returning to the full desk worked.
- Fixed a pre-existing file-navigation path alias issue (`/tmp` versus `/private/tmp`) exposed by native UI testing. Resource containment now compares canonical paths on both sides.

The QA build uses its own bundle ID and a fixed disposable `/private/tmp/research-desk-share-qa` folder. Test data, conversations, credentials and screenshots are not included in the repository. A matching existing local source checkout was used for the final delivery.

These checks do not establish compatibility with every Codex version or custom configuration, other Mac architectures, or macOS releases. The app remains a source-build, ad-hoc-signed release, not a Developer ID notarized distribution. No calendar, wiki or sync integration was added.
