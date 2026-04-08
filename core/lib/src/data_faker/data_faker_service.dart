/// Main Data Faker Service - Coordinates all generators
///
/// Provides unified interface for generating Indian identifier data

import 'dart:math';

/// Supported identifier types
enum IdentifierType {
  pan('PAN', 'Permanent Account Number'),
  gstin('GSTIN', 'Goods and Services Tax Identification Number'),
  aadhaar('Aadhaar', 'Unique Identification Number'),
  cin('CIN', 'Corporate Identity Number'),
  tan('TAN', 'Tax Deduction Account Number'),
  ifsc('IFSC', 'Indian Financial System Code'),
  upi('UPI', 'Unified Payments Interface ID'),
  udyam('Udyam', 'Udyam Registration Number'),
  pinCode('PIN Code', 'Postal Index Number');

  const IdentifierType(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Template types for data generation
enum TemplateType {
  individual('Individual', 'Personal identifiers'),
  company('Company', 'Corporate identifiers'),
  proprietorship('Proprietorship', 'Sole proprietorship'),
  partnership('Partnership', 'Partnership firm'),
  trust('Trust', 'Trust organization');

  const TemplateType(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Generated record with Indian identifiers
class GeneratedRecord {
  const GeneratedRecord({
    required this.template,
    required this.identifiers,
    required this.metadata,
  });

  final TemplateType template;
  final Map<IdentifierType, String> identifiers;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() {
    return {
      'template': template.name,
      for (var entry in identifiers.entries)
        entry.key.name: entry.value,
      ...metadata,
    };
  }
}

/// Main Data Faker Service
class DataFakerService {
  DataFakerService({int? seed}) : _random = Random(seed);

  final Random _random;

  /// Generate a single record
  GeneratedRecord generateRecord({
    required TemplateType template,
    required Set<IdentifierType> identifiers,
  }) {
    final record = <IdentifierType, String>{};
    final metadata = <String, dynamic>{};

    // Generate based on template
    switch (template) {
      case TemplateType.individual:
        _generateIndividualRecord(record, metadata, identifiers);
        break;
      case TemplateType.company:
        _generateCompanyRecord(record, metadata, identifiers);
        break;
      case TemplateType.proprietorship:
        _generateProprietorshipRecord(record, metadata, identifiers);
        break;
      case TemplateType.partnership:
        _generatePartnershipRecord(record, metadata, identifiers);
        break;
      case TemplateType.trust:
        _generateTrustRecord(record, metadata, identifiers);
        break;
    }

    return GeneratedRecord(
      template: template,
      identifiers: record,
      metadata: metadata,
    );
  }

  /// Generate multiple records
  List<GeneratedRecord> generateBulk({
    required TemplateType template,
    required Set<IdentifierType> identifiers,
    required int count,
  }) {
    return List.generate(count, (index) => generateRecord(
      template: template,
      identifiers: identifiers,
    ));
  }

  void _generateIndividualRecord(
    Map<IdentifierType, String> record,
    Map<String, dynamic> metadata,
    Set<IdentifierType> identifiers,
  ) {
    // Basic person data
    metadata['name'] = _generateName();
    metadata['type'] = 'Individual';

    // Generate requested identifiers
    if (identifiers.contains(IdentifierType.pan)) {
      record[IdentifierType.pan] = _generatePAN(individual: true);
    }
    if (identifiers.contains(IdentifierType.aadhaar)) {
      record[IdentifierType.aadhaar] = _generateAadhaar();
    }
    if (identifiers.contains(IdentifierType.upi)) {
      record[IdentifierType.upi] = _generateUPI();
    }
    if (identifiers.contains(IdentifierType.pinCode)) {
      final pinCode = _generatePinCode();
      record[IdentifierType.pinCode] = pinCode;
      metadata['state'] = _getStateFromPin(pinCode);
    }
  }

  void _generateCompanyRecord(
    Map<IdentifierType, String> record,
    Map<String, dynamic> metadata,
    Set<IdentifierType> identifiers,
  ) {
    // Company data
    metadata['companyName'] = _generateCompanyName();
    metadata['type'] = 'Company';

    // Generate requested identifiers
    if (identifiers.contains(IdentifierType.pan)) {
      record[IdentifierType.pan] = _generatePAN(individual: false);
    }
    if (identifiers.contains(IdentifierType.gstin)) {
      final pan = record[IdentifierType.pan] ?? _generatePAN(individual: false);
      record[IdentifierType.gstin] = _generateGSTIN(pan: pan);
    }
    if (identifiers.contains(IdentifierType.cin)) {
      record[IdentifierType.cin] = _generateCIN();
    }
    if (identifiers.contains(IdentifierType.tan)) {
      record[IdentifierType.tan] = _generateTAN();
    }
    if (identifiers.contains(IdentifierType.udyam)) {
      record[IdentifierType.udyam] = _generateUdyam();
    }
  }

  void _generateProprietorshipRecord(
    Map<IdentifierType, String> record,
    Map<String, dynamic> metadata,
    Set<IdentifierType> identifiers,
  ) {
    metadata['proprietorName'] = _generateName();
    metadata['businessName'] = _generateBusinessName();
    metadata['type'] = 'Proprietorship';
    _generateCompanyRecord(record, metadata, identifiers);
  }

  void _generatePartnershipRecord(
    Map<IdentifierType, String> record,
    Map<String, dynamic> metadata,
    Set<IdentifierType> identifiers,
  ) {
    metadata['firmName'] = _generateFirmName();
    metadata['type'] = 'Partnership';
    _generateCompanyRecord(record, metadata, identifiers);
  }

  void _generateTrustRecord(
    Map<IdentifierType, String> record,
    Map<String, dynamic> metadata,
    Set<IdentifierType> identifiers,
  ) {
    metadata['trustName'] = _generateTrustName();
    metadata['type'] = 'Trust';
    _generateCompanyRecord(record, metadata, identifiers);
  }

  // Basic generators (simplified for MVP)
  String _generatePAN({required bool individual}) {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final digits = '0123456789';
    final typeCode = individual ? 'P' : 'C';

    return '${letters[_random.nextInt(26)]}'
           '${letters[_random.nextInt(26)]}'
           '${letters[_random.nextInt(26)]}'
           '$typeCode'
           '${letters[_random.nextInt(26)]}'
           '${digits[_random.nextInt(10)]}'
           '${digits[_random.nextInt(10)]}'
           '${digits[_random.nextInt(10)]}'
           '${digits[_random.nextInt(10)]}'
           '${letters[_random.nextInt(26)]}';
  }

  String _generateAadhaar() {
    return List.generate(12, (index) => _random.nextInt(10).toString()).join();
  }

  String _generateGSTIN({required String pan}) {
    final stateCode = (_random.nextInt(37) + 1).toString().padLeft(2, '0');
    return '${stateCode}${pan.substring(0, 10)}1Z${_random.nextInt(10)}';
  }

  String _generateCIN() {
    final year = 2000 + _random.nextInt(24);
    final state = ['MH', 'DL', 'KA', 'TN', 'GJ'][_random.nextInt(5)];
    final number = _random.nextInt(999999).toString().padLeft(6, '0');
    return 'L85110${state}${year}PLC$number';
  }

  String _generateTAN() {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final digits = '0123456789';
    return '${letters[_random.nextInt(26)]}'
           '${letters[_random.nextInt(26)]}'
           '${letters[_random.nextInt(26)]}'
           '${letters[_random.nextInt(26)]}'
           '${digits[_random.nextInt(10)]}'
           '${digits[_random.nextInt(10)]}'
           '${digits[_random.nextInt(10)]}'
           '${digits[_random.nextInt(10)]}'
           '${letters[_random.nextInt(26)]}';
  }

  String _generateUPI() {
    final providers = ['paytm', 'phonepe', 'googlepay', 'ybl', 'ibl'];
    final name = _generateName().toLowerCase().replaceAll(' ', '.');
    final provider = providers[_random.nextInt(providers.length)];
    return '$name@$provider';
  }

  String _generateUdyam() {
    return 'UDYAM-${_random.nextInt(100).toString().padLeft(2, '0')}'
           '-${_random.nextInt(10000000).toString().padLeft(7, '0')}';
  }

  String _generatePinCode() {
    return (100000 + _random.nextInt(899999)).toString();
  }

  String _generateName() {
    final firstNames = ['Aarav', 'Priya', 'Arjun', 'Ananya', 'Veer', 'Diya'];
    final lastNames = ['Sharma', 'Patel', 'Singh', 'Kumar', 'Agarwal', 'Gupta'];
    return '${firstNames[_random.nextInt(firstNames.length)]} '
           '${lastNames[_random.nextInt(lastNames.length)]}';
  }

  String _generateCompanyName() {
    final prefixes = ['Tech', 'Digital', 'Smart', 'Global', 'Prime', 'Elite'];
    final suffixes = ['Solutions', 'Systems', 'Services', 'Technologies', 'Enterprises'];
    return '${prefixes[_random.nextInt(prefixes.length)]} '
           '${suffixes[_random.nextInt(suffixes.length)]} Pvt Ltd';
  }

  String _generateBusinessName() {
    final types = ['Traders', 'Enterprises', 'Associates', 'Corporation', 'Industries'];
    return '${_generateName().split(' ').first} ${types[_random.nextInt(types.length)]}';
  }

  String _generateFirmName() {
    final types = ['& Associates', '& Partners', '& Co.', 'LLP', 'Partnership'];
    return '${_generateName().split(' ').last} ${types[_random.nextInt(types.length)]}';
  }

  String _generateTrustName() {
    final purposes = ['Educational', 'Charitable', 'Social', 'Religious', 'Cultural'];
    return '${purposes[_random.nextInt(purposes.length)]} Trust';
  }

  String _getStateFromPin(String pin) {
    final firstDigit = int.parse(pin[0]);
    final states = [
      'Delhi', 'Haryana', 'Punjab', 'Himachal Pradesh', 'Rajasthan',
      'Uttar Pradesh', 'Uttarakhand', 'Bihar', 'West Bengal', 'Odisha',
      'Jharkhand', 'Assam', 'Manipur', 'Mizoram', 'Nagaland', 'Arunachal Pradesh',
      'Tripura', 'Meghalaya', 'Sikkim', 'Maharashtra', 'Gujarat', 'Madhya Pradesh',
      'Chhattisgarh', 'Karnataka', 'Kerala', 'Tamil Nadu', 'Andhra Pradesh',
      'Telangana', 'Goa', 'Jammu and Kashmir', 'Ladakh'
    ];
    return firstDigit < states.length ? states[firstDigit] : 'Unknown';
  }
}