/// Indian state codes and mappings for GSTIN, PIN codes, and CIN
library state_codes;

/// GSTIN state code mappings (01-37)
///
/// Used in GSTIN first two digits and CIN state validation.
/// Some codes are reserved or discontinued but included for completeness.
class StateCodes {
  const StateCodes._();

  /// Map of GSTIN state codes to state names
  static const Map<int, String> gstinStateCodes = {
    1: 'Jammu and Kashmir',
    2: 'Himachal Pradesh',
    3: 'Punjab',
    4: 'Chandigarh',
    5: 'Uttarakhand',
    6: 'Haryana',
    7: 'Delhi',
    8: 'Rajasthan',
    9: 'Uttar Pradesh',
    10: 'Bihar',
    11: 'Sikkim',
    12: 'Arunachal Pradesh',
    13: 'Nagaland',
    14: 'Manipur',
    15: 'Mizoram',
    16: 'Tripura',
    17: 'Meghalaya',
    18: 'Assam',
    19: 'West Bengal',
    20: 'Jharkhand',
    21: 'Odisha',
    22: 'Chhattisgarh',
    23: 'Madhya Pradesh',
    24: 'Gujarat',
    25: 'Dadra and Nagar Haveli and Daman and Diu',
    26: 'Maharashtra',
    27: 'Karnataka',
    28: 'Goa',
    29: 'Lakshadweep',
    30: 'Kerala',
    31: 'Tamil Nadu',
    32: 'Puducherry',
    33: 'Andhra Pradesh',
    34: 'Telangana',
    35: 'Andaman and Nicobar Islands',
    36: 'Ladakh',
    37: 'Other Territory', // Reserved for future use
  };

  /// Map of state names to GSTIN codes (reverse lookup)
  static const Map<String, int> stateNameToCode = {
    'Jammu and Kashmir': 1,
    'Himachal Pradesh': 2,
    'Punjab': 3,
    'Chandigarh': 4,
    'Uttarakhand': 5,
    'Haryana': 6,
    'Delhi': 7,
    'Rajasthan': 8,
    'Uttar Pradesh': 9,
    'Bihar': 10,
    'Sikkim': 11,
    'Arunachal Pradesh': 12,
    'Nagaland': 13,
    'Manipur': 14,
    'Mizoram': 15,
    'Tripura': 16,
    'Meghalaya': 17,
    'Assam': 18,
    'West Bengal': 19,
    'Jharkhand': 20,
    'Odisha': 21,
    'Chhattisgarh': 22,
    'Madhya Pradesh': 23,
    'Gujarat': 24,
    'Dadra and Nagar Haveli and Daman and Diu': 25,
    'Maharashtra': 26,
    'Karnataka': 27,
    'Goa': 28,
    'Lakshadweep': 29,
    'Kerala': 30,
    'Tamil Nadu': 31,
    'Puducherry': 32,
    'Andhra Pradesh': 33,
    'Telangana': 34,
    'Andaman and Nicobar Islands': 35,
    'Ladakh': 36,
    'Other Territory': 37,
  };

  /// PIN code ranges for major states
  /// Format: state_name -> [start_pin, end_pin]
  static const Map<String, List<int>> statePinRanges = {
    'Jammu and Kashmir': [180001, 194404],
    'Himachal Pradesh': [171001, 177601],
    'Punjab': [140001, 160104],
    'Chandigarh': [160001, 160102],
    'Uttarakhand': [246001, 263680],
    'Haryana': [121001, 136157],
    'Delhi': [110001, 110097],
    'Rajasthan': [301001, 345034],
    'Uttar Pradesh': [201001, 285223],
    'Bihar': [800001, 855117],
    'Sikkim': [737101, 737139],
    'Arunachal Pradesh': [790001, 792131],
    'Nagaland': [797001, 798627],
    'Manipur': [795001, 795149],
    'Mizoram': [796001, 796901],
    'Tripura': [799001, 799290],
    'Meghalaya': [793001, 794115],
    'Assam': [781001, 788931],
    'West Bengal': [700001, 743632],
    'Jharkhand': [814001, 835325],
    'Odisha': [751001, 770076],
    'Chhattisgarh': [490001, 497778],
    'Madhya Pradesh': [450001, 488448],
    'Gujarat': [360001, 396590],
    'Dadra and Nagar Haveli and Daman and Diu': [396001, 396240],
    'Maharashtra': [400001, 445402],
    'Karnataka': [560001, 591346],
    'Goa': [403001, 403806],
    'Lakshadweep': [682551, 682559],
    'Kerala': [670001, 695615],
    'Tamil Nadu': [600001, 643253],
    'Puducherry': [605001, 609609],
    'Andhra Pradesh': [515001, 535594],
    'Telangana': [500001, 509412],
    'Andaman and Nicobar Islands': [744101, 744304],
    'Ladakh': [194101, 194404],
  };

  /// Major cities with their PIN codes
  static const Map<String, Map<String, List<int>>> majorCities = {
    'Delhi': {
      'New Delhi': [110001, 110001],
      'Central Delhi': [110006, 110006],
      'North Delhi': [110007, 110007],
      'South Delhi': [110016, 110016],
      'East Delhi': [110032, 110032],
      'West Delhi': [110018, 110018],
    },
    'Maharashtra': {
      'Mumbai': [400001, 400097],
      'Pune': [411001, 411060],
      'Nagpur': [440001, 440035],
      'Nashik': [422001, 422015],
      'Aurangabad': [431001, 431010],
    },
    'Karnataka': {
      'Bangalore': [560001, 560110],
      'Mysore': [570001, 570029],
      'Mangalore': [575001, 575030],
      'Hubli': [580001, 580032],
    },
    'Tamil Nadu': {
      'Chennai': [600001, 600126],
      'Coimbatore': [641001, 641664],
      'Madurai': [625001, 625022],
      'Trichy': [620001, 620024],
    },
    'West Bengal': {
      'Kolkata': [700001, 700159],
      'Howrah': [711101, 711410],
      'Durgapur': [713201, 713220],
    },
    'Gujarat': {
      'Ahmedabad': [380001, 380061],
      'Surat': [395001, 395010],
      'Vadodara': [390001, 390025],
      'Rajkot': [360001, 360007],
    },
    'Rajasthan': {
      'Jaipur': [302001, 302039],
      'Jodhpur': [342001, 342015],
      'Udaipur': [313001, 313015],
    },
    'Uttar Pradesh': {
      'Lucknow': [226001, 226031],
      'Kanpur': [208001, 208027],
      'Agra': [282001, 282010],
      'Varanasi': [221001, 221010],
    },
  };

  /// Get state name from GSTIN state code
  static String? getStateName(int code) => gstinStateCodes[code];

  /// Get GSTIN state code from state name
  static int? getStateCode(String stateName) => stateNameToCode[stateName];

  /// Get random state code from supported list
  static int getRandomStateCode() {
    // Only use states that are fully supported by PIN/Address generators
    final safeStates = [
      7,  // Delhi
      26, // Maharashtra
      27, // Karnataka
      31, // Tamil Nadu
      34, // Telangana
      19, // West Bengal
      9,  // Uttar Pradesh
      24, // Gujarat
      8,  // Rajasthan
      20, // Jharkhand
      10, // Bihar
      21, // Odisha
      23, // Madhya Pradesh
      3,  // Punjab
      6,  // Haryana
    ];
    final random = Random();
    return safeStates[random.nextInt(safeStates.length)];
  }

  /// Get random PIN code for a state
  static int getRandomPinCode(String stateName) {
    final range = statePinRanges[stateName];
    if (range == null) return 110001; // Default to Delhi

    final start = range[0];
    final end = range[1];
    return start + (end - start) ~/ 2; // Return middle value for consistency
  }

  /// Get state name from PIN code (approximate)
  static String? getStateFromPin(int pinCode) {
    for (final entry in statePinRanges.entries) {
      final range = entry.value;
      if (pinCode >= range[0] && pinCode <= range[1]) {
        return entry.key;
      }
    }
    return null;
  }

  /// Validate if state code is valid for GSTIN
  static bool isValidGSTINStateCode(int code) {
    return gstinStateCodes.containsKey(code) && code != 37;
  }

  /// Get all valid state codes (excluding reserved)
  static List<int> getValidStateCodes() {
    return gstinStateCodes.keys.where((code) => code != 37).toList();
  }
}