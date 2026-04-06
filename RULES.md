# BharatTesting Utilities — Agent Rules & Constraints

## HARD RULES (Never Violate)

### Architecture
- NEVER add any network call, HTTP request, or API endpoint
- NEVER import dart:io in core/ package (pure Dart only — no Flutter, no platform deps)
- NEVER use flutter_driver (deprecated) — use Patrol for E2E
- NEVER hardcode user-facing strings — all text goes in l10n/app_en.arb
- NEVER add Firebase, Supabase, or any cloud SDK
- NEVER add analytics, crash reporting, or telemetry of any kind
- NEVER create a backend, serverless function, or cloud endpoint

### Privacy
- NEVER store files to disk without explicit user action (save/export button)
- NEVER persist camera frames — process in memory only
- NEVER log user data, file contents, or generated test data
- NEVER add cookies, localStorage tracking, or fingerprinting on web

### Code Quality
- NEVER commit code that fails `flutter analyze`
- NEVER commit code that fails `dart format`
- NEVER commit without running existing tests first
- NEVER skip writing tests for core/ logic
- NEVER use print() — use dart:developer log() in debug mode only
- NEVER catch exceptions silently — always update state with user-friendly error

### UI
- NEVER show raw error stack traces to users
- NEVER use Material Icons — use lucide_icons only (tree-shake)
- NEVER omit the BTQA footer from any screen
- NEVER create marketing popups, banners, or email capture forms
- NEVER make the BTQA branding prominent — it must be subtle gray footer text only

### Performance
- NEVER run image compression, PDF merge, or bulk generation (>100) on the main thread
- NEVER load full-resolution images for thumbnails — use ResizeImage
- NEVER process every camera frame — process every 3rd frame for edge detection

---

## CODING PATTERNS (Always Follow)

### State Management
```
1. Create XxxState class (immutable, with copyWith)
2. Create XxxNotifier extends AsyncNotifier<XxxState>
3. Use @riverpod annotation for code generation
4. State flows: UI → Provider → Core Logic → Provider → UI
```

### File Structure Per Feature
```
features/tool_name/
├── tool_name_screen.dart     # Top-level screen widget
├── tool_name_provider.dart   # Riverpod provider
├── tool_name_state.dart      # Immutable state class
└── widgets/                  # Feature-specific widgets
    ├── widget_a.dart
    └── widget_b.dart
```

### Error Handling
```dart
// ALWAYS wrap async ops in try-catch inside providers
Future<void> doWork() async {
  state = state.copyWith(isProcessing: true, error: null);
  try {
    final result = await compute(_heavyWork, input);
    state = state.copyWith(isProcessing: false, output: result);
  } catch (e) {
    state = state.copyWith(isProcessing: false, error: _toUserMessage(e));
  }
}
```

### Testing
```
core/test/         → dart test
app/test/          → flutter test
app/test/golden/   → flutter test --tags=golden
app/integration_test/ → patrol test
```

### Commit Messages
Use conventional commits:
- `feat:` new feature
- `fix:` bug fix
- `test:` adding tests
- `chore:` config, setup, tooling
- `perf:` performance improvement
- `a11y:` accessibility
- `ci:` CI/CD changes
- `deploy:` deployment
- `docs:` documentation

Format: `type(scope): description`
Example: `feat(core): add Verhoeff checksum algorithm with unit tests`

---

## DECISION REFERENCE

### When to use Isolate (compute())
- Image compression of any file > 1MB
- PDF merge of any kind
- Data faker bulk generation > 100 records
- OCR processing
- Any operation that takes > 500ms

### When to use Platform Channel
- WebP encoding (Android/iOS native encoders)
- AVIF encoding (Android 12+/iOS 16+)
- Camera stream processing (opencv_dart FFI already handles this)

### Web vs Mobile Differences
| Feature | Mobile | Web |
|---------|--------|-----|
| Document Scanner camera | Live camera with edge detection | Upload image + manual crop |
| WebP/AVIF | Platform channel native encoder | Not supported (use JPEG/PNG) |
| File save | Save to app documents + share sheet | Browser download (Blob URL) |
| Navigation | Bottom nav bar | Top navbar |
| OCR | google_mlkit_text_recognition | Not available (skip OCR on web) |

### Package Choices (Do NOT Substitute)
| Need | Package | Reason |
|------|---------|--------|
| State | flutter_riverpod + riverpod_generator | Owner decision — locked |
| Routing | go_router | Deep link support for web |
| Camera | camera | Official Flutter plugin |
| CV | opencv_dart | FFI — fast native processing |
| OCR | google_mlkit_text_recognition | On-device, no cloud |
| PDF create | pdf | Pure Dart, no native deps |
| PDF print | printing | Cross-platform print/share |
| File pick | file_picker | Cross-platform |
| Drag drop | desktop_drop | Web/desktop drag and drop |
| Share | share_plus | OS share sheet |
| Icons | lucide_icons | Consistent, tree-shakeable |
| Mocking | mocktail | No codegen needed |
| E2E | patrol | Native OS interaction |
| Golden | alchemist | Best Flutter golden testing |
| Syntax highlight | flutter_highlight | JSON/code display |
| Animations | flutter_animate | Smooth micro-animations |

---

## QUALITY GATES (Before Each Commit)

1. `flutter analyze` — zero issues
2. `dart format --set-exit-if-changed .` — no formatting violations
3. All existing tests pass
4. New code has corresponding tests
5. No TODOs left (either complete it or create a GitHub issue)
6. Footer present on new screens
7. Strings in l10n, not hardcoded
