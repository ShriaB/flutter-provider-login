class Validators {
  static bool isEmailFormatValid(String email) {
    if (email.isEmpty) return false;
    RegExp regex = RegExp(r'^.+(\..+)*@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+$');
    return regex.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length < 6) return false;
    return true;
  }
}
