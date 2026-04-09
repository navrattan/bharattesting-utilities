import 'package:flutter/services.dart';
import '../models/tool_branding.dart';

class BrandingService {
  static void updateBrowserTitle(String path) {
    final intent = ToolIntent.fromPath(path);
    if (intent == ToolIntent.none) {
      SystemChrome.setApplicationSwitcherDescription(
        const ApplicationSwitcherDescription(label: 'BharatTesting Utilities'),
      );
      return;
    }

    final branding = ToolBranding.all[intent];
    if (branding != null) {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(label: branding.seoTitle),
      );
    }
  }
}
