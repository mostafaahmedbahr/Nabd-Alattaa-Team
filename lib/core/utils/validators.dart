class AppValidators {
  AppValidators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    return null;
  }

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'هذا الحقل'} مطلوب';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final phoneRegex = RegExp(r'^0[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'رقم الهاتف غير صالح (01XXXXXXXXX)';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  static String? age(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'العمر مطلوب';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'العمر يجب أن يكون رقماً';
    }
    if (age < 18 || age > 100) {
      return 'العمر يجب أن يكون بين 18 و 100';
    }
    return null;
  }

  static String? department(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'القسم مطلوب';
    }
    return null;
  }
}
