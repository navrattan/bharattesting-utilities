# BharatTesting Utilities

**5 free, privacy-first, offline developer tools in one app** 🇮🇳

[![Flutter](https://img.shields.io/badge/Flutter-3.29+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Web App](https://img.shields.io/badge/Web-bharattesting.com-blue)](https://bharattesting.com)

## What's Inside

| Tool | Description | Status |
|------|-------------|--------|
| 📄 Document Scanner | Camera + OCR → Searchable PDF | 🚧 Coming Soon |
| 🖼️ Image Size Reducer | Compress, resize, batch process | 🚧 Coming Soon |
| 📑 PDF Merger | Merge, rotate, password-protect | 🚧 Coming Soon |
| 🔄 String-to-JSON | Auto-repair broken JSON/CSV/YAML | 🚧 Coming Soon |
| 🇮🇳 Indian Data Faker | Generate PAN, GSTIN, Aadhaar, etc. | 🚧 Coming Soon |

## Core Principles

- **🔒 100% Offline** — Zero network calls, zero backend, zero analytics
- **🛡️ Privacy-First** — Files processed in memory only, never uploaded
- **📱 Cross-Platform** — Android, iOS, Web (bharattesting.com)
- **🎨 Material 3** — Dark mode default, responsive design
- **🆓 Forever Free** — No ads, no premium tiers, open source MIT

## Quick Start

### Web App (Easiest)
Visit **[bharattesting.com](https://bharattesting.com)** — works offline after first load.

### Mobile App
Download from [Releases](https://github.com/btqas/bharattesting-utilities/releases) or build from source.

### Build from Source
```bash
# Prerequisites: Flutter 3.29+
git clone https://github.com/btqas/bharattesting-utilities.git
cd bharattesting-utilities

# Install dependencies
cd core && dart pub get && cd ..
cd app && flutter pub get && cd ..

# Run
cd app && flutter run -d chrome  # Web
cd app && flutter run            # Mobile
```

## Project Structure

```
bharattesting-utilities/
├── core/              # Pure Dart business logic (no Flutter dependency)
│   ├── lib/src/
│   │   ├── data_faker/        # Indian identifier generators
│   │   ├── image_reducer/     # Image compression & resizing
│   │   ├── pdf_merger/        # PDF operations
│   │   ├── json_converter/    # JSON auto-repair
│   │   └── document_scanner/  # OCR & edge detection
│   └── test/          # Unit tests (200+ target)
├── app/               # Flutter UI (Android + iOS + Web)
│   ├── lib/features/  # Feature-based folder structure
│   ├── test/          # Widget & integration tests
│   └── web/           # PWA configuration
└── docs/              # Developer specification
```

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | Flutter 3.29+ | Cross-platform UI |
| **State** | Riverpod 2+ | Reactive state management |
| **Routing** | GoRouter 14+ | Type-safe navigation |
| **Camera** | opencv_dart + ML Kit | Document scanning & OCR |
| **PDF** | pdf + printing packages | PDF generation & operations |
| **Design** | Material 3 + lucide_icons | Modern, consistent UI |
| **Testing** | Patrol + Alchemist | E2E + golden image tests |
| **Web** | CanvasKit renderer | High-performance web |
| **Hosting** | Vercel (free tier) | Auto-deploy from main |

## Indian Data Faker Features

Generate **valid** Indian identifiers for testing:

- **PAN** (Permanent Account Number) with entity type validation
- **GSTIN** (GST Identification Number) with Luhn Mod-36 checksum
- **Aadhaar** with Verhoeff checksum algorithm
- **CIN** (Corporate Identity Number) with industry codes
- **TAN** (Tax Deduction Account Number)
- **IFSC** (Indian Financial System Code) with bank mapping
- **UPI ID** linked to bank IFSC
- **Udyam** (MSME Registration Number)
- **PIN Code** with state consistency

**Templates:** Individual, Company, Proprietorship, Partnership, Trust
**Export:** CSV, JSON, XLSX, Clipboard
**Bulk:** Up to 10,000 records with seed-based reproducibility

> ⚠️ **Disclaimer:** All generated data is synthetic. Do not use for fraud.

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

- 🐛 **Bug Reports:** [Open an issue](https://github.com/btqas/bharattesting-utilities/issues/new?template=bug_report.yml)
- 💡 **Feature Requests:** [Open an issue](https://github.com/btqas/bharattesting-utilities/issues/new?template=feature_request.yml)
- 🆔 **New Identifier:** [Request template](https://github.com/btqas/bharattesting-utilities/issues/new?template=new_identifier_request.yml)

## Development

```bash
# Run quality checks
flutter analyze && dart format --set-exit-if-changed .
cd core && dart test && cd ..
cd app && flutter test && cd ..

# Run E2E tests
cd app && patrol test integration_test/

# Build for production
cd app && flutter build web --release --web-renderer canvaskit
cd app && flutter build apk --release --split-per-abi
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## About

**Built by [BTQA Services Pvt Ltd](https://btqas.com) • Made in Bengaluru, India** 🇮🇳

*Empowering Indian developers with privacy-first, offline tools.*