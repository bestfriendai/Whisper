import 'package:flutter_test/flutter_test.dart';
import 'package:whisperdate/core/validators.dart';

void main() {
  group('Email Validation', () {
    test('accepts valid email addresses', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('test.user@example.co.uk'), isNull);
      expect(Validators.validateEmail('user+tag@example.com'), isNull);
    });

    test('rejects invalid email addresses', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail('notanemail'), isNotNull);
      expect(Validators.validateEmail('missing@domain'), isNotNull);
      expect(Validators.validateEmail('@example.com'), isNotNull);
      expect(Validators.validateEmail('user@'), isNotNull);
    });

    test('rejects emails that are too long', () {
      final longEmail = 'a' * 250 + '@example.com';
      expect(Validators.validateEmail(longEmail), isNotNull);
    });
  });

  group('Password Validation', () {
    test('accepts valid passwords', () {
      expect(Validators.validatePassword('ValidPass123!'), isNull);
      expect(Validators.validatePassword('Another@Valid1'), isNull);
    });

    test('rejects passwords that are too short', () {
      expect(Validators.validatePassword('Short1!'), isNotNull);
    });

    test('rejects passwords without uppercase letters', () {
      expect(Validators.validatePassword('lowercase123!'), isNotNull);
    });

    test('rejects passwords without lowercase letters', () {
      expect(Validators.validatePassword('UPPERCASE123!'), isNotNull);
    });

    test('rejects passwords without numbers', () {
      expect(Validators.validatePassword('NoNumbers!'), isNotNull);
    });

    test('rejects passwords without special characters', () {
      expect(Validators.validatePassword('NoSpecial123'), isNotNull);
    });
  });

  group('Username Validation', () {
    test('accepts valid usernames', () {
      expect(Validators.validateUsername('user123'), isNull);
      expect(Validators.validateUsername('test_user'), isNull);
      expect(Validators.validateUsername('abc'), isNull);
    });

    test('rejects invalid usernames', () {
      expect(Validators.validateUsername('ab'), isNotNull); // Too short
      expect(Validators.validateUsername('a' * 21), isNotNull); // Too long
      expect(Validators.validateUsername('user@123'), isNotNull); // Invalid character
      expect(Validators.validateUsername('user name'), isNotNull); // Space
    });
  });

  group('Age Validation', () {
    test('accepts valid ages', () {
      expect(Validators.validateAge('18'), isNull);
      expect(Validators.validateAge('25'), isNull);
      expect(Validators.validateAge('65'), isNull);
    });

    test('rejects invalid ages', () {
      expect(Validators.validateAge('17'), isNotNull); // Too young
      expect(Validators.validateAge('150'), isNotNull); // Unrealistic
      expect(Validators.validateAge('abc'), isNotNull); // Not a number
      expect(Validators.validateAge(''), isNotNull); // Empty
    });
  });

  group('Review Content Validation', () {
    test('accepts valid review content', () {
      expect(Validators.validateReviewContent('This is a valid review content.'), isNull);
      expect(Validators.validateReviewContent('A' * 50), isNull);
    });

    test('rejects invalid review content', () {
      expect(Validators.validateReviewContent('Too short'), isNotNull);
      expect(Validators.validateReviewContent('A' * 5001), isNotNull); // Too long
      expect(Validators.validateReviewContent(''), isNotNull); // Empty
    });

    test('sanitizes HTML tags', () {
      final input = '<script>alert("XSS")</script>Normal text';
      final sanitized = Validators.sanitizeInput(input);
      expect(sanitized.contains('<script>'), isFalse);
      expect(sanitized.contains('Normal text'), isTrue);
    });
  });

  group('Input Sanitization', () {
    test('removes HTML tags', () {
      expect(
        Validators.sanitizeInput('<p>Hello</p>'),
        equals('Hello'),
      );
      expect(
        Validators.sanitizeInput('<script>alert("xss")</script>'),
        equals('alert("xss")'),
      );
    });

    test('removes excessive whitespace', () {
      expect(
        Validators.sanitizeInput('  Hello   World  '),
        equals('Hello World'),
      );
    });

    test('removes control characters', () {
      expect(
        Validators.sanitizeInput('Hello\x00World'),
        equals('HelloWorld'),
      );
    });
  });

  group('Phone Number Validation', () {
    test('accepts valid phone numbers', () {
      expect(Validators.validatePhoneNumber('+1234567890'), isNull);
      expect(Validators.validatePhoneNumber('1234567890'), isNull);
      expect(Validators.validatePhoneNumber('+44 20 1234 5678'), isNull);
    });

    test('rejects invalid phone numbers', () {
      expect(Validators.validatePhoneNumber(''), isNotNull);
      expect(Validators.validatePhoneNumber('123'), isNotNull);
      expect(Validators.validatePhoneNumber('abcdefghij'), isNotNull);
    });
  });

  group('Credit Card Validation', () {
    test('accepts valid credit card numbers', () {
      // Test card numbers (these are valid test numbers)
      expect(Validators.validateCreditCard('4111111111111111'), isNull); // Visa
      expect(Validators.validateCreditCard('5555555555554444'), isNull); // Mastercard
      expect(Validators.validateCreditCard('378282246310005'), isNull); // Amex
    });

    test('rejects invalid credit card numbers', () {
      expect(Validators.validateCreditCard(''), isNotNull);
      expect(Validators.validateCreditCard('1234567890123456'), isNotNull); // Fails Luhn
      expect(Validators.validateCreditCard('abcd'), isNotNull);
    });
  });

  group('Date Validation', () {
    test('accepts valid dates', () {
      expect(Validators.validateDate('2023-01-01'), isNull);
      expect(Validators.validateDate('2020-12-31'), isNull);
    });

    test('rejects future dates', () {
      final futureDate = DateTime.now().add(Duration(days: 1)).toString();
      expect(Validators.validateDate(futureDate), isNotNull);
    });

    test('rejects invalid date formats', () {
      expect(Validators.validateDate('not-a-date'), isNotNull);
      expect(Validators.validateDate('31/12/2020'), isNotNull);
    });
  });

  group('URL Validation', () {
    test('accepts valid URLs', () {
      expect(Validators.validateUrl('https://example.com'), isNull);
      expect(Validators.validateUrl('http://www.example.com/path'), isNull);
      expect(Validators.validateUrl('https://sub.example.co.uk'), isNull);
    });

    test('accepts empty URLs as they are optional', () {
      expect(Validators.validateUrl(''), isNull);
      expect(Validators.validateUrl(null), isNull);
    });

    test('rejects invalid URLs', () {
      expect(Validators.validateUrl('not a url'), isNotNull);
      expect(Validators.validateUrl('ftp://example.com'), isNotNull);
      expect(Validators.validateUrl('//example.com'), isNotNull);
    });
  });
}