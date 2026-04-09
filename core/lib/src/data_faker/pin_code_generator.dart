/// PIN (Postal Index Number) code generator for Indian postal addresses
///
/// PIN format: 6 digits (NNNNNN)
/// - First digit: Geographic region (1-9)
/// - Second digit: Sub-region within geographic region
/// - Third digit: Sorting district
/// - Last 3 digits: Post office identifier
///
/// PIN codes are assigned by India Post for efficient mail sorting and delivery.
library pin_code_generator;

import 'dart:math';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';

/// Geographic regions for PIN code first digit
enum PINRegion {
  /// Northern region (Delhi, Punjab, Haryana, etc.)
  northern(1, 'Northern', ['Delhi', 'Punjab', 'Haryana', 'Himachal Pradesh', 'Jammu and Kashmir', 'Ladakh']),

  /// Western region (Maharashtra, Gujarat, Rajasthan, etc.)
  western(2, 'Western', ['Maharashtra', 'Gujarat', 'Rajasthan', 'Goa']),

  /// Southern region (Tamil Nadu, Karnataka, Andhra Pradesh, etc.)
  southern(3, 'Southern', ['Tamil Nadu', 'Karnataka', 'Andhra Pradesh', 'Telangana', 'Kerala']),

  /// Eastern region (West Bengal, Bihar, Jharkhand, etc.)
  eastern(4, 'Eastern', ['West Bengal', 'Bihar', 'Jharkhand', 'Odisha']),

  /// Central region (Uttar Pradesh, Madhya Pradesh, etc.)
  central(5, 'Central', ['Uttar Pradesh', 'Madhya Pradesh', 'Chhattisgarh']),

  /// Northeastern region (Assam, Meghalaya, etc.)
  northeastern(6, 'Northeastern', ['Assam', 'Meghalaya', 'Mizoram', 'Nagaland', 'Manipur', 'Tripura', 'Arunachal Pradesh', 'Sikkim']),

  /// Army postal service
  armyPostal(9, 'Army Postal Service', ['Military establishments', 'Defence locations']);

  const PINRegion(this.code, this.name, this.states);

  /// Region code (first digit of PIN)
  final int code;

  /// Region name
  final String name;

  /// States/UTs in this region
  final List<String> states;
}

/// Area types for realistic PIN generation
enum PINAreaType {
  /// Major metropolitan city
  metro('Metro City', 'Major metropolitan areas'),

  /// Urban areas and cities
  urban('Urban', 'Cities and urban areas'),

  /// Sub-urban areas
  suburban('Sub-urban', 'Suburban residential areas'),

  /// Rural areas and villages
  rural('Rural', 'Villages and rural areas'),

  /// Industrial areas
  industrial('Industrial', 'Industrial zones and complexes'),

  /// Commercial areas
  commercial('Commercial', 'Business and commercial districts'),

  /// Residential areas
  residential('Residential', 'Housing societies and residential complexes'),

  /// Educational institutions
  educational('Educational', 'Universities and educational institutions'),

  /// Government offices
  government('Government', 'Government offices and secretariats'),

  /// Airport and railway
  transport('Transport', 'Airports, railway stations, transport hubs');

  const PINAreaType(this.code, this.description);

  /// Short code
  final String code;

  /// Description
  final String description;
}

/// High-quality PIN code generator with geographical accuracy
class PINCodeGenerator {
  const PINCodeGenerator._();

  /// Generate a valid PIN code
  ///
  /// [stateName] Name of the state (determines region and range)
  /// [areaType] Type of area (affects PIN pattern)
  /// [cityName] Specific city (optional, affects sub-region)
  /// [random] Random number generator
  ///
  /// Returns a 6-digit PIN code
  ///
  /// Example:
  /// ```dart
  /// final pin = PINCodeGenerator.generate(
  ///   stateName: 'Karnataka',
  ///   areaType: PINAreaType.metro,
  ///   cityName: 'Bangalore',
  ///   random: Random(42),
  /// );
  /// print(pin); // 560001
  /// ```
  static String generate({
    required String stateName,
    PINAreaType? areaType,
    String? cityName,
    required Random random,
  }) {
    // Get region for the state
    final region = _getRegionForState(stateName);
    if (region == null) {
      throw ArgumentError('Unsupported state: $stateName');
    }

    // Get PIN range for the state
    final pinRange = StateCodes.statePinRanges[stateName];
    if (pinRange == null) {
      throw ArgumentError('No PIN range available for state: $stateName');
    }

    // Generate PIN within the valid range for the state
    final startPin = pinRange[0];
    final endPin = pinRange[1];

    // Adjust range based on area type and city
    final adjustedRange = _adjustRangeForAreaAndCity(
      startPin,
      endPin,
      areaType,
      cityName,
      stateName,
      random,
    );

    final pinCode = adjustedRange[0] + random.nextInt(adjustedRange[1] - adjustedRange[0] + 1);

    return pinCode.toString();
  }

  /// Generate PIN from address details
  ///
  /// [address] Full address or area description
  /// [stateName] State name
  /// [cityName] City name (optional)
  /// [landmark] Nearby landmark (optional, affects area type detection)
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final pin = PINCodeGenerator.generateFromAddress(
  ///   address: 'Tech Park, Electronic City',
  ///   stateName: 'Karnataka',
  ///   cityName: 'Bangalore',
  ///   landmark: 'Infosys Campus',
  ///   random: Random(),
  /// );
  /// ```
  static String generateFromAddress({
    required String address,
    required String stateName,
    String? cityName,
    String? landmark,
    required Random random,
  }) {
    // Analyze address to determine area type
    final areaType = _analyzeAreaType(address, landmark);

    return generate(
      stateName: stateName,
      areaType: areaType,
      cityName: cityName,
      random: random,
    );
  }

  /// Generate a PIN code for a specific state
  static String generateForState(String stateName, Random random) {
    return generate(stateName: stateName, random: random);
  }

  /// Get state name from PIN code
  static String? getStateFromPin(String pinCode) {
    final pin = int.tryParse(pinCode);
    if (pin == null) return null;
    return StateCodes.getStateFromPin(pin);
  }

  /// Get city name from PIN code (simplified)
  static String? getCityFromPin(String pinCode) {
    // Return a generic city name based on PIN sub-region or major cities
    final pin = int.tryParse(pinCode);
    if (pin == null) return null;

    for (final stateEntry in StateCodes.majorCities.entries) {
      for (final cityEntry in stateEntry.value.entries) {
        final range = cityEntry.value;
        if (pin >= range[0] && pin <= range[1]) {
          return cityEntry.key;
        }
      }
    }
    return 'Main City';
  }

  /// Generate PIN for specific city
  ///
  /// [cityName] Name of the city
  /// [stateName] State where city is located
  /// [areaType] Type of area within city
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final pin = PINCodeGenerator.generateForCity(
  ///   cityName: 'Mumbai',
  ///   stateName: 'Maharashtra',
  ///   areaType: PINAreaType.commercial,
  ///   random: Random(),
  /// );
  /// ```
  static String generateForCity({
    required String cityName,
    required String stateName,
    PINAreaType? areaType,
    required Random random,
  }) {
    return generate(
      stateName: stateName,
      areaType: areaType,
      cityName: cityName,
      random: random,
    );
  }

  /// Validate PIN code format and range
  ///
  /// [pinCode] The PIN code to validate
  /// [stateName] Optional state to validate against specific range
  ///
  /// Returns true if PIN format and range is valid, false otherwise
  ///
  /// Example:
  /// ```dart
  /// expect(PINCodeGenerator.isValid('560001'), isTrue);
  /// expect(PINCodeGenerator.isValid('560001', 'Karnataka'), isTrue);
  /// expect(PINCodeGenerator.isValid('123456'), isFalse); // Invalid range
  /// expect(PINCodeGenerator.isValid('12345'), isFalse); // Wrong length
  /// ```
  static bool isValid(String pinCode, [String? stateName]) {
    // Basic format validation
    if (pinCode.length != 6) return false;
    if (!RegExp(r'^\d{6}$').hasMatch(pinCode)) return false;

    final pin = int.tryParse(pinCode);
    if (pin == null) return false;

    // General PIN range validation (100001 to 855117)
    if (pin < 100001 || pin > 855117) return false;

    // Validate first digit (geographic region)
    final firstDigit = int.parse(pinCode[0]);
    if (firstDigit == 0 || firstDigit == 8) return false; // 0 and 8 not assigned

    // State-specific validation
    if (stateName != null) {
      final stateRange = StateCodes.statePinRanges[stateName];
      if (stateRange != null) {
        return pin >= stateRange[0] && pin <= stateRange[1];
      }
    }

    return true;
  }

  /// Get state name from PIN code
  ///
  /// [pinCode] Valid PIN code
  /// Returns state name or null if not found
  ///
  /// Example:
  /// ```dart
  /// final state = PINCodeGenerator.getStateName('560001');
  /// print(state); // Karnataka
  /// ```
  static String? getStateName(String pinCode) {
    if (!isValid(pinCode)) return null;

    final pin = int.parse(pinCode);
    return StateCodes.getStateFromPin(pin);
  }

  /// Get region from PIN code
  ///
  /// [pinCode] Valid PIN code
  /// Returns geographic region or null if invalid
  static PINRegion? getRegion(String pinCode) {
    if (!isValid(pinCode)) return null;

    final firstDigit = int.parse(pinCode[0]);
    return PINRegion.values.where((region) => region.code == firstDigit).firstOrNull;
  }

  /// Parse PIN code components
  ///
  /// [pinCode] Valid PIN code
  /// Returns map with extracted components or null if invalid
  ///
  /// Example:
  /// ```dart
  /// final components = PINCodeGenerator.parsePIN('560001');
  /// print(components['region']); // Southern
  /// print(components['stateName']); // Karnataka
  /// print(components['areaCode']); // 001 (main post office)
  /// ```
  static Map<String, dynamic>? parsePIN(String pinCode) {
    if (!isValid(pinCode)) return null;

    final region = getRegion(pinCode);
    final stateName = getStateName(pinCode);
    final subRegion = pinCode[1];
    final sortingDistrict = pinCode[2];
    final postOfficeCode = pinCode.substring(3);

    // Analyze area type from PIN pattern
    final probableAreaType = _analyzeAreaTypeFromPIN(pinCode);

    return {
      'pinCode': pinCode,
      'region': region?.name,
      'regionCode': region?.code,
      'stateName': stateName,
      'subRegion': subRegion,
      'sortingDistrict': sortingDistrict,
      'postOfficeCode': postOfficeCode,
      'probableAreaType': probableAreaType,
      'isValid': true,
    };
  }

  /// Generate multiple PIN codes for testing/bulk operations
  ///
  /// [count] Number of PIN codes to generate
  /// [states] List of states to use (optional, all states if null)
  /// [areaTypes] List of area types (optional)
  /// [random] Random generator
  ///
  /// Returns list of unique valid PIN codes
  static List<String> generateBulk({
    required int count,
    List<String>? states,
    List<PINAreaType>? areaTypes,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 100000) throw ArgumentError('Maximum 100,000 PIN codes per batch');

    final availableStates = states ?? StateCodes.statePinRanges.keys.toList();
    final availableAreaTypes = areaTypes ?? PINAreaType.values;
    final generated = <String>{};

    int attempts = 0;
    final maxAttempts = count * 5;

    while (generated.length < count && attempts < maxAttempts) {
      try {
        final state = availableStates[random.nextInt(availableStates.length)];
        final areaType = availableAreaTypes[random.nextInt(availableAreaTypes.length)];

        final pin = generate(
          stateName: state,
          areaType: areaType,
          random: random,
        );

        generated.add(pin);
      } catch (e) {
        // Continue on error
      }
      attempts++;
    }

    return generated.toList();
  }

  /// Check if PIN is from specific state
  ///
  /// [pinCode] PIN code to check
  /// [stateName] State name to validate against
  static bool isFromState(String pinCode, String stateName) {
    return getStateName(pinCode) == stateName;
  }

  /// Get all PIN codes for a city (simulated common areas)
  ///
  /// [cityName] Name of the city
  /// [stateName] State where city is located
  /// [maxPins] Maximum number of PINs to generate
  /// [random] Random generator
  ///
  /// Returns list of PIN codes for different areas in the city
  static List<String> getCityPINs({
    required String cityName,
    required String stateName,
    int maxPins = 10,
    required Random random,
  }) {
    final pins = <String>[];
    final usedPins = <String>{};
    final areaTypes = PINAreaType.values;

    for (int i = 0; i < maxPins && i < areaTypes.length; i++) {
      try {
        int attempts = 0;
        String? pin;

        do {
          pin = generate(
            stateName: stateName,
            areaType: areaTypes[i],
            cityName: cityName,
            random: random,
          );
          attempts++;
        } while (usedPins.contains(pin) && attempts < 20);

        if (pin != null && !usedPins.contains(pin)) {
          pins.add(pin);
          usedPins.add(pin);
        }
      } catch (e) {
        // Continue on error
      }
    }

    return pins;
  }

  /// Generate PIN with specific pattern
  ///
  /// [pattern] Pattern like '56****' where * = random digit
  /// [stateName] State to validate against
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final pin = PINCodeGenerator.generateWithPattern(
  ///   pattern: '560***',
  ///   stateName: 'Karnataka',
  ///   random: Random(),
  /// );
  /// // Returns something like: 560123
  /// ```
  static String generateWithPattern({
    required String pattern,
    String? stateName,
    required Random random,
  }) {
    if (pattern.length != 6) {
      throw ArgumentError('Pattern must be exactly 6 characters');
    }

    String pinCode = '';
    for (int i = 0; i < 6; i++) {
      if (pattern[i] == '*') {
        pinCode += random.nextInt(10).toString();
      } else if (RegExp(r'\d').hasMatch(pattern[i])) {
        pinCode += pattern[i];
      } else {
        throw ArgumentError('Pattern can only contain digits and * characters');
      }
    }

    if (!isValid(pinCode, stateName)) {
      throw ArgumentError('Generated PIN is not valid: $pinCode');
    }

    return pinCode;
  }

  /// Get region for a state
  static PINRegion? _getRegionForState(String stateName) {
    for (final region in PINRegion.values) {
      if (region.states.contains(stateName)) {
        return region;
      }
    }
    return null;
  }

  /// Adjust PIN range based on area type and city
  static List<int> _adjustRangeForAreaAndCity(
    int startPin,
    int endPin,
    PINAreaType? areaType,
    String? cityName,
    String stateName,
    Random random,
  ) {
    // Check if city has known major PIN ranges
    final cityPins = StateCodes.majorCities[stateName]?[cityName];
    if (cityPins != null) {
      return cityPins;
    }

    // Adjust based on area type
    final rangeSize = endPin - startPin;

    switch (areaType) {
      case PINAreaType.metro:
      case PINAreaType.urban:
        // Urban areas typically have lower PIN codes (earlier establishment)
        final urbanEnd = startPin + (rangeSize * 0.3).round();
        return [startPin, urbanEnd];

      case PINAreaType.commercial:
      case PINAreaType.industrial:
        // Commercial areas often in mid-range
        final commercialStart = startPin + (rangeSize * 0.2).round();
        final commercialEnd = startPin + (rangeSize * 0.6).round();
        return [commercialStart, commercialEnd];

      case PINAreaType.rural:
        // Rural areas typically have higher PIN codes
        final ruralStart = startPin + (rangeSize * 0.7).round();
        return [ruralStart, endPin];

      case PINAreaType.suburban:
      case PINAreaType.residential:
        // Suburban areas in mid to higher range
        final suburbanStart = startPin + (rangeSize * 0.4).round();
        final suburbanEnd = startPin + (rangeSize * 0.8).round();
        return [suburbanStart, suburbanEnd];

      default:
        // Full range for other types
        return [startPin, endPin];
    }
  }

  /// Analyze area type from address text
  static PINAreaType _analyzeAreaType(String address, String? landmark) {
    final combined = '${address.toLowerCase()} ${landmark?.toLowerCase() ?? ''}';

    // Check for metro/urban indicators
    if (combined.contains(RegExp(r'\b(metro|downtown|city center|central|cbd)\b'))) {
      return PINAreaType.metro;
    }

    // Check for commercial indicators
    if (combined.contains(RegExp(r'\b(mall|market|business|commercial|office|shopping)\b'))) {
      return PINAreaType.commercial;
    }

    // Check for industrial indicators
    if (combined.contains(RegExp(r'\b(industrial|factory|plant|manufacturing|tech park|it park)\b'))) {
      return PINAreaType.industrial;
    }

    // Check for educational indicators
    if (combined.contains(RegExp(r'\b(university|college|school|campus|education)\b'))) {
      return PINAreaType.educational;
    }

    // Check for government indicators
    if (combined.contains(RegExp(r'\b(secretariat|government|office|ministry|collectorate)\b'))) {
      return PINAreaType.government;
    }

    // Check for transport indicators
    if (combined.contains(RegExp(r'\b(airport|station|railway|bus stand|terminal)\b'))) {
      return PINAreaType.transport;
    }

    // Check for rural indicators
    if (combined.contains(RegExp(r'\b(village|rural|farm|agricultural|gram)\b'))) {
      return PINAreaType.rural;
    }

    // Check for suburban indicators
    if (combined.contains(RegExp(r'\b(suburb|layout|extension|phase|colony)\b'))) {
      return PINAreaType.suburban;
    }

    // Default to residential
    return PINAreaType.residential;
  }

  /// Analyze area type from PIN pattern
  static PINAreaType? _analyzeAreaTypeFromPIN(String pinCode) {
    final lastThree = pinCode.substring(3);

    // Main post offices typically end in 001
    if (lastThree == '001') {
      return PINAreaType.urban;
    }

    // Low numbers often indicate urban/commercial areas
    final postOfficeNum = int.parse(lastThree);
    if (postOfficeNum <= 050) {
      return PINAreaType.urban;
    } else if (postOfficeNum <= 200) {
      return PINAreaType.suburban;
    } else {
      return PINAreaType.rural;
    }
  }

  /// Get all supported regions
  static List<PINRegion> getSupportedRegions() {
    return PINRegion.values;
  }

  /// Get all supported area types
  static List<PINAreaType> getSupportedAreaTypes() {
    return PINAreaType.values;
  }

  /// Get all supported states
  static List<String> getSupportedStates() {
    return StateCodes.statePinRanges.keys.toList();
  }

  /// Alias for generate to maintain compatibility
  static String generatePinCode({
    String? stateName,
    PINAreaType? areaType,
    String? cityName,
    Random? random,
  }) => generate(
    stateName: stateName ?? 'Delhi',
    areaType: areaType,
    cityName: cityName,
    random: random ?? Random(),
  );

  /// Alias for isValid to maintain compatibility
  static bool validatePinCode(String pinCode, [String? stateName]) => isValid(pinCode, stateName);
}

/// Extension on String for PIN code utilities
extension PINStringExtension on String {
  /// Check if this string is a valid PIN code
  bool get isValidPIN => PINCodeGenerator.isValid(this);

  /// Parse PIN components
  Map<String, dynamic>? get pinComponents => PINCodeGenerator.parsePIN(this);

  /// Get state name from this PIN code
  String? get pinStateName => PINCodeGenerator.getStateName(this);

  /// Get region from this PIN code
  PINRegion? get pinRegion => PINCodeGenerator.getRegion(this);

  /// Check if this PIN is from specific state
  bool isPINFromState(String stateName) => PINCodeGenerator.isFromState(this, stateName);

  /// Format PIN with space for display
  String get formattedPIN {
    if (length != 6) return this;
    return '${substring(0, 3)} ${substring(3)}';
  }

  /// Get geographic region code from PIN
  int? get regionCode {
    if (isValidPIN) return int.tryParse(this[0]);
    return null;
  }

  /// Get post office code from PIN
  String? get postOfficeCode {
    if (isValidPIN) return substring(3);
    return null;
  }
}