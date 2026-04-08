import 'dart:math' as math;
import 'package:bharattesting_core/src/data_faker/pan_generator.dart';
import 'package:bharattesting_core/src/data_faker/gstin_generator.dart';
import 'package:bharattesting_core/src/data_faker/cin_generator.dart';
import 'package:bharattesting_core/src/data_faker/tan_generator.dart';
import 'package:bharattesting_core/src/data_faker/ifsc_generator.dart';
import 'package:bharattesting_core/src/data_faker/upi_generator.dart';
import 'package:bharattesting_core/src/data_faker/udyam_generator.dart';
import 'package:bharattesting_core/src/data_faker/pin_code_generator.dart';
import 'package:bharattesting_core/src/data_faker/data/state_codes.dart';

/// Template for generating private limited company's synthetic identifiers
class CompanyTemplate {
  /// Generate a single company record
  static Map<String, dynamic> generate({
    int? seed,
    String? preferredState,
  }) {
    final random = math.Random(seed);
    
    // Choose state and state code
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

    // Generate identifiers in dependency order
    final pan = PANGenerator.generate(
      entityType: PANEntityType.company,
      random: random,
    );
    
    final finalPan = pan;
    final companyName = _generateCompanyName(random);

    final gstin = GSTINGenerator.generate(
      pan: finalPan,
      stateCode: stateCodeInt,
      random: random,
    );
    
    final cin = CINGenerator.generateFromCompany(
      companyName: companyName,
      companyType: CINCompanyType.privateLimited,
      yearOfIncorporation: 2010 + random.nextInt(15),
      stateCode: stateCodeInt,
      random: random,
    );
    
    final tan = TANGenerator.generate(
      entityType: TANEntityType.company,
      random: random,
    );
    
    final bankPrefix = 'ICIC'; // Sample bank
    final ifsc = IFSCGenerator.generateFromPrefix(
      bankPrefix: bankPrefix,
      random: random,
    );
    
    final upiId = UPIGenerator.generate(
      type: UPIIDType.nameBased,
      userType: UPIUserType.enterprise,
      name: companyName,
      random: random,
    );
    
    final udyam = UdyamGenerator.generate(
      stateName: state,
      random: random,
    );

    return {
      'template_type': 'company',
      'company_type': 'private',
      'company_name': companyName,
      'pan': finalPan,
      'gstin': gstin,
      'cin': cin,
      'tan': tan,
      'ifsc': ifsc,
      'upi_id': upiId,
      'udyam': udyam,
      'pin_code': pinCode,
      'state': state,
      'state_code': stateCode,
      'address': _generateRandomAddress(state, pinCode, random),
      'bank_code': bankPrefix,
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

  /// Validate a company record's consistency
  static bool validate(Map<String, dynamic> record) {
    if (record['template_type'] != 'company') return false;

    final pan = record['pan'] as String?;
    final gstin = record['gstin'] as String?;
    final cin = record['cin'] as String?;
    final stateCode = record['state_code'] as String?;

    if (pan == null || !PANGenerator.isValid(pan)) return false;
    if (gstin == null || !GSTINGenerator.isValid(gstin)) return false;
    if (cin == null || !CINGenerator.isValid(cin)) return false;

    // Check PAN-GSTIN consistency
    if (gstin.substring(2, 12) != pan) return false;
    
    // Check StateCode-GSTIN consistency
    if (gstin.substring(0, 2) != stateCode) return false;

    return true;
  }

  static String _generateCompanyName(math.Random random) {
    final prefixes = ['Tech', 'Digital', 'Smart', 'Global', 'Prime', 'Elite', 'Nexus', 'Future'];
    final suffixes = ['Solutions', 'Systems', 'Services', 'Technologies', 'Enterprises', 'Labs'];
    return '${prefixes[random.nextInt(prefixes.length)]} ${suffixes[random.nextInt(suffixes.length)]} Pvt Ltd';
  }

  static String _generateRandomAddress(String state, String pin, math.Random random) {
    final floor = random.nextInt(12) + 1;
    final wings = ['A', 'B', 'C', 'D'];
    final wing = wings[random.nextInt(wings.length)];
    final parks = ['Techno Park', 'Business Hub', 'IT Plaza', 'Fortune Tower', 'Cyber City'];
    final park = parks[random.nextInt(parks.length)];
    final city = PINCodeGenerator.getCityFromPin(pin) ?? 'Business District';
    
    return 'Floor $floor, Wing $wing, $park, $city, $state - $pin';
  }
}
