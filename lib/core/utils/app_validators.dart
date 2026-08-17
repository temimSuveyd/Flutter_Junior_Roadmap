class AppValidators {
  // محقق البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your e-mail address';
    }
    
    // التعبير المنتظم (Regex) المعتمد لفحص صيغة الإيميل
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null; // المدخل صحيح
  }

  // محقق كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    
    if (value.length < 6) {
      return 'Password must consist of at least 6 characters';
    }
    
    return null; // المدخل صحيح
  }
}
