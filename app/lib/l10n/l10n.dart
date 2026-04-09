import 'package:flutter/widgets.dart';
import '../generated/l10n/app_localizations.dart';

export '../generated/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  /// Robust getter for localizations with safety check
  AppLocalizations get l10n {
    final localized = AppLocalizations.of(this);
    if (localized == null) {
      // During initialization or if something is wrong with the context,
      // we might get null. Providing a fallback is safer than crashing (!).
      // This is a common cause for "blank white screens" in localized apps.
      throw FlutterError(
        'AppLocalizations requested with a context that does not contain it.'
      );
    }
    return localized;
  }
}
