import 'package:whisperdate/config/environment_config.dart';

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  static final RegExp _usernameRegExp = RegExp(
    r'^[a-zA-Z0-9_]{3,20}$',
  );

  static final RegExp _urlRegExp = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)$',
  );

  static final RegExp _alphaNumericRegExp = RegExp(
    r'^[a-zA-Z0-9\s]+$',
  );

  static final RegExp _htmlTagRegExp = RegExp(
    r'<[^>]*>',
  );

  static final RegExp _sqlInjectionRegExp = RegExp(
    r"(\b(SELECT|INSERT|UPDATE|DELETE|DROP|UNION|CREATE|ALTER|EXEC|EXECUTE|SCRIPT|JAVASCRIPT|EVAL)\b)",
    caseSensitive: false,
  );

  static final RegExp _xssRegExp = RegExp(
    r'(<script|<iframe|javascript:|onerror=|onload=|alert\(|prompt\(|confirm\()',
    caseSensitive: false,
  );

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final sanitized = sanitizeInput(value);
    
    if (!_emailRegExp.hasMatch(sanitized)) {
      return 'Please enter a valid email address';
    }
    
    if (sanitized.length > 254) {
      return 'Email address is too long';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (value.length > 128) {
      return 'Password is too long';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    final sanitized = sanitizeInput(value);
    
    if (sanitized.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    
    if (sanitized.length > 20) {
      return 'Username must be less than 20 characters';
    }
    
    if (!_usernameRegExp.hasMatch(sanitized)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (!_phoneRegExp.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    final sanitized = sanitizeInput(value);
    
    if (sanitized.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (sanitized.length > 50) {
      return 'Name is too long';
    }
    
    if (sanitized.contains(RegExp(r'[0-9]'))) {
      return 'Name cannot contain numbers';
    }
    
    if (_containsMaliciousContent(sanitized)) {
      return 'Invalid characters in name';
    }
    
    return null;
  }

  // Age validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value);
    
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age < 18) {
      return 'You must be at least 18 years old';
    }
    
    if (age > 120) {
      return 'Please enter a valid age';
    }
    
    return null;
  }

  // Review content validation
  static String? validateReviewContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Review content is required';
    }
    
    final sanitized = sanitizeInput(value);
    
    if (sanitized.length < 10) {
      return 'Review must be at least 10 characters long';
    }
    
    if (sanitized.length > 5000) {
      return 'Review is too long (max 5000 characters)';
    }
    
    if (_containsMaliciousContent(sanitized)) {
      return 'Review contains prohibited content';
    }
    
    if (EnvironmentConfig.profanityFilter && _containsProfanity(sanitized)) {
      return 'Please remove inappropriate language';
    }
    
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    
    if (!_urlRegExp.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Input sanitization
  static String sanitizeInput(String input) {
    // Remove HTML tags
    String sanitized = input.replaceAll(_htmlTagRegExp, '');
    
    // Remove excessive whitespace
    sanitized = sanitized.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    // Remove control characters
    sanitized = sanitized.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    
    return sanitized;
  }

  // Check for malicious content
  static bool _containsMaliciousContent(String input) {
    // Check for SQL injection patterns
    if (_sqlInjectionRegExp.hasMatch(input)) {
      return true;
    }
    
    // Check for XSS patterns
    if (_xssRegExp.hasMatch(input)) {
      return true;
    }
    
    return false;
  }

  // Basic profanity check (should be replaced with a proper profanity filter service)
  static bool _containsProfanity(String input) {
    // This is a very basic implementation
    // In production, use a proper profanity detection service
    final profanityList = [
      // Add prohibited words here
      // This list should be maintained separately and loaded from a secure source
    ];
    
    final lowerInput = input.toLowerCase();
    for (final word in profanityList) {
      if (lowerInput.contains(word.toLowerCase())) {
        return true;
      }
    }
    
    return false;
  }

  // Validate and sanitize search query
  static String? validateSearchQuery(String? value) {
    if (value == null || value.isEmpty) {
      return 'Search query is required';
    }
    
    final sanitized = sanitizeInput(value);
    
    if (sanitized.length < 2) {
      return 'Search query must be at least 2 characters';
    }
    
    if (sanitized.length > 100) {
      return 'Search query is too long';
    }
    
    if (_containsMaliciousContent(sanitized)) {
      return 'Invalid search query';
    }
    
    return null;
  }

  // Credit card validation (for future premium features)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }
    
    final cleaned = value.replaceAll(RegExp(r'\s'), '');
    
    if (!RegExp(r'^\d{13,19}$').hasMatch(cleaned)) {
      return 'Invalid credit card number';
    }
    
    // Luhn algorithm check
    if (!_isValidLuhn(cleaned)) {
      return 'Invalid credit card number';
    }
    
    return null;
  }

  static bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool alternate = false;
    
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }

  // Date validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    
    try {
      final date = DateTime.parse(value);
      
      if (date.isAfter(DateTime.now())) {
        return 'Date cannot be in the future';
      }
      
      if (date.isBefore(DateTime(1900))) {
        return 'Invalid date';
      }
      
      return null;
    } catch (e) {
      return 'Invalid date format';
    }
  }

  // Location validation
  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    
    final sanitized = sanitizeInput(value);
    
    if (sanitized.length < 2) {
      return 'Location name is too short';
    }
    
    if (sanitized.length > 100) {
      return 'Location name is too long';
    }
    
    if (_containsMaliciousContent(sanitized)) {
      return 'Invalid location name';
    }
    
    return null;
  }
}