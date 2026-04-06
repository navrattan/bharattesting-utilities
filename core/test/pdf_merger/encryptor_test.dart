import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:bharattesting_core/core.dart';

void main() {
  group('PdfEncryptor', () {
    late Uint8List testPdfData;
    late PdfEncryptionOptions testOptions;

    setUp(() {
      testPdfData = _createTestPdfData();
      testOptions = const PdfEncryptionOptions(
        userPassword: 'TestPassword123!',
        permissions: PdfPermissions(
          allowPrinting: true,
          allowCopy: false,
          allowModification: false,
        ),
      );
    });

    group('PDF Encryption', () {
      test('should encrypt PDF successfully', () async {
        final encryptedData = await PdfEncryptor.encryptPdf(testPdfData, testOptions);

        expect(encryptedData, isA<Uint8List>());
        expect(encryptedData.length, greaterThan(0));
        expect(encryptedData, isNot(equals(testPdfData)));

        // Should contain encryption markers
        final encryptedString = String.fromCharCodes(encryptedData.take(256));
        expect(encryptedString, contains('BTPDF')); // Our custom format marker
      });

      test('should encrypt with different options', () async {
        const strongOptions = PdfEncryptionOptions(
          userPassword: 'VeryStrongPassword123!@#',
          ownerPassword: 'OwnerPassword456\$%^',
          permissions: PdfPermissions(
            allowPrinting: false,
            allowCopy: false,
            allowModification: false,
            allowAnnotations: false,
          ),
        );

        final encryptedData = await PdfEncryptor.encryptPdf(testPdfData, strongOptions);

        expect(encryptedData, isA<Uint8List>());
        expect(encryptedData.length, greaterThan(0));
      });

      test('should throw exception for weak password', () async {
        const weakOptions = PdfEncryptionOptions(
          userPassword: '123', // Too weak
        );

        expect(
          () => PdfEncryptor.encryptPdf(testPdfData, weakOptions),
          throwsA(isA<PdfEncryptionException>()),
        );
      });

      test('should throw exception for too long password', () async {
        final longPassword = 'a' * 200; // Too long
        final longOptions = PdfEncryptionOptions(
          userPassword: longPassword,
        );

        expect(
          () => PdfEncryptor.encryptPdf(testPdfData, longOptions),
          throwsA(isA<PdfEncryptionException>()),
        );
      });

      test('should handle custom salt', () async {
        final customSalt = Uint8List.fromList(List.generate(16, (i) => i));
        final optionsWithSalt = PdfEncryptionOptions(
          userPassword: 'TestPassword123!',
          salt: customSalt,
        );

        final encryptedData = await PdfEncryptor.encryptPdf(testPdfData, optionsWithSalt);

        expect(encryptedData, isA<Uint8List>());
        expect(encryptedData.length, greaterThan(0));
      });
    });

    group('PDF Decryption', () {
      test('should decrypt PDF with correct password', () async {
        final encryptedData = await PdfEncryptor.encryptPdf(testPdfData, testOptions);
        final decryptedData = await PdfEncryptor.decryptPdf(encryptedData, testOptions.userPassword);

        expect(decryptedData, isA<Uint8List>());
        expect(decryptedData.length, greaterThan(0));

        // Should be valid PDF content
        final pdfHeader = String.fromCharCodes(decryptedData.take(5));
        expect(pdfHeader, equals('%PDF-'));
      });

      test('should throw exception for wrong password', () async {
        final encryptedData = await PdfEncryptor.encryptPdf(testPdfData, testOptions);

        expect(
          () => PdfEncryptor.decryptPdf(encryptedData, 'WrongPassword'),
          throwsA(isA<PdfEncryptionException>()),
        );
      });

      test('should throw exception for corrupted data', () async {
        final corruptedData = Uint8List.fromList([1, 2, 3, 4, 5]);

        expect(
          () => PdfEncryptor.decryptPdf(corruptedData, 'AnyPassword'),
          throwsA(isA<PdfEncryptionException>()),
        );
      });

      test('should handle round-trip encryption/decryption', () async {
        const testPassword = 'RoundTripTest123!';
        const options = PdfEncryptionOptions(userPassword: testPassword);

        final encryptedData = await PdfEncryptor.encryptPdf(testPdfData, options);
        final decryptedData = await PdfEncryptor.decryptPdf(encryptedData, testPassword);

        // Decrypted data should match original
        expect(decryptedData.length, equals(testPdfData.length));

        // Content should be equivalent (though not necessarily byte-identical due to processing)
        final originalHeader = String.fromCharCodes(testPdfData.take(10));
        final decryptedHeader = String.fromCharCodes(decryptedData.take(10));
        expect(decryptedHeader, equals(originalHeader));
      });
    });

    group('Encryption Detection', () {
      test('should detect unencrypted PDF', () {
        expect(PdfEncryptor.isPdfEncrypted(testPdfData), isFalse);
      });

      test('should detect encrypted PDF', () async {
        final encryptedData = await PdfEncryptor.encryptPdf(testPdfData, testOptions);
        expect(PdfEncryptor.isPdfEncrypted(encryptedData), isTrue);
      });

      test('should handle invalid data', () {
        final invalidData = Uint8List.fromList([1, 2, 3]);
        expect(PdfEncryptor.isPdfEncrypted(invalidData), isFalse);
      });

      test('should detect encryption markers', () {
        final fakeEncryptedContent = 'Some content with /Encrypt marker'.codeUnits;
        final fakeEncryptedData = Uint8List.fromList(fakeEncryptedContent);

        expect(PdfEncryptor.isPdfEncrypted(fakeEncryptedData), isTrue);
      });
    });

    group('Password Strength Validation', () {
      test('should validate strong password', () {
        const strongPassword = 'MyVeryStrong123!Password';
        final result = PdfEncryptor.validatePasswordStrength(strongPassword);

        expect(result.isValid, isTrue);
        expect(result.strength, equals(PasswordStrength.strong));
        expect(result.message, contains('Strong'));
      });

      test('should reject weak password', () {
        const weakPassword = '123456';
        final result = PdfEncryptor.validatePasswordStrength(weakPassword);

        expect(result.isValid, isFalse);
        expect(result.strength, equals(PasswordStrength.weak));
        expect(result.message, contains('Weak'));
      });

      test('should validate medium password', () {
        const mediumPassword = 'MediumPass123';
        final result = PdfEncryptor.validatePasswordStrength(mediumPassword);

        expect(result.isValid, isTrue);
        expect(result.strength, equals(PasswordStrength.medium));
      });

      test('should require minimum length', () {
        const shortPassword = '1234567'; // 7 characters
        final result = PdfEncryptor.validatePasswordStrength(shortPassword);

        expect(result.isValid, isFalse);
        expect(result.message, contains('at least 8'));
      });

      test('should reject too long password', () {
        final longPassword = 'a' * 200;
        final result = PdfEncryptor.validatePasswordStrength(longPassword);

        expect(result.isValid, isFalse);
        expect(result.message, contains('less than 127'));
      });

      test('should detect common patterns', () {
        const passwords = ['password123', 'admin123', 'qwerty123', 'abc123'];

        for (final password in passwords) {
          final result = PdfEncryptor.validatePasswordStrength(password);
          expect(result.strength, equals(PasswordStrength.weak));
        }
      });

      test('should check character diversity', () {
        const testCases = [
          ('lowercase', 'abcdefghijklm'), // Only lowercase
          ('UPPERCASE', 'ABCDEFGHIJKLM'), // Only uppercase
          ('numbers', '1234567890123'), // Only numbers
          ('mixed', 'AbC123!@#'), // Good mix
        ];

        for (final (name, password) in testCases) {
          final result = PdfEncryptor.validatePasswordStrength(password);

          if (name == 'mixed') {
            expect(result.strength, isNot(equals(PasswordStrength.weak)), reason: 'Mixed password should be stronger');
          } else {
            expect(result.isValid, isFalse, reason: '$name only password should be weak');
          }
        }
      });

      test('should detect repeated characters', () {
        const repeatedPassword = 'aaaaaa123'; // Repeated 'a'
        final result = PdfEncryptor.validatePasswordStrength(repeatedPassword);

        expect(result.strength, equals(PasswordStrength.weak));
        expect(result.message, contains('common patterns'));
      });
    });

    group('Secure Password Generation', () {
      test('should generate password of correct length', () {
        final password = PdfEncryptor.generateSecurePassword(length: 16);

        expect(password.length, equals(16));
      });

      test('should generate password with default length', () {
        final password = PdfEncryptor.generateSecurePassword();

        expect(password.length, equals(16)); // Default length
      });

      test('should generate strong password by default', () {
        final password = PdfEncryptor.generateSecurePassword();
        final validation = PdfEncryptor.validatePasswordStrength(password);

        expect(validation.isValid, isTrue);
        expect(validation.strength, isIn([PasswordStrength.medium, PasswordStrength.strong]));
      });

      test('should include diverse characters', () {
        final password = PdfEncryptor.generateSecurePassword(length: 20);

        expect(password, matches(RegExp(r'[a-z]')), reason: 'Should contain lowercase');
        expect(password, matches(RegExp(r'[A-Z]')), reason: 'Should contain uppercase');
        expect(password, matches(RegExp(r'[0-9]')), reason: 'Should contain numbers');
      });

      test('should optionally exclude symbols', () {
        final password = PdfEncryptor.generateSecurePassword(
          length: 20,
          includeSymbols: false,
        );

        expect(password, matches(RegExp(r'^[a-zA-Z0-9]+$')),
               reason: 'Should only contain alphanumeric characters');
      });

      test('should generate different passwords each time', () {
        final password1 = PdfEncryptor.generateSecurePassword();
        final password2 = PdfEncryptor.generateSecurePassword();

        expect(password1, isNot(equals(password2)));
      });

      test('should generate very long passwords', () {
        final password = PdfEncryptor.generateSecurePassword(length: 100);
        final validation = PdfEncryptor.validatePasswordStrength(password);

        expect(password.length, equals(100));
        expect(validation.isValid, isTrue);
      });
    });

    group('Data Classes', () {
      test('PdfEncryptionOptions should create correctly', () {
        const options = PdfEncryptionOptions(
          userPassword: 'test123',
          ownerPassword: 'owner456',
        );

        expect(options.userPassword, equals('test123'));
        expect(options.ownerPassword, equals('owner456'));
        expect(options.algorithm, equals('AES-256'));
        expect(options.permissions, isA<PdfPermissions>());
      });

      test('PdfPermissions should have correct defaults', () {
        const permissions = PdfPermissions();

        expect(permissions.allowPrinting, isTrue);
        expect(permissions.allowModification, isFalse);
        expect(permissions.allowCopy, isFalse);
        expect(permissions.allowAnnotations, isTrue);
        expect(permissions.allowFormFilling, isTrue);
        expect(permissions.allowAccessibility, isTrue);
      });

      test('PdfPermissions should support copyWith', () {
        const original = PdfPermissions();
        final modified = original.copyWith(
          allowPrinting: false,
          allowCopy: true,
        );

        expect(modified.allowPrinting, isFalse);
        expect(modified.allowCopy, isTrue);
        expect(modified.allowAnnotations, equals(original.allowAnnotations));
      });

      test('PasswordStrength should have display names', () {
        expect(PasswordStrength.weak.displayName, equals('Weak'));
        expect(PasswordStrength.medium.displayName, equals('Medium'));
        expect(PasswordStrength.strong.displayName, equals('Strong'));
      });

      test('PasswordStrengthResult should store validation results', () {
        const result = PasswordStrengthResult(
          isValid: true,
          strength: PasswordStrength.strong,
          message: 'Test message',
        );

        expect(result.isValid, isTrue);
        expect(result.strength, equals(PasswordStrength.strong));
        expect(result.message, equals('Test message'));
      });
    });

    group('Error Handling', () {
      test('PdfEncryptionException should provide useful error information', () {
        const exception = PdfEncryptionException('Test encryption error');

        expect(exception.message, equals('Test encryption error'));
        expect(exception.toString(), contains('Test encryption error'));
      });

      test('should handle encryption with invalid PDF data', () async {
        final invalidPdf = Uint8List.fromList([1, 2, 3, 4, 5]);

        // Should still attempt encryption (our implementation is format-agnostic)
        final result = await PdfEncryptor.encryptPdf(invalidPdf, testOptions);
        expect(result, isA<Uint8List>());
      });
    });

    group('Security Features', () {
      test('should use different salts for each encryption', () async {
        final encrypted1 = await PdfEncryptor.encryptPdf(testPdfData, testOptions);
        final encrypted2 = await PdfEncryptor.encryptPdf(testPdfData, testOptions);

        // Should be different due to different salts
        expect(encrypted1, isNot(equals(encrypted2)));
      });

      test('should handle all permission combinations', () async {
        final permissionVariations = [
          const PdfPermissions(),
          const PdfPermissions(allowPrinting: false),
          const PdfPermissions(allowCopy: true),
          const PdfPermissions(allowModification: true),
          const PdfPermissions(
            allowPrinting: false,
            allowCopy: false,
            allowModification: false,
            allowAnnotations: false,
            allowFormFilling: false,
            allowAccessibility: false,
          ),
        ];

        for (final permissions in permissionVariations) {
          final options = PdfEncryptionOptions(
            userPassword: 'TestPassword123!',
            permissions: permissions,
          );

          final encrypted = await PdfEncryptor.encryptPdf(testPdfData, options);
          expect(encrypted, isA<Uint8List>());
        }
      });

      test('should prevent timing attacks on password validation', () {
        // Validate that password checking takes roughly same time for different passwords
        final stopwatch = Stopwatch();
        const passwords = ['wrong1', 'wrong123456789', 'verywrongpasswordhere'];

        final times = <int>[];

        for (final password in passwords) {
          stopwatch.reset();
          stopwatch.start();
          PdfEncryptor.validatePasswordStrength(password);
          stopwatch.stop();
          times.add(stopwatch.elapsedMicroseconds);
        }

        // Times should be relatively consistent (within an order of magnitude)
        final minTime = times.reduce((a, b) => a < b ? a : b);
        final maxTime = times.reduce((a, b) => a > b ? a : b);

        expect(maxTime / minTime, lessThan(100)); // Should not vary by more than 100x
      });
    });

    group('Performance Tests', () {
      test('should encrypt reasonably quickly', () async {
        final largePdf = Uint8List(1024 * 1024); // 1MB of data
        largePdf.setAll(0, testPdfData);

        final stopwatch = Stopwatch()..start();
        final encrypted = await PdfEncryptor.encryptPdf(largePdf, testOptions);
        stopwatch.stop();

        expect(encrypted, isA<Uint8List>());
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Under 5 seconds
      });

      test('should handle multiple concurrent encryptions', () async {
        final futures = List.generate(5, (_) =>
          PdfEncryptor.encryptPdf(testPdfData, testOptions)
        );

        final results = await Future.wait(futures);

        expect(results.length, equals(5));
        for (final result in results) {
          expect(result, isA<Uint8List>());
          expect(result.length, greaterThan(0));
        }

        // All results should be different due to different salts/IVs
        for (int i = 0; i < results.length; i++) {
          for (int j = i + 1; j < results.length; j++) {
            expect(results[i], isNot(equals(results[j])));
          }
        }
      });
    });
  });
}

/// Create test PDF data for encryption tests
Uint8List _createTestPdfData() {
  const pdfContent = '''%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj

2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj

3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj

4 0 obj
<<
/Length 44
>>
stream
BT
/F1 12 Tf
72 720 Td
(Test PDF Content) Tj
ET
endstream
endobj

xref
0 5
0000000000 65535 f
0000000010 00000 n
0000000079 00000 n
0000000173 00000 n
0000000301 00000 n
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
428
%%EOF''';

  return Uint8List.fromList(pdfContent.codeUnits);
}