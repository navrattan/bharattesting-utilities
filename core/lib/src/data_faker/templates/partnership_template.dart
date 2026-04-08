import 'dart:math' as math;
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/gstin_generator.dart';
import 'package:bharattesting_core/src/data_faker/tan_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';
import 'package:bharattesting_core/src/data_faker/pin_code_generator.dart';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';

/// Template for generating partnership firm's synthetic identifiers
class PartnershipTemplate {
  /// Generate a single partnership record
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
  }) {
    final random = math.Random(seed);
    
    // Choose state
    String state;
    int stateCodeInt;
    
    if (preferredState != null && StateCodes.stateNameToCode.containsKey(preferredState)) {
      state = preferredState;
      stateCodeInt = StateCodes.stateNameToCode[preferredState]!;
    } else {
      stateCodeInt = StateCodes.getRandomStateCode();
      state = StateCodes.getStateName(stateCodeInt) ?? 'Karnataka';
    }
    
    final stateCode = stateCodeInt.toString().padLeft(2, '0');
    final pinCode = PINCodeGenerator.generateForState(state, random);

    // Generate PAN (Partnership/Firm is 'F')
    final pan = PANGenerator.generate(
      entityType: PANEntityType.firm,
      random: random,
    );
    
    final finalPan = pan;

    final gstin = GSTINGenerator.generate(
      pan: finalPan,
      stateCode: stateCodeInt,
      random: random,
    );
    
    final firmName = _generateFirmName(random);
    final tan = TANGenerator.generate(
      entityType: TANEntityType.firm,
      random: random,
    );
    final upiId = UPIGenerator.generate(
      type: UPIIDType.nameBased,
      userType: UPIUserType.enterprise,
      name: firmName,
      random: random,
    );

    return {
      'template_type': 'partnership',
      'firm_name': firmName,
      'pan': finalPan,
      'gstin': gstin,
      'tan': tan,
      'pin_code': pinCode,
      'state': state,
      'state_code': stateCode,
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
  }) {
    return List.generate(
      count,
      (index) => generate(seed: baseSeed != null ? baseSeed + index : null),
    );
  }

  /// Validate consistency
  static bool validate(Map<String, dynamic> record) {
    if (record['template_type'] != 'partnership') return false;

    final pan = record['pan'] as String?;
    final gstin = record['gstin'] as String?;
    final stateCode = record['state_code'] as String?;

    if (pan == null || !PANGenerator.isValid(pan)) return false;
    if (gstin == null || !GSTINGenerator.isValid(gstin)) return false;

    // Check PAN-GSTIN consistency
    if (gstin.substring(2, 12) != pan) return false;
    
    // Check StateCode-GSTIN consistency
    if (gstin.substring(0, 2) != stateCode) return false;

    return true;
  }

  static String _generateFirmName(math.Random random) {
    final names = ['Verma', 'Sharma', 'Reddy', 'Patel', 'Das', 'Mehra'];
    final types = ['& Associates', '& Partners', '& Co.', 'LLP', 'Partnership'];
    return '${names[random.nextInt(names.length)]} ${types[random.nextInt(types.length)]}';
  }

  static String _generateRandomAddress(String state, String pin, math.Random random) {
    final officeNo = random.nextInt(300) + 101;
    final centers = ['Professional Center', 'Corporate Towers', 'Partner Square', 'Regency Complex'];
    final center = centers[random.nextInt(centers.length)];
    final city = PINCodeGenerator.getCityFromPin(pin) ?? 'Business District';
    
    return 'Suite $officeNo, $center, $city, $state - $pin';
  }
}
