# BharatTesting Utilities - Deployment Guide

This guide covers deploying BharatTesting Utilities to production across all platforms: Web, Android, and iOS.

## 🌐 Web Deployment (Vercel)

### Prerequisites
- Flutter SDK 3.29+ with web support enabled
- Vercel CLI: `npm install -g vercel`
- Git repository connected to GitHub

### Quick Deploy
```bash
# Run the automated deployment script
./scripts/deploy-web.sh

# Or manual steps:
cd app
flutter build web --release
cd ..
vercel deploy --prod
```

### Domain Configuration
1. **Custom Domain**: bharattesting.com
2. **DNS Settings**:
   ```
   CNAME www -> cname.vercel-dns.com
   A     @   -> 76.76.19.19
   ```
3. **SSL**: Automatic via Vercel

### Verification
```bash
# Verify web configuration
./scripts/verify-web-config.sh

# Test locally
cd app/build/web
python3 -m http.server 8000
open http://localhost:8000
```

---

## 📱 Android Deployment (Google Play Store)

### Prerequisites
- Flutter SDK 3.29+ with Android toolchain
- Android SDK with API 24+ (Android 7.0)
- Google Play Console account ($25 registration)

### Build Release
```bash
# Run the automated build script
./scripts/build-android-release.sh

# Or manual steps:
cd app
flutter build appbundle --release  # For Play Store
flutter build apk --release --split-per-abi  # For direct distribution
```

### Google Play Console
1. **Upload AAB**: `app/build/app/outputs/bundle/release/app-release.aab`
2. **App ID**: `com.btqaservices.bharattesting`
3. **Version**: 1.0.0 (1)

### Testing
```bash
# Verify Android configuration
./scripts/verify-android-config.sh

# Install APK locally
adb install app/build/app/outputs/flutter-apk/app-release.apk
```

---

## 🍎 iOS Deployment (App Store)

### Prerequisites
- macOS with Xcode 14+
- Apple Developer Program membership ($99/year)
- CocoaPods: `sudo gem install cocoapods`

### Build Release
```bash
# Run the automated build script
./scripts/build-ios-release.sh

# Or manual steps:
cd app
flutter build ios --release
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release archive
```

### App Store Connect
1. **Bundle ID**: `com.btqaservices.bharattesting`
2. **Archive**: Created via Xcode
3. **TestFlight**: Beta testing platform

### Certificates Setup
1. **Development Team**: Configure in Xcode
2. **Provisioning Profiles**: Auto-generate or manual
3. **App Store Certificate**: Download from Apple Developer

### Testing
```bash
# Verify iOS configuration
./scripts/verify-ios-config.sh

# iOS Simulator
flutter run --release -d "iPhone 15 Pro"
```

---

## 🔄 CI/CD Pipeline (GitHub Actions)

### Automated Builds
```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['v*']
  
jobs:
  web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: ./scripts/deploy-web.sh
  
  android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: ./scripts/build-android-release.sh
  
  ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: ./scripts/build-ios-release.sh
```

---

## 📊 Performance Monitoring

### Web Analytics
- **Vercel Analytics**: Enable in Vercel dashboard
- **Core Web Vitals**: Monitor loading performance
- **Error Tracking**: Vercel Functions for logging

### Mobile Analytics
- **No tracking**: Privacy-first approach
- **Crash Reports**: Manual user reporting only
- **Performance**: Device-local monitoring

---

## 🧪 Testing Strategy

### Pre-Deployment Testing
```bash
# Run all tests
flutter test                    # Unit tests
flutter test integration_test   # E2E tests
./scripts/verify-*-config.sh    # Configuration checks
```

### Production Testing Checklist
- [ ] All 5 tools functional
- [ ] Responsive design (mobile/tablet/desktop)
- [ ] PWA installation works
- [ ] Deep links functional
- [ ] Camera permissions
- [ ] File sharing works
- [ ] Offline functionality
- [ ] Performance targets met

---

## 🔐 Security Considerations

### Web Security
- HTTPS enforced (Vercel automatic)
- CSP headers configured
- No external requests
- Client-side only processing

### Mobile Security
- ProGuard obfuscation (Android)
- Certificate pinning not needed (no network)
- Local storage encryption
- Permission minimal principle

---

## 📦 Release Management

### Version Numbering
- **Format**: MAJOR.MINOR.PATCH (BUILD)
- **Web**: Auto-deploy from main branch
- **Mobile**: Manual release via stores

### Release Process
1. **Development**: Feature branches → main
2. **Testing**: Automated CI/CD pipeline
3. **Staging**: Preview deployments
4. **Production**: Tagged releases

### Rollback Strategy
- **Web**: Instant via Vercel dashboard
- **Mobile**: Store update (24-48 hours)

---

## 📞 Support

### Documentation
- **Setup**: README.md
- **Architecture**: docs/ARCHITECTURE.md
- **Contributing**: CONTRIBUTING.md

### Issue Tracking
- **GitHub Issues**: Bug reports and features
- **Discussions**: Community support
- **Security**: security@btqaservices.com

---

## 🎯 Production Checklist

### Pre-Launch
- [ ] Domain configured (bharattesting.com)
- [ ] SSL certificates valid
- [ ] All platforms building successfully
- [ ] Performance benchmarks met
- [ ] Security scan passed
- [ ] Privacy policy updated
- [ ] Terms of service current

### Post-Launch
- [ ] Monitor uptime and performance
- [ ] Track user feedback
- [ ] Update documentation
- [ ] Plan next iteration

---

**🚀 Ready to deploy? Start with the web deployment and then proceed to mobile stores!**

For questions: GitHub Issues or contact@btqaservices.com
