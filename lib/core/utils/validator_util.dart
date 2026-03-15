class ValidatorUtil {
  static String? validateEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email cannot be empty';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? validateMatchPassword(
    String? confirmPassword,
    String? originalPassword,
  ) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? validateHexColor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Mã màu không được để trống";
    }

    final cleanColor = value
        .trim()
        .replaceAll('#', '')
        .toUpperCase()
        .replaceAll('0X', '');

    if (cleanColor.length != 6 && cleanColor.length != 8) {
      return "Mã màu phải có 6 hoặc 8 ký tự Hex";
    }

    final hexRegex = RegExp(r'^[0-9A-F]+$');
    if (!hexRegex.hasMatch(cleanColor)) {
      return "Mã màu chỉ chứa ký tự 0-9 và A-F";
    }

    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) return 'Giá bán không được để trống';
    final price = double.tryParse(value);
    if (price == null) return 'Giá phải là một con số';
    if (price <= 0) return 'Giá bán phải lớn hơn 0';
    return null;
  }

  static String? validateStock(String? value) {
    if (value == null || value.isEmpty) return 'Số lượng không được để trống';
    final stock = int.tryParse(value);
    if (stock == null) return 'Số lượng phải là số nguyên';
    if (stock < 0) return 'Tồn kho không được nhỏ hơn 0';
    return null;
  }

  static String? validateLength(
    String? value,
    String fieldName,
    int min,
    int max,
  ) {
    if (value == null || value.trim().isEmpty)
      return '$fieldName không được để trống';
    if (value.length < min) return '$fieldName tối thiểu $min ký tự';
    if (value.length > max) return '$fieldName tối đa $max ký tự';
    return null;
  }
}
