import 'dart:math' as math;
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/gstin_generator.dart';
import 'package:bharattesting_core/src/data_faker/tan_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';
import 'package:bharattesting_core/src/data_faker/pin_code_generator.dart';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';

/// Template for generating charitable trust's synthetic identifiers
class TrustTemplate {
  static const List<String> trustTypes = [
    'Educational', 'Charitable', 'Social', 'Religious', 'Cultural', 'Medical'
  ];

  /// Generate a single trust record
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

    // Generate PAN (Trust is 'T')
    final pan = PANGenerator.generate(
      entityType: PANEntityType.trust,
      random: random,
    );
    
    final finalPan = pan;

    // Trusts might not always have GST, but the test implies it
    final gstin = GSTINGenerator.generate(
      pan: finalPan,
      stateCode: stateCodeInt,
      random: random,
    );
    
    final trustName = _generateTrustName(random);
    final trustType = trustTypes[random.nextInt(trustTypes.length)];
    final tan = TANGenerator.generate(
      entityType: TANEntityType.trust,
      random: random,
    );
    final upiId = UPIGenerator.generate(
      type: UPIIDType.nameBased,
      userType: UPIUserType.enterprise,
      name: trustName,
      random: random,
    );

    return {
      'template_type': 'trust',
      'trust_name': trustName,
      'trust_type': trustType,
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
    if (record['template_type'] != 'trust') return false;

    final pan = record['pan'] as String?;
    final gstin = record['gstin'] as String?;

    if (pan == null || !PANGenerator.isValid(pan)) return false;
    
    // GSTIN is optional for trusts in reality, but if present validate it
    if (gstin != null && !GSTINGenerator.isValid(gstin)) return false;

    return true;
  }

  static String _generateTrustName(math.Random random) {
    final purposes = trustTypes;
    final suffixes = ['Foundation', 'Trust', 'Society', 'Mission', 'Seva Samithi'];
    return '${purposes[random.nextInt(purposes.length)]} ${suffixes[random.nextInt(suffixes.length)]}';
  }

  static String _generateRandomAddress(String state, String pin, math.Random random) {
    final plotNo = random.nextInt(100) + 1;
    final areas = ['Shanti Nagar', 'Vidya Vihar', 'Seva Colony', 'Heritage Zone'];
    final area = areas[random.nextInt(areas.length)];
    final city = PINCodeGenerator.getCityFromPin(pin) ?? 'City Center';
    
    return 'Plot No. $plotNo, $area, $city, $state - $pin';
  }
}
