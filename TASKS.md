# BharatTesting Utilities — Build Tasks (Ordered)

Complete each task fully before moving to the next. Each task must include:
- Working code
- Passing tests (where applicable)
- Git commit with descriptive message

Mark tasks done with `[x]` as you complete them.

---

## Phase 1: Foundation (Week 1)

### Task 1.1: Initialize Monorepo
- [x] Create `bharattesting-utilities/` root directory
- [x] Create `core/` package with `pubspec.yaml` (pure Dart, no Flutter dependency)
- [x] Create `app/` Flutter project: `flutter create --org com.btqas --project-name bharattesting_app app`
- [x] Add `core` as path dependency in `app/pubspec.yaml`
- [x] Create `docs/` folder, copy `BharatTesting_Developer_Spec.pdf` into it
- [x] Create `LICENSE` (MIT full text)
- [x] Create `README.md` from template in spec Section 37
- [x] Create `CONTRIBUTING.md` with branch/PR rules
- [x] Create `CODE_OF_CONDUCT.md` (Contributor Covenant)
- [x] Create `CHANGELOG.md` with initial entry
- [x] Verify: `cd core && dart pub get && dart test` (empty test passes)
- [x] Verify: `cd app && flutter pub get && flutter run -d chrome`
- [x] **Commit:** `feat: initialize monorepo structure`

### Task 1.2: GitHub Configuration
- [x] Create `.github/CODEOWNERS` (owner approves all)
- [x] Create `.github/PULL_REQUEST_TEMPLATE.md` (from spec Section 25.4)
- [x] Create `.github/ISSUE_TEMPLATE/bug_report.yml`
- [x] Create `.github/ISSUE_TEMPLATE/feature_request.yml`
- [x] Create `.github/ISSUE_TEMPLATE/new_identifier_request.yml`
- [x] Create `.github/stale.yml` (60-day stale, 14-day close)
- [x] Create `.github/dependabot.yml` (weekly pub updates)
- [x] **Commit:** `chore: add GitHub templates and automation config`

### Task 1.3: CI/CD Workflows
- [x] Create `.github/workflows/pr-checks.yml` (from spec Section 31.1)
- [x] Create `.github/workflows/build-main.yml` (from spec Section 31.2)
- [x] Create `.github/workflows/release.yml` (from spec Section 31.3)
- [x] **Commit:** `ci: add GitHub Actions workflows`

### Task 1.4: Lint & Analysis
- [x] Create `core/analysis_options.yaml` (from spec Section 33)
- [x] Create `app/analysis_options.yaml` (from spec Section 33)
- [x] Run `flutter analyze` — must pass with zero issues
- [x] **Commit:** `chore: add analysis_options lint rules`

### Task 1.5: Theme & Design System
- [x] Create `app/lib/theme/app_colors.dart` — all color tokens (dark + light) from spec Section 7.1
- [x] Create `app/lib/theme/app_typography.dart` — text styles from spec Section 7.2
- [x] Create `app/lib/theme/app_theme.dart` — ThemeData.dark() + ThemeData.light() with Material 3
- [x] Verify: app launches in dark mode by default
- [x] **Commit:** `feat: add Material 3 theme system (dark + light)`

### Task 1.6: Routing & Navigation Shell
- [x] Create `app/lib/router/app_router.dart` — GoRouter config with all 7 routes (from spec Section 6)
- [x] Create `app/lib/shared/widgets/responsive_layout.dart` (from spec Section 8)
- [x] Create `app/lib/shared/widgets/btqa_footer.dart` — footer on every screen
- [x] Create `app/lib/shared/widgets/tool_scaffold.dart` — shared scaffold with AppBar + footer
- [x] Create `app/lib/shared/widgets/github_buttons.dart` — Star, Report Bug, Contribute buttons
- [x] Create `app/lib/app.dart` — MaterialApp.router with theme + GoRouter
- [x] Create `app/lib/main.dart` — ProviderScope entry point
- [x] Verify: navigation works between all routes on mobile and web
- [x] **Commit:** `feat: add GoRouter navigation with responsive shell`

### Task 1.7: Home Screen
- [x] Create `app/lib/features/home/home_screen.dart` — tool card grid (from spec Section 28)
- [x] Create tool card widget with icon, name, description, tap-to-navigate
- [x] Verify: all 5 tool cards render and navigate to placeholder screens
- [x] **Commit:** `feat: add home screen with tool cards`

---

## Phase 2: Core Logic — Data Faker (Week 2)

### Task 2.1: Checksum Algorithms
- [x] Create `core/lib/src/data_faker/checksums/verhoeff.dart` — full Verhoeff with lookup tables
- [x] Create `core/lib/src/data_faker/checksums/luhn_mod36.dart` — GSTIN checksum
- [x] Write unit tests: known valid Aadhaar numbers pass, invalid fail
- [x] Write unit tests: known valid GSTINs pass, invalid fail
- [x] **Commit:** `feat(core): add Verhoeff and Luhn Mod-36 checksum algorithms`

### Task 2.2: Lookup Data
- [x] Create `core/lib/src/data_faker/data/state_codes.dart` — GSTIN 01-37, PIN-to-state, CIN codes
- [x] Create `core/lib/src/data_faker/data/bank_codes.dart` — 20+ IFSC prefixes, UPI handles
- [x] Create `core/lib/src/data_faker/data/industry_codes.dart` — CIN industry codes
- [x] Write unit tests: verify all maps are non-empty, keys valid
- [x] **Commit:** `feat(core): add Indian identifier lookup data`

### Task 2.3: Individual Generators
- [x] Create `core/lib/src/data_faker/pan_generator.dart` — valid PAN per entity type
- [x] Create `core/lib/src/data_faker/gstin_generator.dart` — valid GSTIN with Luhn Mod-36
- [x] Create `core/lib/src/data_faker/aadhaar_generator.dart` — valid Aadhaar with Verhoeff
- [x] Create `core/lib/src/data_faker/cin_generator.dart` — valid CIN format
- [x] Create `core/lib/src/data_faker/tan_generator.dart` — valid TAN format
- [x] Create `core/lib/src/data_faker/ifsc_generator.dart` — valid IFSC from bank codes
- [x] Create `core/lib/src/data_faker/upi_generator.dart` — valid UPI linked to bank
- [x] Create `core/lib/src/data_faker/udyam_generator.dart` — valid Udyam format
- [x] Create `core/lib/src/data_faker/pin_code_generator.dart` — valid PIN linked to state
- [x] Create `core/lib/src/data_faker/address_generator.dart` — city/state linked to PIN
- [x] Write unit tests for EACH generator: format validation, checksum verification
- [x] Write unit test: seed reproducibility (same seed → same output)
- [x] **Commit:** `feat(core): add all 9 Indian identifier generators with tests`

### Task 2.4: Cross-Field Consistency & Templates
- [x] Create `core/lib/src/data_faker/templates/individual_template.dart`
- [x] Create `core/lib/src/data_faker/templates/company_template.dart`
- [x] Create `core/lib/src/data_faker/templates/proprietorship_template.dart`
- [x] Create `core/lib/src/data_faker/templates/partnership_template.dart`
- [x] Create `core/lib/src/data_faker/templates/trust_template.dart`
- [x] Implement cross-field rules: PAN↔GSTIN, state↔PIN, IFSC↔bank↔UPI, CIN↔state
- [x] Write unit tests: verify cross-field consistency in generated records
- [x] Write unit tests: bulk generation 10,000 records completes in < 3 seconds
- [x] **Commit:** `feat(core): add 5 faker templates with cross-field consistency`

### Task 2.5: Export (Core)
- [x] Implement CSV export in core
- [x] Implement JSON export in core
- [x] Implement XLSX export in core (using archive package)
- [x] Write unit tests for each export format
- [x] **Commit:** `feat(core): add CSV, JSON, XLSX export for faker`

### Task 2.6: Data Faker UI
- [x] Create `app/lib/features/data_faker/faker_state.dart`
- [x] Create `app/lib/features/data_faker/faker_provider.dart`
- [x] Create `app/lib/features/data_faker/faker_screen.dart`
- [x] Create widgets: template_selector, identifier_picker, bulk_slider, generated_preview, export_options
- [x] Add disclaimer text on screen
- [x] Verify: generate single record, toggle identifiers, switch templates, export CSV
- [x] Write widget tests for faker_screen
- [x] **Commit:** `feat: add Indian Data Faker UI with full functionality`

---

## Phase 3: Core Logic — JSON Converter + Image Reducer (Week 3)

### Task 3.1: JSON Converter Core
- [x] Create `core/lib/src/json_converter/string_parser.dart` — detect input format
- [x] Create `core/lib/src/json_converter/auto_repair.dart` — 6 repair rules
- [x] Create `core/lib/src/json_converter/csv_parser.dart`
- [x] Create `core/lib/src/json_converter/yaml_parser.dart`
- [x] Create `core/lib/src/json_converter/json_formatter.dart` — pretty-print + minify
- [x] Write unit tests: each repair rule, each input format, edge cases
- [x] **Commit:** `feat(core): add JSON converter with auto-repair`

### Task 3.2: JSON Converter UI
- [x] Create state, provider, screen for json_converter feature
- [x] Create widgets: input_editor, output_viewer (syntax highlighted), format_toggle
- [x] Add error highlighting with line/column
- [x] Copy/Download buttons
- [x] Write widget tests
- [x] **Commit:** `feat: add String-to-JSON Converter UI`

### Task 3.3: Image Reducer Core
- [x] Create `core/lib/src/image_reducer/compressor.dart` — JPEG/PNG compression
- [x] Create `core/lib/src/image_reducer/resizer.dart` — preset + custom resize
- [x] Create `core/lib/src/image_reducer/format_converter.dart` — format conversion
- [x] Create `core/lib/src/image_reducer/metadata_stripper.dart` — EXIF removal
- [x] Write unit tests: compressed size < original, resize dimensions correct
- [x] **Commit:** `feat(core): add image compression and resize logic`

### Task 3.4: Image Reducer UI
- [x] Create state, provider, screen for image_reducer feature
- [x] Create widgets: quality_slider, before_after_slider, format_picker, batch_list
- [x] File picker + drag-and-drop (desktop_drop)
- [x] Real-time preview (debounced 300ms)
- [x] Batch processing with progress bar
- [x] ZIP export for batch
- [x] Write widget tests
- [x] **Commit:** `feat: add Image Size Reducer UI with batch support`

---

## Phase 4: PDF Merger + Document Scanner (Week 4)

### Task 4.1: PDF Merger Core
- [x] Create `core/lib/src/pdf_merger/merger.dart` — merge multiple PDFs
- [x] Create `core/lib/src/pdf_merger/page_manipulator.dart` — rotate, delete, reorder
- [x] Create `core/lib/src/pdf_merger/encryptor.dart` — password protection
- [x] Write unit tests: merged page count = sum, rotation, password set
- [x] **Commit:** `feat(core): add PDF merge, rotate, encrypt logic`

### Task 4.2: PDF Merger UI
- [x] Create state, provider, screen for pdf_merger feature
- [x] Create widgets: pdf_page_grid (thumbnails), reorderable_page_list, password_dialog
- [x] Drag & drop file upload
- [x] Drag & drop page reorder
- [x] Visual page thumbnails (lazy-loaded)
- [x] Progress bar for merge operation
- [x] Write widget tests
- [x] **Commit:** `feat: add PDF Merger UI with drag-and-drop reorder`

### Task 4.3: Document Scanner Core
- [x] Create `core/lib/src/document_scanner/edge_detector.dart` — Canny + contour + quadrilateral
- [x] Create `core/lib/src/document_scanner/perspective_corrector.dart` — homography transform
- [x] Create `core/lib/src/document_scanner/image_enhancer.dart` — 6 filters (CLAHE, threshold, etc.)
- [x] Create `core/lib/src/document_scanner/ocr_processor.dart` — ML Kit text extraction
- [x] Write unit tests: filter output not empty, dimensions correct
- [x] **Commit:** `feat(core): add document scanner image processing pipeline`

### Task 4.4: Document Scanner UI
- [x] Create state, provider, screen for document_scanner feature
- [x] Create widgets: camera_preview, crop_overlay (green polygon), filter_selector, page_thumbnail_strip
- [x] Camera permission handling (permission_handler)
- [x] Auto-capture logic (stability timer)
- [x] Multi-page batch with reorder
- [x] PDF export with searchable text layer
- [x] Web fallback: image upload + manual 4-corner crop
- [x] Write widget tests
- [x] **Commit:** `feat: add Document Scanner UI with camera and filters`

---

## Phase 5: Polish & Testing (Week 5)

### Task 5.1: Golden Tests
- [x] Set up alchemist golden test infrastructure
- [x] Capture goldens for all screens: dark mode, 375w (mobile)
- [x] Capture goldens for all screens: dark mode, 1280w (desktop)
- [x] Capture goldens for all screens: light mode, 375w (mobile)
- [x] Capture goldens for all screens: light mode, 1280w (desktop)
- [x] All golden tests pass
- [x] **Commit:** `test: add golden screenshots for all screens`

### Task 5.2: E2E Tests (Patrol)
- [x] Set up Patrol CLI and test infrastructure
- [x] E2E: Document Scanner — permission → capture → filter → export
- [x] E2E: Image Reducer — pick → compress → download
- [x] E2E: PDF Merger — pick 3 → reorder → merge → verify
- [x] E2E: JSON Converter — paste broken → repair → copy
- [x] E2E: Data Faker — company template → 100 records → CSV export
- [x] All E2E tests pass on Android emulator
- [x] **Commit:** `test: add Patrol E2E tests for all 5 tools`

### Task 5.3: Performance Optimization
- [x] Run `flutter build apk --analyze-size` — verify < 25 MB
- [x] Profile frame rate with DevTools — verify 60fps on all screens
- [x] Profile memory — verify < 200MB peak during batch operations
- [x] Verify image compression 10MB < 2s
- [x] Verify PDF merge 10 files < 5s
- [x] Verify data faker 10K records < 3s
- [x] Move any blocking operations to Isolates if not already
- [x] **Commit:** `perf: optimize all tools to meet performance targets`

### Task 5.4: Responsive Polish
- [x] Test all screens at 375w (phone)
- [x] Test all screens at 768w (tablet)
- [x] Test all screens at 1280w (desktop)
- [x] Fix any layout overflow or sizing issues
- [x] Verify bottom nav (mobile), nav rail (tablet), top nav (desktop)
- [x] **Commit:** `fix: polish responsive layouts across all breakpoints`

### Task 5.5: Accessibility
- [x] Add Semantics labels to all interactive widgets
- [x] Verify touch targets ≥ 48x48dp
- [x] Verify color contrast WCAG AA (4.5:1 text, 3:1 large text)
- [x] Test with TalkBack/VoiceOver (manual)
- [x] Web: keyboard navigation works for all tools
- [x] **Commit:** `a11y: add semantic labels and verify accessibility`

---

## Phase 6: Deployment (Week 6)

### Task 6.1: App Icons & Splash
- [x] Create 1024x1024 app icon (BT monogram, blue on dark)
- [x] Configure flutter_launcher_icons (from spec Section 34.1)
- [x] Configure flutter_native_splash (from spec Section 34.2)
- [x] Run icon + splash generators
- [x] Verify on Android + iOS + Web
- [x] **Commit:** `chore: add app icons and splash screen`

### Task 6.2: SEO & Web Config
- [x] Add meta tags to `app/web/index.html` (from spec Section 36)
- [x] Create `vercel.json` (from spec Section 32)
- [x] Create OG image (1200x630)
- [x] Configure PWA manifest.json (from spec Section 9.5)
- [x] Service worker caching strategy
- [x] **Commit:** `chore: add SEO meta tags, Vercel config, PWA setup`

### Task 6.3: Android Release Build
- [x] Create release keystore
- [x] Configure signing in build.gradle
- [x] Add ProGuard rules (from spec Section 35)
- [x] Build signed AAB: `flutter build appbundle --release`
- [x] Build APK: `flutter build apk --release --split-per-abi`
- [x] Test APK on real device
- [x] **Commit:** `chore: configure Android release signing`

### Task 6.4: iOS Release Build
- [x] Configure Xcode signing
- [x] Build: `flutter build ios --release`
- [x] Test on real device or TestFlight
- [x] **Commit:** `chore: configure iOS release build`

### Task 6.5: Deploy Web
- [ ] Connect repo to Vercel
- [ ] Configure build command: `cd app && flutter build web --release --web-renderer canvaskit`
- [ ] Set output directory: `app/build/web`
- [ ] Add custom domain: bharattesting.com
- [ ] Verify all routes work with direct URL access
- [ ] **Commit:** `deploy: web live on bharattesting.com`

### Task 6.6: Final Checks
- [ ] All CI/CD workflows pass
- [ ] README badges working (build status, license, stars)
- [ ] GitHub Discussions enabled
- [ ] Branch protection rules set on main
- [ ] All issue templates working
- [ ] CODEOWNERS file correct
- [ ] Footer visible on every screen
- [ ] Disclaimer on Data Faker screen
- [ ] About page accessible
- [ ] **Commit:** `chore: final pre-launch verification`

---

## Done Criteria
All tasks above marked `[x]`. All CI pipelines green. App running on Android + iOS + Web. Owner (Navrattan) has reviewed and approved.
