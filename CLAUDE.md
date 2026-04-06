# BharatTesting Utilities — Claude Code Agent Instructions

## Identity
You are the sole developer building BharatTesting Utilities — 5 free, privacy-first, 100% offline developer tools delivered as a Flutter monorepo (Android + iOS + Web). You report to the owner Navrattan. Every PR must be reviewed and approved by the owner.

## Project Reference
The complete developer specification is in `docs/BharatTesting_Developer_Spec.pdf` (50 pages). Read it fully before writing any code. When in doubt, the PDF is the single source of truth.

## Core Constraints (NEVER violate)
- **Zero network calls.** No HTTP, no REST, no WebSocket, no analytics, no crash reporting. Everything is client-side.
- **Zero backend.** No Firebase, no Supabase, no cloud functions. Period.
- **Zero tracking.** No analytics SDK, no cookies, no telemetry. Not even anonymous.
- **100% offline.** Every tool must work without internet after initial app/page load.
- **Privacy-first.** Files are processed in memory. Camera frames never saved to disk except by explicit user action.
- **MIT License.** All code is open-source.
- **No monetization.** No ads, no paywalls, no premium tiers, no "pro" features.

## Tech Stack (Locked — do NOT substitute)
| Layer | Technology | Version |
|-------|-----------|---------|
| Framework | Flutter (Dart) | 3.29+ stable |
| State Management | Riverpod | 2.0+ with riverpod_generator |
| Routing | GoRouter | 14.x+ |
| UI System | Material 3 | useMaterial3: true, dark mode default |
| Camera/CV | camera + opencv_dart (FFI) + google_mlkit_text_recognition | Latest stable |
| Image Processing | image package | Pure Dart |
| PDF | pdf + printing packages | Pure Dart |
| Data Faker | Pure Dart | Custom checksum implementations |
| JSON Converter | Pure Dart + flutter_highlight | Syntax highlighting |
| Web Renderer | CanvasKit | Primary renderer |
| Hosting | Vercel (free tier) | Auto-deploy from main |
| CI/CD | GitHub Actions | Free for public repos |

## Monorepo Structure
```
bharattesting-utilities/
├── core/              # Shared pure-Dart packages (NO Flutter dependency)
│   ├── lib/src/       # data_faker/, image_reducer/, pdf_merger/, json_converter/, document_scanner/
│   ├── test/          # Unit tests (target: 200+)
│   └── pubspec.yaml
├── app/               # Flutter app (Android + iOS + Web)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── router/app_router.dart
│   │   ├── theme/     # app_theme.dart, app_colors.dart, app_typography.dart
│   │   ├── shared/    # widgets/ (btqa_footer, tool_scaffold, file_drop_zone, responsive_layout, github_buttons)
│   │   ├── features/  # home/, document_scanner/, image_reducer/, pdf_merger/, json_converter/, data_faker/
│   │   └── l10n/      # app_en.arb (English only, but i18n-ready)
│   ├── test/          # Widget tests (target: 100+)
│   ├── integration_test/ # Patrol E2E tests (target: 20+)
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── pubspec.yaml
├── docs/              # BharatTesting_Developer_Spec.pdf, ARCHITECTURE.md, SETUP.md
├── .github/           # workflows/, ISSUE_TEMPLATE/, PULL_REQUEST_TEMPLATE.md, CODEOWNERS
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── LICENSE            # MIT
└── README.md
```

## Architecture Rules
1. **Feature-first folder structure.** Each tool = one folder under `app/lib/features/` with: screen, provider, state, widgets/.
2. **Core logic in core/ package.** All pure-Dart business logic (checksums, parsers, compressors) lives in `core/`. No Flutter imports in core/.
3. **Riverpod providers.** Each feature has an AsyncNotifier (or StateNotifier). State classes are immutable with copyWith.
4. **GoRouter.** Single router config in `app/lib/router/app_router.dart`. ShellRoute wraps the navigation scaffold. Web routes: `/`, `/document-scanner`, `/image-reducer`, `/pdf-merger`, `/string-to-json`, `/indian-data-faker`, `/about`.
5. **Responsive.** Use a `ResponsiveLayout` widget: < 600dp = mobile (bottom nav), 600-1024dp = tablet (nav rail), > 1024dp = desktop/web (top nav + side nav). Max content width 1200dp.
6. **Heavy work in Isolates.** Use `compute()` for: image compression, PDF merge, bulk data generation (>100 records), OCR processing.
7. **No hardcoded strings.** All user-facing text in `app/lib/l10n/app_en.arb`. Use `context.l10n.keyName`.

## The 5 Tools — Key Implementation Notes

### Tool 1: Document Scanner
- Camera at 30fps → downscale to 640px → Gaussian blur → Canny edge (50/150) → findContours → approxPolyDP → 4 corners
- Auto-capture when quadrilateral stable for 1.5s
- Perspective correction: getPerspectiveTransform + warpPerspective (opencv_dart)
- 6 filters: Original, Auto-Color (CLAHE), Grayscale, B&W (adaptiveThreshold), Magic Color, Whiteboard (morphologyEx + adaptiveThreshold)
- OCR: google_mlkit_text_recognition (on-device, ML Kit)
- Export: multi-page searchable PDF with invisible text layer
- **Web fallback:** No live camera. Upload image → manual 4-corner drag crop → same filters/export

### Tool 2: Image Size Reducer
- Quality slider 1-100, real-time estimated output size (debounced 300ms)
- Formats: JPEG, PNG, WebP (platform channel), AVIF (Android 12+/iOS 16+)
- Resize presets: Thumbnail (150px), Small (640px), HD (1280px), Full HD (1920px), 4K (3840px), Custom, Percentage
- Metadata stripping toggle (EXIF, GPS)
- Before/after comparison slider widget
- Batch up to 50 images, ZIP export

### Tool 3: PDF Merger
- Up to 20 PDFs, 100MB total
- Visual page grid with thumbnails (200px width, lazy-loaded)
- Drag & drop reorder, delete pages, rotate (90/180/270°)
- Auto-generate bookmarks from source filenames
- Optional password protection
- Use pdf package for output; pdf.js (JS interop) for web thumbnails

### Tool 4: String-to-JSON Converter
- Auto-detect: raw string, CSV, YAML, XML, URL-encoded, INI
- 6 auto-repair rules: trailing commas, single quotes, unquoted keys, JS comments, Python None/True/False, trailing text
- Syntax-highlighted output (flutter_highlight)
- Error highlighting: line/column + suggested fix
- Copy / Download / Minify / Pretty-print toggle

### Tool 5: Indian Data Faker
- 9 identifiers: PAN, GSTIN, Aadhaar, CIN, TAN, IFSC, UPI, Udyam, PIN Code
- Checksums: Verhoeff (Aadhaar), Luhn Mod-36 (GSTIN). Full lookup tables in code.
- 5 templates: Individual, Company, Proprietorship, Partnership, Trust
- Cross-field consistency: GSTIN contains PAN, state codes match PIN, IFSC matches bank, UPI matches bank
- Seed-based reproducible generation: Random(seed) → identical output
- Bulk: 100 / 1,000 / 10,000 rows
- Export: CSV, JSON, XLSX, Clipboard
- Embed const maps: 37 GSTIN state codes, PIN-to-state, 20+ bank IFSC prefixes, UPI handles
- **Disclaimer on screen:** "All data is synthetic. Do not use for fraud."

## Theme (Material 3)
- Dark mode default
- Primary: #58A6FF (dark) / #0969DA (light)
- Surface: #0D1117 (dark) / #FFFFFF (light)
- Secondary (success/generate): #3FB950 / #1A7F37
- Error: #F85149 / #CF222E
- Spacing: multiples of 4dp. Card radius: 12dp. Button radius: 8dp.
- No custom fonts — system default + Courier for code blocks
- Icons: lucide_icons only (tree-shake Material icons)

## Branding (Subtle)
- Footer on EVERY screen: `Built by BTQA Services Pvt Ltd • Open Source on GitHub • Made in Bengaluru`
- "BTQA Services Pvt Ltd" = small gray hyperlink to btqas.com
- No big logos, no banners, no marketing popups
- Hidden About page at /about

## Testing
- **Unit (core/test/):** All checksums, parsers, compressors. Target: 200+ tests.
- **Widget (app/test/):** Individual widgets, state rendering. Target: 100+.
- **Golden (app/test/golden/):** Every screen, dark+light mode, 375w+1280w. Use alchemist.
- **E2E (app/integration_test/):** Patrol. Camera permission → scan → export. Pick image → compress. Merge PDFs. Paste broken JSON → repair. Generate 100 records → export.
- **Do NOT use flutter_driver** (deprecated).
- Mocking: mocktail.

## Error Handling Pattern
```dart
Future<void> operation() async {
  state = state.copyWith(isProcessing: true, error: null);
  try {
    final result = await _coreLogic.process(state.input);
    state = state.copyWith(isProcessing: false, output: result);
  } catch (e) {
    state = state.copyWith(isProcessing: false, error: _userFriendlyMessage(e));
  }
}
```
- User-facing errors: SnackBar with message + retry.
- Never show raw stack traces.
- Camera permission denied → show "Open Settings" button.

## Performance Targets
| Metric | Target |
|--------|--------|
| APK size | < 25 MB |
| Web initial load | < 4 MB gzipped |
| Frame rate | 60 fps |
| Image compress (10MB) | < 2s |
| PDF merge (10 files) | < 5s |
| Data faker (10K records) | < 3s |
| Memory peak | < 200 MB |

## File Operations
- Mobile save: `getApplicationDocumentsDirectory() / 'BharatTesting' / tool_name /`
- Mobile share: share_plus → OS share sheet
- Mobile print (PDF): printing package
- Web download: Blob URL + anchor tag click
- Web bulk: ZIP via archive package
- File naming: `tool_name_YYYYMMDD_HHmmss.ext`

## Platform Config Reminders
- **Android:** minSdk 24, targetSdk 35, compileSdk 35, multidex true, ProGuard keep rules for opencv_dart + MLKit
- **iOS:** deployment target 15.0, CocoaPods, Info.plist camera/photo permissions
- **Web:** CanvasKit renderer, PWA manifest, service worker, CSP headers, no cookies

## Git Workflow
- Branch protection on `main`
- All changes via PR
- CODEOWNERS: owner approves every PR
- Squash merge preferred
- CI must pass before merge

## Build Order (Follow TASKS.md)
Always follow the task order in `TASKS.md`. Complete each task fully (including tests) before moving to the next. Never skip ahead. Commit after each completed task with a descriptive message.

## When Stuck
1. Re-read the relevant section in `docs/BharatTesting_Developer_Spec.pdf`
2. Check Flutter docs: https://docs.flutter.dev
3. Check package docs on pub.dev
4. If truly blocked, create a GitHub Issue describing the blocker and move to the next non-blocked task
