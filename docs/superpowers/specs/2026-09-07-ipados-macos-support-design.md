# iPadOS + macOS Support — Design Spec

**Date:** 2026-09-07
**Status:** Approved design, pending implementation plan

## Goal

Ship Iterly as a native app on iPadOS and macOS with feature parity with the iPhone app: all four tabs, attachments, cross-promo ads, the Remove Ads purchase, CloudKit sync, and the Activity widget.

## Decisions made

- **Native macOS target** via SwiftUI multiplatform destinations (not Mac Catalyst, not "Designed for iPad").
- **Navigation:** keep the existing `TabView`, adopt `.tabViewStyle(.sidebarAdaptable)`.
- **Ads:** full parity on macOS (interstitial + banner), same cadence.
- **Widgets:** the Activity widget ships on macOS in this release.

## 1. Targets & platforms

- Single multiplatform app target. Add `macosx` to `SUPPORTED_PLATFORMS` for the `Iterly` app target and the `IterlyWidgets` extension; set `MACOSX_DEPLOYMENT_TARGET = 26.0`. Do not create a separate Mac target — the codebase is pure SwiftUI with no UIKit imports, so a second target would only duplicate build settings.
- iPad is already enabled (`TARGETED_DEVICE_FAMILY = "1,2"`); iPad work is layout polish only.
- `IterlyCore/Package.swift`: add `.macOS(.v26)` to `platforms`.
- `IterlyTests` runs on both platforms.

## 2. Entitlements & capabilities

- macOS requires **App Sandbox** (`com.apple.security.app-sandbox`) and **outgoing network** (`com.apple.security.network.client`) entitlements. Add these for macOS builds (separate macOS entitlements file, or platform-conditioned build settings — implementer's choice, prefer whichever keeps one source of truth).
- Existing CloudKit container (`iCloud.me.cilia.filippo.Iterly`) and App Group (`group.cilia.filippo.Iterly`) carry over. Verify the App Group identifier provisions on macOS; the shared container path differs on macOS and must be verified at runtime (see §6 and §8).
- Push: macOS uses `com.apple.developer.aps-environment` (note the `com.apple.developer.` prefix, unlike iOS).
- **Universal purchase:** the Remove Ads product works on Mac with the same product ID. This is App Store Connect configuration only; no code change.

## 3. Navigation & layout

- Apply `.tabViewStyle(.sidebarAdaptable)` to the `TabView` in `ContentView`. iPhone keeps the tab bar; iPad and Mac get a sidebar.
- `NavigationStack` inside each tab stays as-is on all platforms.
- Wide-layout audit of all four tabs:
  - **Dashboard** and **Activity**: constrain content to a sensible max width or use adaptive grids where lists currently stretch edge-to-edge.
  - **Forms** (`TaskFormView`, `ProjectFormView`, `BrainstormFormView`, Settings forms): apply `.formStyle(.grouped)` on macOS.
- No hard-coded screen-size assumptions may be introduced; use `.containerRelativeFrame()` / adaptive layout where sizing is needed.

## 4. Platform-specific API cleanup

Known iOS-only usages and their resolutions:

| Usage | Location | Resolution |
|---|---|---|
| `.fullScreenCover` (interstitial ad) | `ContentView.swift` | Cross-platform wrapper modifier: `.fullScreenCover` on iOS, `.sheet` on macOS |
| `.navigationBarTitleDisplayMode(.inline)` (6 uses) | form/detail views | Guard with `#if os(iOS)` via a small cross-platform modifier |
| Widget install tutorial | `WidgetTutorialView.swift` | macOS-specific copy (widget gallery on Mac, not the iOS home-screen flow) |

Verified already cross-platform (no change needed): `PhotosPicker`, `ImageThumbnailMaker` (ImageIO), `VideoThumbnailMaker` (AVFoundation), `openURL`, StoreKit 2, PrivateAds (declares macOS 14+).

Prefer one small shared modifier file (e.g. `View+Platform.swift`) over scattering `#if os` throughout views.

## 5. Ads — full parity

- Interstitial cadence (every 3rd `CrossPromoSignal` bump) and the banner behave identically on macOS; only the presentation container differs (§4).
- Verify `AdView`, `CrossPromoRemoveAdsInfoView`, and the Remove Ads paywall render at sane sizes in a macOS sheet (fixed min sizes if needed).
- Remove Ads purchase/restore must work on macOS (universal purchase, §2).

## 6. Widgets on macOS

- Add macOS destination to `IterlyWidgets`.
- Verify the Activity widget renders correctly in macOS widget sizes (same families; different chrome/backgrounds).
- Verify the App-Group-shared SwiftData container resolves correctly in the sandboxed macOS widget process — this is the highest-risk unknown; test it early.
- `ModelContext+WidgetReload` reload path must trigger widget refreshes on macOS too.

## 7. Mac niceties (in scope, deliberately small)

- Default and minimum window size on the `WindowGroup`.
- `Settings` scene reusing `SettingsView`, giving standard `Cmd+,`. The Settings tab remains in the sidebar too (hybrid not required; keep the tab for parity and discoverability).
- Keyboard shortcuts only where free, e.g. `Cmd+N` → new project.
- Explicitly **out of scope:** menu-bar extras, multi-window, drag-and-drop, toolbar customization, iPad pointer refinements.

## 8. Testing & verification

- Existing unit tests (`IterlyTests`) must pass on iOS and macOS.
- Build + run verification: iPhone simulator, iPad simulator, My Mac.
- Manual checklist per platform (iPad, Mac):
  1. All four tabs navigable; sidebar adapts correctly.
  2. Create project/task/subtask; attachments import and thumbnail.
  3. Interstitial fires on 3rd signal; banner renders; Remove Ads purchase and restore work and suppress ads.
  4. CloudKit sync round-trips with an iPhone build.
  5. Activity widget installs, renders, and refreshes after data changes.
- New logic introduced (platform wrapper modifiers, any layout view models) gets unit tests where testable.

## Risks

- **App Group container on macOS** (widget + app shared SwiftData store): path/provisioning differences. Mitigation: verify in week-one spike before layout polish.
- **pbxproj edits** for multiplatform destinations are fiddly by hand; prefer making destination changes in Xcode's UI or carefully validated pbxproj edits, and build immediately after.
- **macOS 26 deployment target** matches the project's stated standards; no back-deployment burden.
