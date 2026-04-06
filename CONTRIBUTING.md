# Contributing to BharatTesting Utilities

Thank you for your interest in contributing! This document outlines our development process and guidelines.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Development Setup

### Prerequisites
- Flutter 3.29+ (stable channel)
- Dart 3.5+
- Git
- Code editor (VS Code recommended with Flutter extension)

### Local Setup
```bash
# 1. Fork the repository on GitHub
# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/bharattesting-utilities.git
cd bharattesting-utilities

# 3. Install dependencies
cd core && dart pub get && cd ..
cd app && flutter pub get && cd ..

# 4. Create a feature branch
git checkout -b feature/your-feature-name

# 5. Verify setup
cd core && dart test && cd ..
cd app && flutter test && cd ..
```

## Development Workflow

### Branch Protection Rules
- **main** branch is protected
- All changes must go through Pull Requests
- PRs require owner approval (@navrattan)
- CI checks must pass before merge
- Squash merge preferred

### Branch Naming Convention
```
feature/add-new-identifier
fix/json-parser-edge-case
docs/update-api-documentation
test/add-golden-tests
refactor/simplify-state-management
```

### Commit Message Format
We use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

feat(data-faker): add Udyam number generator
fix(pdf-merger): handle empty file selection
docs(readme): update installation instructions
test(core): add edge cases for GSTIN validation
refactor(ui): extract reusable components
```

**Types:** `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `chore`, `ci`

### Pull Request Process

1. **Create Issue First** (for non-trivial changes)
2. **Fork & Branch** from main
3. **Implement** following our guidelines below
4. **Test** thoroughly (see Quality Gates)
5. **Create PR** with descriptive title and body
6. **Address Review** feedback
7. **Squash & Merge** after approval

### PR Template
Your PR description should include:

```markdown
## Summary
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Testing
- [ ] Unit tests pass (`dart test`)
- [ ] Widget tests pass (`flutter test`)
- [ ] Manual testing completed
- [ ] Golden tests updated (if UI changes)

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated (if needed)
- [ ] No breaking changes (or clearly documented)
```

## Quality Gates

All PRs must pass these checks:

### 1. Code Analysis
```bash
flutter analyze
```
Zero issues allowed.

### 2. Formatting
```bash
dart format --set-exit-if-changed .
```
Code must be formatted.

### 3. Unit Tests
```bash
cd core && dart test
```
All tests must pass, aim for 90%+ coverage.

### 4. Widget Tests
```bash
cd app && flutter test
```
All tests must pass.

### 5. Build Verification
```bash
cd app
flutter build web --release
flutter build apk --debug
```
Must build without errors.

## Architecture Guidelines

### File Organization
```
app/lib/
├── main.dart                 # App entry point
├── app.dart                  # MaterialApp setup
├── router/                   # GoRouter configuration
├── theme/                    # Material 3 theme
├── shared/
│   ├── widgets/              # Reusable UI components
│   └── providers/            # Shared state providers
└── features/
    └── tool_name/
        ├── tool_screen.dart  # Main screen
        ├── tool_provider.dart # Riverpod provider
        ├── tool_state.dart   # State classes
        └── widgets/          # Tool-specific widgets
```

### Coding Standards

#### State Management
- Use **Riverpod** for all state
- Prefer `AsyncNotifier` for async operations
- State classes should be immutable with `copyWith`
- Use `freezed` for complex state classes

#### UI Guidelines
- Use **Material 3** components only
- Follow **responsive design** (mobile/tablet/desktop)
- Use **lucide_icons** (tree-shake Material icons)
- Dark mode default, light mode supported
- Accessibility: semantic labels, 48dp touch targets

#### Error Handling
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

#### Performance
- Use `compute()` for heavy operations (>100ms)
- Lazy load large lists
- Optimize image operations in isolates
- Target 60 FPS, < 200 MB memory peak

### Testing Guidelines

#### Unit Tests (core/)
```dart
group('PAN Generator', () {
  test('generates valid PAN for individual', () {
    final pan = PANGenerator.generate(EntityType.individual);
    expect(pan, matches(RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')));
    expect(PANValidator.isValid(pan), isTrue);
  });

  test('respects seed for reproducibility', () {
    final pan1 = PANGenerator.generate(EntityType.individual, seed: 123);
    final pan2 = PANGenerator.generate(EntityType.individual, seed: 123);
    expect(pan1, equals(pan2));
  });
});
```

#### Widget Tests (app/)
```dart
testWidgets('DataFaker screen generates records', (tester) async {
  await tester.pumpApp(const DataFakerScreen());
  
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  expect(find.text('Generated 1 record'), findsOneWidget);
});
```

## Project Constraints

### Hard Rules (NEVER violate)
- **Zero network calls** — not even analytics or crash reporting
- **Zero backend** — everything client-side
- **100% offline** after initial load
- **Privacy-first** — files processed in memory only
- **MIT license** — all code open source

### Architecture Rules
- Core package: **pure Dart**, no Flutter imports
- Feature-first folder structure
- Heavy work in **Isolates** using `compute()`
- No hardcoded strings, use `l10n`

## Specific Contribution Areas

### 🇮🇳 Indian Data Faker
- **New Identifiers:** See [template](https://github.com/btqas/bharattesting-utilities/issues/new?template=new_identifier_request.yml)
- **Validation Logic:** Implement proper checksums (Verhoeff, Luhn, etc.)
- **Lookup Data:** State codes, bank codes, industry codes
- **Cross-field Consistency:** GSTIN contains PAN, IFSC matches bank

### 🎨 UI/UX Improvements
- **Material 3** components and theming
- **Responsive design** across breakpoints
- **Accessibility** improvements
- **Dark/light mode** polish

### 🧪 Testing
- **Golden tests** for UI consistency
- **E2E tests** using Patrol
- **Edge cases** for all generators
- **Performance tests** for batch operations

### 📖 Documentation
- **API documentation** for core package
- **User guides** for each tool
- **Developer tutorials**

## Getting Help

- **Questions:** [GitHub Discussions](https://github.com/btqas/bharattesting-utilities/discussions)
- **Bugs:** [Bug Report](https://github.com/btqas/bharattesting-utilities/issues/new?template=bug_report.yml)
- **Features:** [Feature Request](https://github.com/btqas/bharattesting-utilities/issues/new?template=feature_request.yml)

## Recognition

Contributors will be:
- Listed in `CHANGELOG.md`
- Mentioned in release notes
- Added to `README.md` contributors section (for significant contributions)

---

**Made with ❤️ in Bengaluru • BTQA Services Pvt Ltd**