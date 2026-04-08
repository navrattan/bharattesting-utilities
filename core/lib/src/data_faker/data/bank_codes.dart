/// Indian bank codes, IFSC prefixes, and UPI handles
library bank_codes;

import 'dart:math' as math;

/// Bank information for generating IFSC codes and UPI IDs
class BankCodes {
  const BankCodes._();

  /// Major Indian banks with their IFSC prefixes
  /// Format: bank_name -> ifsc_prefix (first 4 characters)
  static const Map<String, String> bankIfscPrefixes = {
    'State Bank of India': 'SBIN',
    'HDFC Bank': 'HDFC',
    'ICICI Bank': 'ICIC',
    'Punjab National Bank': 'PUNB',
    'Bank of Baroda': 'BARB',
    'Canara Bank': 'CNRB',
    'Union Bank of India': 'UBIN',
    'Bank of India': 'BKID',
    'Indian Bank': 'IDIB',
    'Central Bank of India': 'CBIN',
    'Indian Overseas Bank': 'IOBA',
    'UCO Bank': 'UCBA',
    'Bank of Maharashtra': 'MAHB',
    'Punjab and Sind Bank': 'PSIB',
    'Axis Bank': 'UTIB',
    'Kotak Mahindra Bank': 'KKBK',
    'IndusInd Bank': 'INDB',
    'Yes Bank': 'YESB',
    'Federal Bank': 'FDRL',
    'South Indian Bank': 'SIBL',
    'Karnataka Bank': 'KARB',
    'Tamilnad Mercantile Bank': 'TMBL',
    'City Union Bank': 'CIUB',
    'Dhanlaxmi Bank': 'DLXB',
    'RBL Bank': 'RATN',
    'IDFC First Bank': 'IDFB',
    'Bandhan Bank': 'BDBL',
    'Paytm Payments Bank': 'PYTM',
    'Airtel Payments Bank': 'AIRP',
    'India Post Payments Bank': 'IPOS',
  };

  /// UPI handles for different payment apps
  static const List<String> upiHandles = [
    '@paytm',
    '@googlepay',
    '@phonepe',
    '@amazonpay',
    '@ybl', // PhonePe
    '@okaxis', // Google Pay
    '@okicici', // Google Pay
    '@oksbi', // Google Pay
    '@okhdfc', // Google Pay
    '@okhdfcbank', // Google Pay
    '@ibl', // PhonePe
    '@axl', // PhonePe
    '@hdfcbank', // HDFC Bank
    '@icici', // ICICI Bank
    '@sbi', // State Bank of India
    '@axisbank', // Axis Bank
    '@kotak', // Kotak Mahindra Bank
    '@federal', // Federal Bank
    '@rbl', // RBL Bank
    '@indus', // IndusInd Bank
    '@yes', // Yes Bank
    '@allbank', // Allahabad Bank
    '@cnrb', // Canara Bank
    '@pnb', // Punjab National Bank
  ];

  /// Bank names mapped to their common UPI handles
  static const Map<String, List<String>> bankToUpiHandles = {
    'State Bank of India': ['@sbi', '@ybl', '@paytm'],
    'HDFC Bank': ['@hdfcbank', '@okhdfc', '@okhdfcbank', '@paytm'],
    'ICICI Bank': ['@icici', '@okicici', '@paytm'],
    'Axis Bank': ['@axisbank', '@okaxis', '@axl'],
    'Kotak Mahindra Bank': ['@kotak', '@paytm'],
    'Punjab National Bank': ['@pnb', '@paytm'],
    'Canara Bank': ['@cnrb', '@paytm'],
    'Federal Bank': ['@federal', '@paytm'],
    'RBL Bank': ['@rbl', '@paytm'],
    'IndusInd Bank': ['@indus', '@paytm'],
    'Yes Bank': ['@yes', '@paytm'],
    'Bank of Baroda': ['@paytm', '@ybl'],
    'Union Bank of India': ['@paytm', '@ybl'],
    'Bank of India': ['@paytm', '@ybl'],
    'Indian Bank': ['@paytm', '@ybl'],
    'Central Bank of India': ['@paytm', '@ybl'],
  };

  /// Major bank branch locations for IFSC generation
  static const Map<String, List<String>> bankBranchLocations = {
    'SBIN': ['MAIN', 'CORP', 'FORT', 'ANDHERI', 'BANDRA', 'PUNE', 'HYDERABAD', 'CHENNAI', 'KOLKATA', 'AHMEDABAD'],
    'HDFC': ['MAIN', 'CORP', 'POWAI', 'ANDHERI', 'BANDRA', 'PUNE', 'GURGAON', 'NOIDA', 'WHITEFIELD', 'KORAMANGALA'],
    'ICIC': ['MAIN', 'CORP', 'BKC', 'ANDHERI', 'MAHAPE', 'PUNE', 'GURGAON', 'BANGALORE', 'HYDERABAD', 'CHENNAI'],
    'PUNB': ['MAIN', 'CORP', 'KAROL', 'RAJOURI', 'CHANDIGARH', 'LUDHIANA', 'JALANDHAR', 'AMRITSAR'],
    'BARB': ['MAIN', 'CORP', 'FORT', 'ALKAPURI', 'RACE', 'FATEHGANJ', 'SAYAJIGUNJ'],
    'CNRB': ['MAIN', 'CORP', 'JAYANAGAR', 'KORAMANGALA', 'INDIRANAGAR', 'MALLESHWARAM'],
    'UTIB': ['MAIN', 'CORP', 'BKC', 'ANDHERI', 'PUNE', 'GURGAON', 'WHITEFIELD', 'MADHAPUR'],
    'KKBK': ['MAIN', 'CORP', 'NARIMAN', 'BANDRA', 'PUNE', 'GURGAON', 'KORAMANGALA'],
  };

  /// Get random bank name
  static String getRandomBankName() {
    final banks = bankIfscPrefixes.keys.toList()..shuffle();
    return banks.first;
  }

  /// Get IFSC prefix for a bank
  static String? getIfscPrefix(String bankName) {
    return bankIfscPrefixes[bankName];
  }

  /// Get bank name from IFSC prefix
  static String? getBankFromIfsc(String ifscPrefix) {
    for (final entry in bankIfscPrefixes.entries) {
      if (entry.value == ifscPrefix.toUpperCase()) {
        return entry.key;
      }
    }
    return null;
  }

  /// Generate random IFSC code for a bank
  static String generateIfscCode(String bankName) {
    final prefix = getIfscPrefix(bankName);
    if (prefix == null) return 'SBIN0000001';

    // Generate 7-character branch code
    final branchCode = _generateBranchCode(prefix);
    return '$prefix$branchCode';
  }

  /// Generate random branch code (7 characters)
  static String _generateBranchCode(String bankPrefix) {
    final locations = bankBranchLocations[bankPrefix] ?? ['MAIN'];
    final location = (locations.toList()..shuffle()).first;

    // Pad or truncate to fit 7 characters with numbers
    if (location.length >= 7) {
      return location.substring(0, 7);
    } else {
      final padding = 7 - location.length;
      final numbers = List.generate(padding, (i) => (i % 10).toString()).join();
      return location + numbers;
    }
  }

  /// Get UPI handles for a bank
  static List<String> getUpiHandles(String bankName) {
    return bankToUpiHandles[bankName] ?? ['@paytm'];
  }

  /// Get random UPI handle
  static String getRandomUpiHandle() {
    final handles = upiHandles.toList()..shuffle();
    return handles.first;
  }

  /// Get random UPI handle for a specific bank
  static String getRandomUpiHandleForBank(String bankName) {
    final bankHandles = getUpiHandles(bankName);
    bankHandles.toList()..shuffle();
    return bankHandles.first;
  }

  /// Generate UPI ID
  static String generateUpiId({
    required String name,
    String? phoneNumber,
    String? bankName,
  }) {
    // Clean name for UPI ID
    final baseCleanName = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
    final cleanName = baseCleanName.substring(0, math.min(15, baseCleanName.length));

    String handle;
    if (bankName != null) {
      handle = getRandomUpiHandleForBank(bankName);
    } else {
      handle = getRandomUpiHandle();
    }

    // Add phone number suffix if provided
    if (phoneNumber != null && phoneNumber.length >= 4) {
      final phoneSuffix = phoneNumber.substring(phoneNumber.length - 4);
      return '$cleanName$phoneSuffix$handle';
    }

    return '$cleanName$handle';
  }

  /// Validate IFSC code format
  static bool isValidIfscFormat(String ifsc) {
    if (ifsc.length != 11) return false;
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) return false;

    final prefix = ifsc.substring(0, 4);
    return bankIfscPrefixes.values.contains(prefix);
  }

  /// Validate UPI ID format
  static bool isValidUpiIdFormat(String upiId) {
    // Basic UPI ID format: username@handle
    if (!upiId.contains('@')) return false;

    final parts = upiId.split('@');
    if (parts.length != 2) return false;

    final handle = '@${parts[1]}';
    return upiHandles.contains(handle);
  }

  /// Get all valid bank prefixes
  static List<String> getAllBankPrefixes() {
    return bankIfscPrefixes.values.toList();
  }
}