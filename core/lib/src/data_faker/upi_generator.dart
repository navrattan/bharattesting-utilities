/// UPI (Unified Payments Interface) ID generator for digital payments
///
/// UPI ID format: username@handle
/// - Username: Alphanumeric identifier (3-50 characters)
/// - Handle: Payment service provider domain (e.g., @paytm, @googlepay)
///
/// Common patterns:
/// - name@paytm (name-based)
/// - phone@handle (phone number as username)
/// - customid@handle (custom identifier)
library upi_generator;

import 'dart:math';
import '../data/bank_codes.dart';

/// UPI ID types for different usage patterns
enum UPIIDType {
  /// Name-based UPI ID (john.doe@paytm)
  nameBased('Name-based', 'firstname.lastname or firstnamelastname'),

  /// Phone number-based UPI ID (9876543210@phonepe)
  phoneBased('Phone-based', 'mobile number as username'),

  /// Custom ID (myshop123@paytm)
  customBased('Custom-based', 'custom business or personal identifier'),

  /// Email-like format (john.doe.123@googlepay)
  emailLike('Email-like', 'email-style username with dots and numbers'),

  /// Business/merchant ID (acmecorp@axis)
  businessBased('Business-based', 'business name or identifier');

  const UPIIDType(this.description, this.pattern);

  /// Human-readable description
  final String description;

  /// Pattern description
  final String pattern;
}

/// User types for realistic UPI ID generation
enum UPIUserType {
  /// Individual consumer
  individual('Individual', 'Personal use'),

  /// Small business/merchant
  merchant('Merchant', 'Small business or shop'),

  /// Large business/enterprise
  enterprise('Enterprise', 'Large business or corporation'),

  /// Freelancer/professional
  freelancer('Freelancer', 'Independent professional'),

  /// Student
  student('Student', 'Educational institution student'),

  /// Senior citizen
  senior('Senior Citizen', 'Elderly user');

  const UPIUserType(this.code, this.description);

  /// Short code
  final String code;

  /// Human-readable description
  final String description;
}

/// High-quality UPI ID generator with comprehensive validation
class UPIGenerator {
  const UPIGenerator._();

  /// Valid characters for UPI username
  static const String _validUsernameChars = 'abcdefghijklmnopqrstuvwxyz0123456789.';

  /// Common name patterns for realistic generation
  static const List<String> _commonFirstNames = [
    'amit', 'anita', 'raj', 'priya', 'rahul', 'deepika', 'suresh', 'kavitha',
    'vikram', 'meera', 'arjun', 'shreya', 'anil', 'pooja', 'kiran', 'sunita',
    'rohit', 'neha', 'manoj', 'ritu', 'ajay', 'sonal', 'vinod', 'rekha'
  ];

  static const List<String> _commonLastNames = [
    'sharma', 'patel', 'singh', 'kumar', 'agarwal', 'gupta', 'shah', 'jain',
    'mehta', 'reddy', 'rao', 'iyer', 'nair', 'sethi', 'verma', 'chopra',
    'malhotra', 'khanna', 'bhatia', 'joshi', 'saxena', 'arora', 'kapoor'
  ];

  /// Generate a valid UPI ID
  ///
  /// [type] Type of UPI ID to generate
  /// [userType] Type of user (affects handle selection)
  /// [name] User name (for name-based IDs)
  /// [phone] Phone number (for phone-based IDs)
  /// [bankName] Preferred bank (affects handle selection)
  /// [random] Random number generator
  ///
  /// Returns a valid UPI ID in format username@handle
  ///
  /// Example:
  /// ```dart
  /// final upiId = UPIGenerator.generate(
  ///   type: UPIIDType.nameBased,
  ///   userType: UPIUserType.individual,
  ///   name: 'John Doe',
  ///   random: Random(42),
  /// );
  /// print(upiId); // johndoe@paytm
  /// ```
  static String generate({
    required UPIIDType type,
    UPIUserType? userType,
    String? name,
    String? phone,
    String? bankName,
    required Random random,
  }) {
    final user = userType ?? UPIUserType.individual;

    // Generate username based on type
    final username = _generateUsername(type, name, phone, random);

    // Select handle based on user type and bank preference
    final handle = _selectHandle(user, bankName, random);

    return '$username$handle';
  }

  /// Generate UPI ID from personal details
  ///
  /// [firstName] First name
  /// [lastName] Last name (optional)
  /// [phoneNumber] Phone number (optional)
  /// [preferredApps] List of preferred UPI apps (optional)
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final upiId = UPIGenerator.generateFromPersonalDetails(
  ///   firstName: 'Rajesh',
  ///   lastName: 'Kumar',
  ///   phoneNumber: '9876543210',
  ///   preferredApps: ['@paytm', '@googlepay'],
  ///   random: Random(),
  /// );
  /// ```
  static String generateFromPersonalDetails({
    required String firstName,
    String? lastName,
    String? phoneNumber,
    List<String>? preferredApps,
    required Random random,
  }) {
    // Decide on username format
    String username;
    final usePhone = phoneNumber != null && random.nextBool();

    if (usePhone) {
      // Use phone number as username
      username = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
      if (username.length > 10) {
        username = username.substring(username.length - 10); // Last 10 digits
      }
    } else {
      // Use name-based username
      final cleanFirst = _cleanName(firstName);
      final cleanLast = lastName != null ? _cleanName(lastName) : '';

      if (cleanLast.isNotEmpty && random.nextBool()) {
        // firstname.lastname format
        username = '$cleanFirst.$cleanLast';
      } else {
        // firstnamelastname format
        username = '$cleanFirst$cleanLast';
      }

      // Add numbers for uniqueness sometimes
      if (random.nextDouble() < 0.3) {
        username += random.nextInt(1000).toString();
      }
    }

    // Select handle
    final handle = preferredApps?.isNotEmpty == true
        ? preferredApps![random.nextInt(preferredApps!.length)]
        : BankCodes.getRandomUpiHandle();

    return '$username$handle';
  }

  /// Generate business UPI ID
  ///
  /// [businessName] Name of the business
  /// [businessType] Type of business (shop, restaurant, etc.)
  /// [location] Business location (optional)
  /// [bankName] Preferred bank for business account
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final businessUPI = UPIGenerator.generateBusinessUPI(
  ///   businessName: 'Sharma Electronics',
  ///   businessType: 'shop',
  ///   location: 'mumbai',
  ///   bankName: 'HDFC Bank',
  ///   random: Random(),
  /// );
  /// // Returns: sharmaelectronics@hdfcbank
  /// ```
  static String generateBusinessUPI({
    required String businessName,
    String? businessType,
    String? location,
    String? bankName,
    required Random random,
  }) {
    // Clean business name for username
    String username = businessName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '');

    // Limit length
    if (username.length > 20) {
      username = username.substring(0, 20);
    }

    // Add business type suffix sometimes
    if (businessType != null && random.nextBool()) {
      final cleanType = businessType.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      if (cleanType.length <= 5 && username.length + cleanType.length <= 25) {
        username += cleanType;
      }
    }

    // Add location sometimes for uniqueness
    if (location != null && random.nextDouble() < 0.3) {
      final cleanLocation = location.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      if (cleanLocation.length <= 4 && username.length + cleanLocation.length <= 25) {
        username += cleanLocation;
      }
    }

    // Select business-appropriate handle
    final handle = bankName != null
        ? BankCodes.getRandomUpiHandleForBank(bankName)
        : _selectBusinessHandle(random);

    return '$username$handle';
  }

  /// Validate UPI ID format
  ///
  /// [upiId] The UPI ID to validate
  ///
  /// Returns true if UPI ID format is valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(UPIGenerator.isValid('john.doe@paytm'), isTrue);
  /// expect(UPIGenerator.isValid('9876543210@phonepe'), isTrue);
  /// expect(UPIGenerator.isValid('invalid@unknown'), isFalse); // Unknown handle
  /// expect(UPIGenerator.isValid('user@'), isFalse); // Empty handle
  /// ```
  static bool isValid(String upiId) {
    if (!upiId.contains('@')) return false;

    final parts = upiId.split('@');
    if (parts.length != 2) return false;

    final username = parts[0];
    final handle = '@${parts[1]}';

    // Validate username
    if (!_isValidUsername(username)) return false;

    // Validate handle
    return BankCodes.isValidUpiIdFormat(upiId);
  }

  /// Parse UPI ID components
  ///
  /// [upiId] Valid UPI ID
  /// Returns map with extracted components or null if invalid
  ///
  /// Example:
  /// ```dart
  /// final components = UPIGenerator.parseUPI('john.doe@paytm');
  /// print(components['username']); // john.doe
  /// print(components['handle']); // @paytm
  /// print(components['provider']); // Paytm
  /// ```
  static Map<String, dynamic>? parseUPI(String upiId) {
    if (!isValid(upiId)) return null;

    final parts = upiId.split('@');
    final username = parts[0];
    final handle = '@${parts[1]}';

    // Analyze username type
    final idType = _analyzeUsernameType(username);
    final isPhoneBased = RegExp(r'^\d{6,15}$').hasMatch(username);
    final hasNumbers = username.contains(RegExp(r'\d'));
    final hasDots = username.contains('.');

    // Try to identify provider
    final provider = _getProviderName(handle);

    return {
      'username': username,
      'handle': handle,
      'provider': provider,
      'idType': idType,
      'isPhoneBased': isPhoneBased,
      'hasNumbers': hasNumbers,
      'hasDots': hasDots,
      'length': username.length,
      'isValid': true,
    };
  }

  /// Generate multiple UPI IDs for testing/bulk operations
  ///
  /// [count] Number of UPI IDs to generate
  /// [types] List of ID types to use (optional, all types if null)
  /// [userTypes] List of user types (optional)
  /// [handles] List of specific handles to use (optional)
  /// [random] Random generator
  ///
  /// Returns list of unique valid UPI IDs
  static List<String> generateBulk({
    required int count,
    List<UPIIDType>? types,
    List<UPIUserType>? userTypes,
    List<String>? handles,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 100000) throw ArgumentError('Maximum 100,000 UPI IDs per batch');

    final availableTypes = types ?? UPIIDType.values;
    final availableUserTypes = userTypes ?? UPIUserType.values;
    final generated = <String>{};

    int attempts = 0;
    const maxAttempts = count * 5;

    while (generated.length < count && attempts < maxAttempts) {
      try {
        final type = availableTypes[random.nextInt(availableTypes.length)];
        final userType = availableUserTypes[random.nextInt(availableUserTypes.length)];

        final upiId = generate(
          type: type,
          userType: userType,
          random: random,
        );

        generated.add(upiId);
      } catch (e) {
        // Continue on error
      }
      attempts++;
    }

    return generated.toList();
  }

  /// Check if UPI ID uses specific handle
  ///
  /// [upiId] UPI ID to check
  /// [handle] Handle to check (with or without @)
  static bool usesHandle(String upiId, String handle) {
    if (!isValid(upiId)) return false;

    final normalizedHandle = handle.startsWith('@') ? handle : '@$handle';
    return upiId.endsWith(normalizedHandle);
  }

  /// Get handle from UPI ID
  ///
  /// [upiId] Valid UPI ID
  /// Returns handle (with @) or null if invalid
  static String? getHandle(String upiId) {
    if (!isValid(upiId)) return null;
    final parts = upiId.split('@');
    return '@${parts[1]}';
  }

  /// Get username from UPI ID
  ///
  /// [upiId] Valid UPI ID
  /// Returns username or null if invalid
  static String? getUsername(String upiId) {
    if (!isValid(upiId)) return null;
    return upiId.split('@')[0];
  }

  /// Generate username based on type
  static String _generateUsername(
    UPIIDType type,
    String? name,
    String? phone,
    Random random,
  ) {
    switch (type) {
      case UPIIDType.nameBased:
        return _generateNameBasedUsername(name, random);

      case UPIIDType.phoneBased:
        return _generatePhoneBasedUsername(phone, random);

      case UPIIDType.customBased:
        return _generateCustomUsername(random);

      case UPIIDType.emailLike:
        return _generateEmailLikeUsername(name, random);

      case UPIIDType.businessBased:
        return _generateBusinessUsername(random);
    }
  }

  /// Generate name-based username
  static String _generateNameBasedUsername(String? name, Random random) {
    String firstName, lastName;

    if (name != null && name.isNotEmpty) {
      final parts = name.split(' ');
      firstName = _cleanName(parts[0]);
      lastName = parts.length > 1 ? _cleanName(parts[1]) : '';
    } else {
      // Use random names
      firstName = _commonFirstNames[random.nextInt(_commonFirstNames.length)];
      lastName = _commonLastNames[random.nextInt(_commonLastNames.length)];
    }

    // Various formats
    final formats = [
      '$firstName$lastName',
      '$firstName.$lastName',
      '$firstName${random.nextInt(100)}',
      '${firstName.substring(0, 1)}$lastName',
    ];

    final username = formats[random.nextInt(formats.length)];
    return username.toLowerCase();
  }

  /// Generate phone-based username
  static String _generatePhoneBasedUsername(String? phone, Random random) {
    if (phone != null) {
      final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
      return cleaned.length >= 10 ? cleaned.substring(cleaned.length - 10) : cleaned;
    }

    // Generate random phone number
    return '${6 + random.nextInt(4)}${random.nextInt(1000000000).toString().padLeft(9, '0')}';
  }

  /// Generate custom username
  static String _generateCustomUsername(Random random) {
    final prefixes = ['user', 'my', 'pay', 'quick', 'easy', 'fast', 'smart'];
    final suffixes = ['pay', 'wallet', 'money', 'cash', '123', '786', 'upi'];

    final prefix = prefixes[random.nextInt(prefixes.length)];
    final suffix = suffixes[random.nextInt(suffixes.length)];

    return '$prefix$suffix';
  }

  /// Generate email-like username
  static String _generateEmailLikeUsername(String? name, Random random) {
    final baseUsername = _generateNameBasedUsername(name, random);
    final number = random.nextInt(1000);

    return '$baseUsername.$number';
  }

  /// Generate business username
  static String _generateBusinessUsername(Random random) {
    final businessTypes = ['shop', 'store', 'mart', 'center', 'plaza', 'corner'];
    final businessNames = ['raj', 'new', 'city', 'super', 'royal', 'modern'];

    final namepart = businessNames[random.nextInt(businessNames.length)];
    final typepart = businessTypes[random.nextInt(businessTypes.length)];

    return '$namepart$typepart';
  }

  /// Select appropriate handle based on user type and bank
  static String _selectHandle(UPIUserType userType, String? bankName, Random random) {
    if (bankName != null) {
      return BankCodes.getRandomUpiHandleForBank(bankName);
    }

    // Select based on user type preferences
    List<String> preferredHandles;
    switch (userType) {
      case UPIUserType.individual:
        preferredHandles = ['@paytm', '@googlepay', '@phonepe', '@ybl'];
        break;
      case UPIUserType.merchant:
        preferredHandles = ['@paytm', '@phonepe', '@razorpay', '@bharatpe'];
        break;
      case UPIUserType.enterprise:
        preferredHandles = ['@hdfcbank', '@icici', '@sbi', '@axisbank'];
        break;
      case UPIUserType.student:
        preferredHandles = ['@googlepay', '@phonepe', '@paytm', '@ybl'];
        break;
      case UPIUserType.senior:
        preferredHandles = ['@sbi', '@hdfcbank', '@paytm'];
        break;
      case UPIUserType.freelancer:
        preferredHandles = ['@paytm', '@googlepay', '@phonepe', '@razorpay'];
        break;
    }

    return preferredHandles[random.nextInt(preferredHandles.length)];
  }

  /// Select business-appropriate handle
  static String _selectBusinessHandle(Random random) {
    final businessHandles = ['@paytm', '@phonepe', '@razorpay', '@bharatpe', '@hdfcbank'];
    return businessHandles[random.nextInt(businessHandles.length)];
  }

  /// Clean name for username
  static String _cleanName(String name) {
    return name.toLowerCase()
        .replaceAll(RegExp(r'[^a-z]'), '')
        .substring(0, name.length > 10 ? 10 : name.length);
  }

  /// Validate username format
  static bool _isValidUsername(String username) {
    if (username.length < 3 || username.length > 50) return false;
    if (!RegExp(r'^[a-z0-9.]+$').hasMatch(username)) return false;
    if (username.startsWith('.') || username.endsWith('.')) return false;
    if (username.contains('..')) return false; // Consecutive dots not allowed

    return true;
  }

  /// Analyze username type
  static UPIIDType _analyzeUsernameType(String username) {
    if (RegExp(r'^\d{6,15}$').hasMatch(username)) {
      return UPIIDType.phoneBased;
    }

    if (username.contains('.') && username.contains(RegExp(r'\d'))) {
      return UPIIDType.emailLike;
    }

    if (username.contains('.')) {
      return UPIIDType.nameBased;
    }

    final businessKeywords = ['shop', 'store', 'mart', 'center', 'corp', 'company'];
    for (final keyword in businessKeywords) {
      if (username.contains(keyword)) {
        return UPIIDType.businessBased;
      }
    }

    return UPIIDType.customBased;
  }

  /// Get provider name from handle
  static String? _getProviderName(String handle) {
    switch (handle) {
      case '@paytm':
        return 'Paytm';
      case '@googlepay':
        return 'Google Pay';
      case '@phonepe':
        return 'PhonePe';
      case '@amazonpay':
        return 'Amazon Pay';
      case '@ybl':
        return 'PhonePe (YBL)';
      case '@okaxis':
      case '@axisbank':
        return 'Axis Bank';
      case '@okicici':
      case '@icici':
        return 'ICICI Bank';
      case '@oksbi':
      case '@sbi':
        return 'State Bank of India';
      case '@okhdfc':
      case '@hdfcbank':
        return 'HDFC Bank';
      case '@kotak':
        return 'Kotak Mahindra Bank';
      case '@federal':
        return 'Federal Bank';
      case '@rbl':
        return 'RBL Bank';
      default:
        return null;
    }
  }

  /// Get all supported ID types
  static List<UPIIDType> getSupportedIDTypes() {
    return UPIIDType.values;
  }

  /// Get all supported user types
  static List<UPIUserType> getSupportedUserTypes() {
    return UPIUserType.values;
  }

  /// Get all supported handles
  static List<String> getSupportedHandles() {
    return BankCodes.upiHandles;
  }
}

/// Extension on String for UPI utilities
extension UPIStringExtension on String {
  /// Check if this string is a valid UPI ID
  bool get isValidUPI => UPIGenerator.isValid(this);

  /// Parse UPI components
  Map<String, dynamic>? get upiComponents => UPIGenerator.parseUPI(this);

  /// Get handle from this UPI ID
  String? get upiHandle => UPIGenerator.getHandle(this);

  /// Get username from this UPI ID
  String? get upiUsername => UPIGenerator.getUsername(this);

  /// Check if this UPI ID uses specific handle
  bool usesUPIHandle(String handle) => UPIGenerator.usesHandle(this, handle);

  /// Format UPI ID for display (hide middle part of username)
  String get maskedUPI {
    if (!isValidUPI) return this;

    final parts = split('@');
    final username = parts[0];
    final handle = '@${parts[1]}';

    if (username.length <= 4) return this;

    final start = username.substring(0, 2);
    final end = username.substring(username.length - 2);
    return '$start${'*' * (username.length - 4)}$end$handle';
  }
}