import 'dart:math' as math;
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/aadhaar_generator.dart';
import 'package:bharattesting_core/src/data_faker/pin_code_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';

/// Template for generating individual person's synthetic identifiers
class IndividualTemplate {
  /// Generate a single individual record
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
  }) {
    final random = math.Random(seed);
    
    // Generate name
    final name = _generateName(random);
    
    // Choose state and PIN
    String state;
    String pinCode;
    
    if (preferredState != null && StateCodes.statePinRanges.containsKey(preferredState)) {
      state = preferredState;
      pinCode = PINCodeGenerator.generateForState(state, random);
    } else {
      pinCode = (110001 + random.nextInt(700000)).toString(); // Basic random PIN
      state = PINCodeGenerator.getStateFromPin(pinCode) ?? 'Delhi';
    }

    // Generate identifiers
    final pan = PANGenerator.generate(
      entityType: PANEntityType.individual,
      random: random,
    );
    
    final aadhaar = AadhaarGenerator.generate(random);
    final upiId = UPIGenerator.generate(
      type: UPIIDType.nameBased,
      userType: UPIUserType.individual,
      name: name,
      random: random,
    );

    return {
      'template_type': 'individual',
      'name': name,
      'pan': pan,
      'aadhaar': aadhaar,
      'pin_code': pinCode,
      'state': state,
      'address': _generateRandomAddress(state, pinCode, random),
      'upi_id': upiId,
      'generated_at': DateTime.now().toIso8601String(),
      'seed_used': seed,
    };
  }

  /// Generate multiple records
  static List<Map<String, dynamic>> generateBulk({
    required int count,
    int? baseSeed,
    String? preferredState,
  }) {
    return List.generate(
      count,
      (index) => generate(
        seed: baseSeed != null ? baseSeed + index : null,
        preferredState: preferredState,
      ),
    );
  }

  /// Validate an individual record's consistency
  static bool validate(Map<String, dynamic> record) {
    if (record['template_type'] != 'individual') return false;

    final pan = record['pan'] as String?;
    final aadhaar = record['aadhaar'] as String?;
    final pinCode = record['pin_code'] as String?;
    final state = record['state'] as String?;

    if (pan == null || !PANGenerator.isValid(pan)) return false;
    if (aadhaar == null || !AadhaarGenerator.isValid(aadhaar)) return false;
    if (pinCode == null || !PINCodeGenerator.isValid(pinCode)) return false;

    // Check entity type in PAN (4th character 'P' for individual)
    if (pan[3] != 'P') return false;

    // Check state/PIN consistency
    if (state != null) {
      final expectedState = PINCodeGenerator.getStateFromPin(pinCode);
      if (expectedState != state) return false;
    }

    return true;
  }

  static String _generateName(math.Random random) {
    final firstNames = ['Aarav', 'Priya', 'Arjun', 'Ananya', 'Veer', 'Diya', 'Rahul', 'Deepika'];
    final lastNames = ['Sharma', 'Patel', 'Singh', 'Kumar', 'Agarwal', 'Gupta', 'Mehta', 'Jain'];
    return '${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}';
  }

  static String _generateRandomAddress(String state, String pin, math.Random random) {
    final doorNo = random.nextInt(999) + 1;
    final streets = ['Main Road', 'Cross Road', 'MG Road', 'Station Road', 'Garden Layout', 'Tech Park'];
    final street = streets[random.nextInt(streets.length)];
    final city = PINCodeGenerator.getCityFromPin(pin) ?? 'City Center';
    
    return 'No. $doorNo, $street, $city, $state - $pin';
  }
}
