/// IFSC (Indian Financial System Code) generator for bank branches
///
/// IFSC format: AAAA0BBBBBB (11 characters)
/// - First 4 characters: Bank code (A-Z)
/// - 5th character: Always '0' (reserved for future use)
/// - Last 6 characters: Branch code (A-Z, 0-9)
library ifsc_generator;

import 'dart:math';
import '../data/bank_codes.dart';
import '../data/state_codes.dart';

/// Branch types for realistic IFSC generation
enum IFSCBranchType {
  /// Main/Head office branch
  main('Main Branch', ['MAIN', 'HEAD', 'HO', 'CENTRAL']),

  /// Corporate banking branch
  corporate('Corporate Branch', ['CORP', 'CMPNY', 'BUSNS', 'ENTRP']),

  /// Retail banking branch
  retail('Retail Branch', ['RETAIL', 'RETAL', 'CUST', 'GENRL']),

  /// ATM or cash deposit machine location
  atm('ATM/CDM', ['ATM', 'CDM', 'KIOSK', 'CASH']),

  /// NRI (Non-Resident Indian) services branch
  nri('NRI Branch', ['NRI', 'FRGN', 'INTL', 'OVERS']),

  /// Agricultural/rural branch
  rural('Rural Branch', ['RURAL', 'AGRI', 'FARM', 'GRAMA']),

  /// Priority sector/government branch
  priority('Priority Sector', ['PRITY', 'GOVT', 'PUBLI', 'SCIAL']),

  /// Digital/online banking branch
  digital('Digital Branch', ['DIGTL', 'ONLIN', 'CYBER', 'EBANK']),

  /// SME (Small & Medium Enterprise) branch
  sme('SME Branch', ['SME', 'MICRO', 'SMALL', 'MEDIM']),

  /// Wealth management/private banking
  wealth('Wealth Management', ['WELTH', 'PRIVT', 'HNI', 'PRMUM']);

  const IFSCBranchType(this.description, this.codes);

  /// Human-readable description
  final String description;

  /// Common codes used for this branch type
  final List<String> codes;
}

/// High-quality IFSC generator with comprehensive validation
class IFSCGenerator {
  const IFSCGenerator._();

  /// Generate a valid IFSC code
  ///
  /// [bankName] Name of the bank (must be supported bank)
  /// [branchType] Type of branch (optional, random if null)
  /// [location] Branch location/city (optional)
  /// [random] Random number generator
  ///
  /// Returns an 11-character IFSC code
  ///
  /// Example:
  /// ```dart
  /// final ifsc = IFSCGenerator.generate(
  ///   bankName: 'State Bank of India',
  ///   branchType: IFSCBranchType.main,
  ///   location: 'Mumbai',
  ///   random: Random(42),
  /// );
  /// print(ifsc); // SBIN0001234
  /// ```
  static String generate({
    required String bankName,
    IFSCBranchType? branchType,
    String? location,
    required Random random,
  }) {
    // Get bank prefix
    final bankPrefix = BankCodes.getIfscPrefix(bankName);
    if (bankPrefix == null) {
      throw ArgumentError('Unsupported bank: $bankName');
    }

    // Generate branch code based on type and location
    final branchCode = _generateBranchCode(
      branchType ?? _getRandomBranchType(random),
      location,
      random,
    );

    return '$bankPrefix${'0'}$branchCode';
  }

  /// Generate IFSC from bank prefix directly
  ///
  /// [bankPrefix] 4-character bank prefix (e.g., 'SBIN')
  /// [branchType] Type of branch
  /// [location] Branch location
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final ifsc = IFSCGenerator.generateFromPrefix(
  ///   bankPrefix: 'HDFC',
  ///   branchType: IFSCBranchType.corporate,
  ///   random: Random(),
  /// );
  /// ```
  static String generateFromPrefix({
    required String bankPrefix,
    IFSCBranchType? branchType,
    String? location,
    required Random random,
  }) {
    if (bankPrefix.length != 4 || !RegExp(r'^[A-Z]{4}$').hasMatch(bankPrefix)) {
      throw ArgumentError('Bank prefix must be 4 uppercase letters');
    }

    final branchCode = _generateBranchCode(
      branchType ?? _getRandomBranchType(random),
      location,
      random,
    );

    return '$bankPrefix${'0'}$branchCode';
  }

  /// Generate IFSC for specific location
  ///
  /// [location] City or area name
  /// [bankName] Bank name (optional, random if null)
  /// [branchType] Branch type (optional)
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final ifsc = IFSCGenerator.generateForLocation(
  ///   location: 'Bangalore',
  ///   bankName: 'ICICI Bank',
  ///   random: Random(),
  /// );
  /// ```
  static String generateForLocation({
    required String location,
    String? bankName,
    IFSCBranchType? branchType,
    required Random random,
  }) {
    final bank = bankName ?? BankCodes.getRandomBankName();
    return generate(
      bankName: bank,
      branchType: branchType,
      location: location,
      random: random,
    );
  }

  /// Validate IFSC format and bank prefix
  ///
  /// [ifsc] The IFSC code to validate
  ///
  /// Returns true if IFSC format is valid and bank exists, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(IFSCGenerator.isValid('SBIN0001234'), isTrue);
  /// expect(IFSCGenerator.isValid('SBIN001234'), isFalse); // Wrong length
  /// expect(IFSCGenerator.isValid('XXXX0001234'), isFalse); // Invalid bank
  /// ```
  static bool isValid(String ifsc) {
    if (ifsc.length != 11) return false;

    // Check format: AAAA0BBBBBB
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) return false;

    // Validate bank prefix
    final bankPrefix = ifsc.substring(0, 4);
    return BankCodes.getAllBankPrefixes().contains(bankPrefix);
  }

  /// Parse IFSC components
  ///
  /// [ifsc] Valid IFSC code
  /// Returns map with extracted components or null if invalid
  ///
  /// Example:
  /// ```dart
  /// final components = IFSCGenerator.parseIFSC('SBIN0001234');
  /// print(components['bankPrefix']); // SBIN
  /// print(components['bankName']); // State Bank of India
  /// print(components['branchCode']); // 001234
  /// ```
  static Map<String, dynamic>? parseIFSC(String ifsc) {
    if (!isValid(ifsc)) return null;

    final bankPrefix = ifsc.substring(0, 4);
    final branchCode = ifsc.substring(5, 11);
    final bankName = BankCodes.getBankFromIfsc(bankPrefix);

    // Try to identify branch type from code
    final probableBranchType = _identifyBranchType(branchCode);

    return {
      'bankPrefix': bankPrefix,
      'bankName': bankName,
      'branchCode': branchCode,
      'probableBranchType': probableBranchType,
      'isValid': true,
      'format': 'AAAA0BBBBBB',
    };
  }

  /// Generate multiple IFSC codes for testing/bulk operations
  ///
  /// [count] Number of IFSC codes to generate
  /// [bankNames] List of bank names to use (optional, all banks if null)
  /// [locations] List of locations (optional)
  /// [random] Random generator
  ///
  /// Returns list of unique valid IFSC codes
  static List<String> generateBulk({
    required int count,
    List<String>? bankNames,
    List<String>? locations,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 100000) throw ArgumentError('Maximum 100,000 IFSC codes per batch');

    final availableBanks = bankNames ?? BankCodes.bankIfscPrefixes.keys.toList();
    final generated = <String>{};
    int attempts = 0;
    const maxAttempts = count * 5;

    while (generated.length < count && attempts < maxAttempts) {
      try {
        final bank = availableBanks[random.nextInt(availableBanks.length)];
        final location = locations?.isNotEmpty == true
            ? locations![random.nextInt(locations!.length)]
            : null;

        final ifsc = generate(
          bankName: bank,
          location: location,
          random: random,
        );

        generated.add(ifsc);
      } catch (e) {
        // Skip invalid combinations and continue
      }
      attempts++;
    }

    return generated.toList();
  }

  /// Get bank name from IFSC
  ///
  /// [ifsc] Valid IFSC code
  /// Returns bank name or null if invalid/unknown
  static String? getBankName(String ifsc) {
    if (!isValid(ifsc)) return null;
    final prefix = ifsc.substring(0, 4);
    return BankCodes.getBankFromIfsc(prefix);
  }

  /// Check if IFSC belongs to specific bank
  ///
  /// [ifsc] IFSC code to check
  /// [bankName] Bank name to validate against
  static bool isFromBank(String ifsc, String bankName) {
    final actualBank = getBankName(ifsc);
    return actualBank?.toLowerCase() == bankName.toLowerCase();
  }

  /// Generate IFSC codes for bank's common branches
  ///
  /// [bankName] Name of the bank
  /// [city] City where branches are located
  /// [count] Number of branch codes to generate
  /// [random] Random generator
  ///
  /// Returns list of IFSC codes for different branch types
  static List<String> generateBankBranches({
    required String bankName,
    required String city,
    required int count,
    required Random random,
  }) {
    final branchTypes = IFSCBranchType.values;
    final generated = <String>[];

    for (int i = 0; i < count && i < branchTypes.length; i++) {
      try {
        final ifsc = generate(
          bankName: bankName,
          branchType: branchTypes[i],
          location: city,
          random: random,
        );
        generated.add(ifsc);
      } catch (e) {
        // Skip if bank doesn't exist
        break;
      }
    }

    return generated;
  }

  /// Generate IFSC with specific pattern
  ///
  /// [bankPrefix] Bank prefix (4 letters)
  /// [pattern] Branch pattern like '00****' where * = random
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final ifsc = IFSCGenerator.generateWithPattern(
  ///   bankPrefix: 'SBIN',
  ///   pattern: '001***',
  ///   random: Random(),
  /// );
  /// // Returns something like: SBIN0001234
  /// ```
  static String generateWithPattern({
    required String bankPrefix,
    required String pattern,
    required Random random,
  }) {
    if (bankPrefix.length != 4) {
      throw ArgumentError('Bank prefix must be 4 characters');
    }
    if (pattern.length != 6) {
      throw ArgumentError('Pattern must be 6 characters for branch code');
    }

    String branchCode = '';
    for (int i = 0; i < 6; i++) {
      if (pattern[i] == '*') {
        // Random alphanumeric
        if (random.nextBool()) {
          branchCode += random.nextInt(10).toString();
        } else {
          branchCode += String.fromCharCode(65 + random.nextInt(26)); // A-Z
        }
      } else {
        branchCode += pattern[i];
      }
    }

    final ifsc = '$bankPrefix${'0'}$branchCode';

    if (!isValid(ifsc)) {
      throw ArgumentError('Generated IFSC is not valid: $ifsc');
    }

    return ifsc;
  }

  /// Get all IFSC codes for a bank (simulated common branches)
  ///
  /// [bankName] Name of the bank
  /// [maxBranches] Maximum number of branches to generate
  /// [random] Random generator
  static List<String> getBankIFSCs({
    required String bankName,
    int maxBranches = 20,
    required Random random,
  }) {
    final prefix = BankCodes.getIfscPrefix(bankName);
    if (prefix == null) return [];

    final branches = <String>[];
    final usedCodes = <String>{};

    // Generate main branch (always exists)
    branches.add('${prefix}0${_formatBranchNumber(1)}');
    usedCodes.add(_formatBranchNumber(1));

    // Generate other branches
    for (int i = 2; i <= maxBranches; i++) {
      String branchCode;
      int attempts = 0;

      do {
        branchCode = _formatBranchNumber(random.nextInt(999999) + 1);
        attempts++;
      } while (usedCodes.contains(branchCode) && attempts < 100);

      if (!usedCodes.contains(branchCode)) {
        branches.add('$prefix${'0'}$branchCode');
        usedCodes.add(branchCode);
      }
    }

    return branches;
  }

  /// Generate branch code based on type and location
  static String _generateBranchCode(
    IFSCBranchType branchType,
    String? location,
    Random random,
  ) {
    String baseCode;

    // Start with branch type code
    final typeCodes = branchType.codes;
    baseCode = typeCodes[random.nextInt(typeCodes.length)];

    // Pad or truncate to 6 characters
    if (baseCode.length >= 6) {
      baseCode = baseCode.substring(0, 6);
    } else {
      // Pad with numbers
      final needed = 6 - baseCode.length;
      final padding = List.generate(needed, (_) => random.nextInt(10)).join();
      baseCode = baseCode + padding;
    }

    return baseCode.toUpperCase();
  }

  /// Identify branch type from branch code
  static IFSCBranchType? _identifyBranchType(String branchCode) {
    final upperCode = branchCode.toUpperCase();

    for (final branchType in IFSCBranchType.values) {
      for (final code in branchType.codes) {
        if (upperCode.startsWith(code)) {
          return branchType;
        }
      }
    }

    return null; // Cannot identify
  }

  /// Get random branch type with weighted distribution
  static IFSCBranchType _getRandomBranchType(Random random) {
    // Weighted distribution favoring common branch types
    final weightedTypes = [
      ...List.filled(4, IFSCBranchType.main), // 40%
      ...List.filled(3, IFSCBranchType.retail), // 30%
      IFSCBranchType.corporate, // 10%
      IFSCBranchType.atm, // 10%
      IFSCBranchType.digital, // 10%
    ];

    return weightedTypes[random.nextInt(weightedTypes.length)];
  }

  /// Format branch number as 6-digit string
  static String _formatBranchNumber(int number) {
    return number.toString().padLeft(6, '0');
  }

  /// Get all supported branch types
  static List<IFSCBranchType> getSupportedBranchTypes() {
    return IFSCBranchType.values;
  }

  /// Get all supported banks
  static List<String> getSupportedBanks() {
    return BankCodes.bankIfscPrefixes.keys.toList();
  }
}

/// Extension on String for IFSC utilities
extension IFSCStringExtension on String {
  /// Check if this string is a valid IFSC code
  bool get isValidIFSC => IFSCGenerator.isValid(this);

  /// Parse IFSC components
  Map<String, dynamic>? get ifscComponents => IFSCGenerator.parseIFSC(this);

  /// Get bank name from this IFSC
  String? get bankName => IFSCGenerator.getBankName(this);

  /// Format IFSC with spaces for display
  String get formattedIFSC {
    if (length != 11) return this;
    return '${substring(0, 4)} 0 ${substring(5)}';
  }

  /// Check if IFSC is from specific bank
  bool isIFSCFromBank(String bankName) => IFSCGenerator.isFromBank(this, bankName);

  /// Get bank prefix from IFSC
  String? get bankPrefix {
    if (length >= 4) return substring(0, 4);
    return null;
  }

  /// Get branch code from IFSC
  String? get branchCode {
    if (length == 11) return substring(5, 11);
    return null;
  }
}