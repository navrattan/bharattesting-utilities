/// Address generator for realistic Indian addresses
///
/// Generates complete addresses with:
/// - Building/House number and name
/// - Street/Road name
/// - Area/Locality
/// - City
/// - State
/// - PIN code
/// - Optional landmarks
library address_generator;

import 'dart:math';
import '../data/state_codes.dart';
import 'pin_code_generator.dart';

/// Address types for different location contexts
enum AddressType {
  /// Residential address
  residential('Residential', 'Home addresses for individuals'),

  /// Commercial/office address
  commercial('Commercial', 'Business and office addresses'),

  /// Industrial address
  industrial('Industrial', 'Manufacturing and industrial locations'),

  /// Educational institution address
  educational('Educational', 'Schools, colleges, universities'),

  /// Healthcare facility address
  healthcare('Healthcare', 'Hospitals, clinics, medical centers'),

  /// Government office address
  government('Government', 'Government offices and departments'),

  /// Religious place address
  religious('Religious', 'Temples, mosques, churches, gurudwaras'),

  /// Shopping/retail address
  retail('Retail', 'Malls, markets, shopping centers'),

  /// Transportation hub address
  transport('Transport', 'Airports, railway stations, bus terminals'),

  /// Rural/village address
  rural('Rural', 'Village and rural area addresses');

  const AddressType(this.code, this.description);

  /// Short code
  final String code;

  /// Description
  final String description;
}

/// Address components for structured generation
class AddressComponents {
  const AddressComponents({
    required this.houseNumber,
    this.buildingName,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pinCode,
    this.landmark,
    this.district,
  });

  /// House/building number
  final String houseNumber;

  /// Building name (optional)
  final String? buildingName;

  /// Street/road name
  final String street;

  /// Area/locality/sector
  final String area;

  /// City name
  final String city;

  /// State name
  final String state;

  /// PIN code
  final String pinCode;

  /// Nearby landmark (optional)
  final String? landmark;

  /// District name (optional)
  final String? district;

  /// Format as complete address
  String get formattedAddress {
    final buffer = StringBuffer();

    // House number and building name
    if (buildingName != null) {
      buffer.write('$buildingName, $houseNumber');
    } else {
      buffer.write(houseNumber);
    }

    // Street and area
    buffer.write(', $street, $area');

    // Landmark if available
    if (landmark != null) {
      buffer.write(', Near $landmark');
    }

    // City and state
    buffer.write(', $city, $state $pinCode');

    return buffer.toString();
  }

  /// Format as multi-line address
  String get multiLineAddress {
    final lines = <String>[];

    // Line 1: House and building
    if (buildingName != null) {
      lines.add('$buildingName');
      lines.add(houseNumber);
    } else {
      lines.add(houseNumber);
    }

    // Line 2: Street
    lines.add(street);

    // Line 3: Area
    lines.add(area);

    // Line 4: Landmark (if available)
    if (landmark != null) {
      lines.add('Near $landmark');
    }

    // Line 5: City, State PIN
    lines.add('$city, $state $pinCode');

    return lines.join('\n');
  }
}

/// High-quality address generator with realistic Indian patterns
class AddressGenerator {
  const AddressGenerator._();

  /// Common building names by type
  static const Map<AddressType, List<String>> _buildingNames = {
    AddressType.residential: [
      'Sai Residency', 'Green Park Apartments', 'Royal Gardens', 'Sunrise Villa',
      'Krishna Heights', 'Shanti Niketan', 'Anand Bhavan', 'Lakshmi Mansion',
      'Ganesh Complex', 'Vaishali Apartments', 'Indira Nagar Society',
      'Raj Mahal', 'Shree Apartments', 'Ganga Vihar', 'Peacock Residency'
    ],
    AddressType.commercial: [
      'Business Centre', 'Corporate Plaza', 'Trade Tower', 'Commercial Complex',
      'Enterprise Hub', 'Business Park', 'Corporate Square', 'Metro Mall',
      'City Centre', 'Cyber Plaza', 'IT Park', 'Silicon Tower',
      'Tech Centre', 'Innovation Hub', 'Executive Plaza'
    ],
    AddressType.industrial: [
      'Industrial Estate', 'Manufacturing Hub', 'Production Centre',
      'Factory Complex', 'Industrial Park', 'Auto Complex',
      'Engineering Works', 'Industrial Zone', 'Export House',
      'Processing Unit', 'Machinery Park', 'Industrial Area'
    ],
    AddressType.educational: [
      'Education Centre', 'Knowledge Park', 'Academic Complex',
      'Learning Centre', 'School Campus', 'University Campus',
      'College Building', 'Institute Building', 'Training Centre',
      'Study Centre', 'Research Centre', 'Academic Block'
    ],
  };

  /// Common street types and names
  static const List<String> _streetTypes = [
    'Road', 'Street', 'Lane', 'Avenue', 'Marg', 'Path',
    'Colony', 'Nagar', 'Vihar', 'Park', 'Garden', 'Block'
  ];

  static const List<String> _streetNames = [
    'Main', 'MG', 'Gandhi', 'Nehru', 'Patel', 'Tagore', 'Subhash',
    'Rajaji', 'Station', 'Market', 'Church', 'School', 'Hospital',
    'Temple', 'Garden', 'Park', 'New', 'Old', 'East', 'West',
    'North', 'South', 'Central', 'Ring', 'Outer', 'Inner'
  ];

  /// Common area/locality names
  static const List<String> _areaNames = [
    'Jayanagar', 'Indiranagar', 'Koramangala', 'Malleswaram', 'Rajajinagar',
    'Vijayanagar', 'Basavanagudi', 'Seshadripuram', 'Sadashivanagar',
    'Andheri', 'Bandra', 'Borivali', 'Powai', 'Thane', 'Mulund',
    'Vikhroli', 'Ghatkopar', 'Dadar', 'Worli', 'Colaba',
    'Connaught Place', 'Lajpat Nagar', 'Karol Bagh', 'Rohini',
    'Dwarka', 'Vasant Kunj', 'Greater Kailash', 'Defence Colony',
    'T Nagar', 'Adyar', 'Mylapore', 'Velachery', 'Porur',
    'Anna Nagar', 'Nungambakkam', 'Egmore', 'Guindy'
  ];

  /// Common landmarks by type
  static const Map<AddressType, List<String>> _landmarks = {
    AddressType.residential: [
      'City Hospital', 'Metro Station', 'Bus Stand', 'Shopping Mall',
      'Temple', 'Park', 'School', 'Market', 'Police Station'
    ],
    AddressType.commercial: [
      'Metro Station', 'Business Park', 'Shopping Mall', 'Airport',
      'IT Park', 'Convention Centre', 'Hotel', 'Bank'
    ],
    AddressType.educational: [
      'Library', 'Sports Complex', 'Metro Station', 'Bus Stand',
      'Hospital', 'Park', 'Shopping Centre'
    ],
    AddressType.industrial: [
      'Railway Station', 'Highway', 'Industrial Gate',
      'Transport Hub', 'Container Depot'
    ],
  };

  /// Generate a complete address
  ///
  /// [addressType] Type of address to generate
  /// [stateName] State where address is located
  /// [cityName] City name (optional, will select random city if null)
  /// [pinCode] Specific PIN code (optional, will generate if null)
  /// [includeBuilding] Whether to include building name
  /// [includeLandmark] Whether to include landmark
  /// [random] Random number generator
  ///
  /// Returns complete AddressComponents
  ///
  /// Example:
  /// ```dart
  /// final address = AddressGenerator.generate(
  ///   addressType: AddressType.residential,
  ///   stateName: 'Karnataka',
  ///   cityName: 'Bangalore',
  ///   includeBuilding: true,
  ///   includeLandmark: true,
  ///   random: Random(42),
  /// );
  /// print(address.formattedAddress);
  /// ```
  static AddressComponents generate({
    required AddressType addressType,
    required String stateName,
    String? cityName,
    String? pinCode,
    bool includeBuilding = true,
    bool includeLandmark = true,
    required Random random,
  }) {
    // Generate or use provided city
    final city = cityName ?? _selectCityForState(stateName, random);

    // Generate or use provided PIN code
    final pin = pinCode ?? PINCodeGenerator.generate(
      stateName: stateName,
      cityName: city,
      areaType: _getAreaTypeForAddressType(addressType),
      random: random,
    );

    // Generate address components
    final houseNumber = _generateHouseNumber(addressType, random);
    final buildingName = includeBuilding
        ? _generateBuildingName(addressType, random)
        : null;
    final street = _generateStreetName(random);
    final area = _generateAreaName(city, random);
    final landmark = includeLandmark
        ? _generateLandmark(addressType, random)
        : null;

    return AddressComponents(
      houseNumber: houseNumber,
      buildingName: buildingName,
      street: street,
      area: area,
      city: city,
      state: stateName,
      pinCode: pin,
      landmark: landmark,
    );
  }

  /// Generate address from partial information
  ///
  /// [partialAddress] Partial address string
  /// [stateName] State name
  /// [addressType] Type of address (optional, will analyze if null)
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final address = AddressGenerator.generateFromPartial(
  ///   partialAddress: 'Near Tech Park, Electronic City',
  ///   stateName: 'Karnataka',
  ///   random: Random(),
  /// );
  /// ```
  static AddressComponents generateFromPartial({
    required String partialAddress,
    required String stateName,
    AddressType? addressType,
    required Random random,
  }) {
    // Analyze address type from partial address
    final type = addressType ?? _analyzeAddressType(partialAddress);

    // Extract any city information from partial address
    String? cityName;
    for (final city in StateCodes.majorCities[stateName]?.keys ?? <String>[]) {
      if (partialAddress.toLowerCase().contains(city.toLowerCase())) {
        cityName = city;
        break;
      }
    }

    return generate(
      addressType: type,
      stateName: stateName,
      cityName: cityName,
      random: random,
    );
  }

  /// Generate business address
  ///
  /// [businessName] Name of the business
  /// [businessType] Type of business
  /// [stateName] State where business is located
  /// [preferredArea] Preferred area/locality (optional)
  /// [random] Random generator
  ///
  /// Example:
  /// ```dart
  /// final address = AddressGenerator.generateBusinessAddress(
  ///   businessName: 'Tech Solutions Pvt Ltd',
  ///   businessType: 'software',
  ///   stateName: 'Maharashtra',
  ///   preferredArea: 'Bandra Kurla Complex',
  ///   random: Random(),
  /// );
  /// ```
  static AddressComponents generateBusinessAddress({
    required String businessName,
    required String businessType,
    required String stateName,
    String? preferredArea,
    required Random random,
  }) {
    // Determine address type from business type
    final addressType = _getAddressTypeFromBusiness(businessType);

    // Generate base address
    final address = generate(
      addressType: addressType,
      stateName: stateName,
      includeBuilding: true,
      includeLandmark: true,
      random: random,
    );

    // Customize building name for business
    final customBuildingName = _generateBusinessBuildingName(businessType, random);

    return AddressComponents(
      houseNumber: address.houseNumber,
      buildingName: customBuildingName,
      street: address.street,
      area: preferredArea ?? address.area,
      city: address.city,
      state: address.state,
      pinCode: address.pinCode,
      landmark: address.landmark,
    );
  }

  /// Generate multiple addresses for testing/bulk operations
  ///
  /// [count] Number of addresses to generate
  /// [addressTypes] List of address types to use (optional)
  /// [states] List of states (optional, all states if null)
  /// [random] Random generator
  ///
  /// Returns list of generated addresses
  static List<AddressComponents> generateBulk({
    required int count,
    List<AddressType>? addressTypes,
    List<String>? states,
    required Random random,
  }) {
    if (count <= 0) return [];
    if (count > 10000) throw ArgumentError('Maximum 10,000 addresses per batch');

    final availableTypes = addressTypes ?? AddressType.values;
    final availableStates = states ?? StateCodes.statePinRanges.keys.toList();
    final addresses = <AddressComponents>[];

    for (int i = 0; i < count; i++) {
      try {
        final type = availableTypes[random.nextInt(availableTypes.length)];
        final state = availableStates[random.nextInt(availableStates.length)];

        final address = generate(
          addressType: type,
          stateName: state,
          random: random,
        );

        addresses.add(address);
      } catch (e) {
        // Continue on error
      }
    }

    return addresses;
  }

  /// Validate address components
  ///
  /// [address] Address components to validate
  /// Returns true if all components are valid, false otherwise
  static bool isValidAddress(AddressComponents address) {
    // Check required fields
    if (address.houseNumber.isEmpty) return false;
    if (address.street.isEmpty) return false;
    if (address.area.isEmpty) return false;
    if (address.city.isEmpty) return false;
    if (address.state.isEmpty) return false;

    // Validate PIN code
    if (!PINCodeGenerator.isValid(address.pinCode, address.state)) {
      return false;
    }

    // Check if PIN matches state
    if (!PINCodeGenerator.isFromState(address.pinCode, address.state)) {
      return false;
    }

    return true;
  }

  /// Generate house/building number
  static String _generateHouseNumber(AddressType addressType, Random random) {
    switch (addressType) {
      case AddressType.residential:
        // House numbers like #123, A-45, Block-B 567
        final formats = [
          '#${random.nextInt(9999) + 1}',
          '${String.fromCharCode(65 + random.nextInt(26))}-${random.nextInt(999) + 1}',
          'Block ${String.fromCharCode(65 + random.nextInt(10))} ${random.nextInt(99) + 1}',
        ];
        return formats[random.nextInt(formats.length)];

      case AddressType.commercial:
        // Commercial formats like Floor 3, Office 45, Suite 123
        final formats = [
          'Floor ${random.nextInt(20) + 1}',
          'Office ${random.nextInt(999) + 1}',
          'Suite ${random.nextInt(500) + 1}',
          'Unit ${random.nextInt(200) + 1}',
        ];
        return formats[random.nextInt(formats.length)];

      case AddressType.industrial:
        // Industrial formats like Plot 45, Shed 12, Bay 5
        final formats = [
          'Plot ${random.nextInt(500) + 1}',
          'Shed ${random.nextInt(100) + 1}',
          'Bay ${random.nextInt(50) + 1}',
          'Unit ${random.nextInt(200) + 1}',
        ];
        return formats[random.nextInt(formats.length)];

      default:
        // Default format
        return '#${random.nextInt(999) + 1}';
    }
  }

  /// Generate building name
  static String? _generateBuildingName(AddressType addressType, Random random) {
    final buildingNames = _buildingNames[addressType];
    if (buildingNames == null || random.nextDouble() < 0.3) {
      return null; // 30% chance of no building name
    }

    return buildingNames[random.nextInt(buildingNames.length)];
  }

  /// Generate street name
  static String _generateStreetName(Random random) {
    final name = _streetNames[random.nextInt(_streetNames.length)];
    final type = _streetTypes[random.nextInt(_streetTypes.length)];
    return '$name $type';
  }

  /// Generate area name
  static String _generateAreaName(String cityName, Random random) {
    // Try to use city-specific areas first
    if (random.nextBool()) {
      return _areaNames[random.nextInt(_areaNames.length)];
    }

    // Generate generic area name
    final prefixes = ['New', 'Old', 'East', 'West', 'North', 'South', 'Central'];
    final suffixes = ['Nagar', 'Colony', 'Layout', 'Extension', 'Phase', 'Block'];

    final prefix = prefixes[random.nextInt(prefixes.length)];
    final suffix = suffixes[random.nextInt(suffixes.length)];

    return '$prefix $suffix';
  }

  /// Generate landmark
  static String? _generateLandmark(AddressType addressType, Random random) {
    if (random.nextDouble() < 0.4) return null; // 40% chance of no landmark

    final landmarks = _landmarks[addressType] ?? _landmarks[AddressType.residential]!;
    return landmarks[random.nextInt(landmarks.length)];
  }

  /// Select city for state
  static String _selectCityForState(String stateName, Random random) {
    final cities = StateCodes.majorCities[stateName];
    if (cities != null && cities.isNotEmpty) {
      final cityNames = cities.keys.toList();
      return cityNames[random.nextInt(cityNames.length)];
    }

    // Fallback to state capital or major city
    final capitals = {
      'Karnataka': 'Bangalore',
      'Maharashtra': 'Mumbai',
      'Tamil Nadu': 'Chennai',
      'West Bengal': 'Kolkata',
      'Gujarat': 'Ahmedabad',
      'Rajasthan': 'Jaipur',
      'Uttar Pradesh': 'Lucknow',
      'Delhi': 'New Delhi',
    };

    return capitals[stateName] ?? 'City';
  }

  /// Get area type for address type
  static PINAreaType _getAreaTypeForAddressType(AddressType addressType) {
    switch (addressType) {
      case AddressType.residential:
        return PINAreaType.residential;
      case AddressType.commercial:
        return PINAreaType.commercial;
      case AddressType.industrial:
        return PINAreaType.industrial;
      case AddressType.educational:
        return PINAreaType.educational;
      case AddressType.government:
        return PINAreaType.government;
      case AddressType.transport:
        return PINAreaType.transport;
      case AddressType.rural:
        return PINAreaType.rural;
      default:
        return PINAreaType.urban;
    }
  }

  /// Analyze address type from text
  static AddressType _analyzeAddressType(String address) {
    final lower = address.toLowerCase();

    if (lower.contains(RegExp(r'\b(home|house|apartment|flat|residence)\b'))) {
      return AddressType.residential;
    }
    if (lower.contains(RegExp(r'\b(office|business|company|corporate)\b'))) {
      return AddressType.commercial;
    }
    if (lower.contains(RegExp(r'\b(factory|industry|plant|manufacturing)\b'))) {
      return AddressType.industrial;
    }
    if (lower.contains(RegExp(r'\b(school|college|university|institute)\b'))) {
      return AddressType.educational;
    }
    if (lower.contains(RegExp(r'\b(hospital|clinic|medical|health)\b'))) {
      return AddressType.healthcare;
    }
    if (lower.contains(RegExp(r'\b(temple|mosque|church|gurudwara)\b'))) {
      return AddressType.religious;
    }
    if (lower.contains(RegExp(r'\b(mall|market|shop|store|retail)\b'))) {
      return AddressType.retail;
    }
    if (lower.contains(RegExp(r'\b(village|rural|farm|gram)\b'))) {
      return AddressType.rural;
    }

    return AddressType.residential; // Default
  }

  /// Get address type from business type
  static AddressType _getAddressTypeFromBusiness(String businessType) {
    final type = businessType.toLowerCase();

    if (type.contains('software') || type.contains('it') || type.contains('tech')) {
      return AddressType.commercial;
    }
    if (type.contains('manufacturing') || type.contains('factory')) {
      return AddressType.industrial;
    }
    if (type.contains('education') || type.contains('training')) {
      return AddressType.educational;
    }
    if (type.contains('hospital') || type.contains('medical')) {
      return AddressType.healthcare;
    }
    if (type.contains('retail') || type.contains('shop')) {
      return AddressType.retail;
    }

    return AddressType.commercial; // Default for business
  }

  /// Generate business building name
  static String _generateBusinessBuildingName(String businessType, Random random) {
    final commercialNames = _buildingNames[AddressType.commercial]!;
    return commercialNames[random.nextInt(commercialNames.length)];
  }

  /// Get all supported address types
  static List<AddressType> getSupportedAddressTypes() {
    return AddressType.values;
  }

  /// Get all supported states
  static List<String> getSupportedStates() {
    return StateCodes.statePinRanges.keys.toList();
  }
}

/// Extension on String for address utilities
extension AddressStringExtension on String {
  /// Analyze address type from this string
  AddressType get analyzedAddressType => AddressGenerator._analyzeAddressType(this);

  /// Check if this looks like a residential address
  bool get isResidentialAddress => analyzedAddressType == AddressType.residential;

  /// Check if this looks like a commercial address
  bool get isCommercialAddress => analyzedAddressType == AddressType.commercial;

  /// Extract PIN code from address text
  String? get extractPINCode {
    final pinMatch = RegExp(r'\b\d{6}\b').firstMatch(this);
    return pinMatch?.group(0);
  }

  /// Extract state name from address text (basic implementation)
  String? get extractStateName {
    final stateNames = StateCodes.gstinStateCodes.values;
    for (final state in stateNames) {
      if (toLowerCase().contains(state.toLowerCase())) {
        return state;
      }
    }
    return null;
  }
}