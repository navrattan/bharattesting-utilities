import 'dart:math' as math;
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/gstin_generator.dart';
import 'package:bharattesting_core/src/data_faker/tan_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';
import 'package:bharattesting_core/src/data_faker/udyam_generator.dart';
import 'package:bharattesting_core/src/data_faker/pin_code_generator.dart';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';

/// Template for generating sole proprietorship synthetic identifiers
class ProprietorshipTemplate {
  /// Generate a single proprietorship record
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
    bool includeTAN = false,
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

    // Generate PAN (Proprietor is an Individual)
    final pan = PANGenerator.generate(
      entityType: PANEntityType.individual,
      random: random,
    );
    
    final finalPan = pan;

    final gstin = GSTINGenerator.generate(
      pan: finalPan,
      stateCode: stateCodeInt,
      random: random,
    );
    
    final businessName = _generateBusinessName(random);
    final upiId = UPIGenerator.generate(
      type: UPIIDType.nameBased,
      userType: UPIUserType.merchant,
      name: businessName,
      random: random,
    );
    
    final udyam = UdyamGenerator.generate(
      stateName: state,
      random: random,
    );

    final record = {
      'template_type': 'proprietorship',
      'business_name': businessName,
      'pan': finalPan,
      'gstin': gstin,
      'udyam': udyam,
      'pin_code': pinCode,
      'state': state,
      'state_code': stateCode,
      'address': _generateRandomAddress(state, pinCode, random),
      'upi_id': upiId,
      'generated_at': DateTime.now().toIso8601String(),
      'seed_used': seed,
    };

    if (includeTAN) {
      record['tan'] = TANGenerator.generate(
        entityType: TANEntityType.individual,
        random: random,
      );
    }

    return record;
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
    if (record['template_type'] != 'proprietorship') return false;

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

  static String _generateBusinessName(math.Random random) {
    final firstNames = ['Aarav', 'Priya', 'Arjun', 'Ananya', 'Veer', 'Diya'];
    final types = ['Traders', 'Enterprises', 'Associates', 'Corporation', 'Industries', 'Stores'];
    return '${firstNames[random.nextInt(firstNames.length)]} ${types[random.nextInt(types.length)]}';
  }

  static String _generateRandomAddress(String state, String pin, math.Random random) {
    final shopNo = random.nextInt(500) + 1;
    final markets = ['Main Market', 'Commercial Street', 'City Plaza', 'Vikas Bhavan', 'Indira Nagar'];
    final market = markets[random.nextInt(markets.length)];
    final city = PINCodeGenerator.getCityFromPin(pin) ?? 'Business Area';
    
    return 'Shop No. $shopNo, $market, $city, $state - $pin';
  }
}
