class LoginRequest {
  String email;
  String password;

  LoginRequest(this.email, this.password);
}

class RegisterRequest {
  String userName;
  //String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;
  String preferredCurrency;
  String preferredLanguage;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.userName, // this.countryMobileCode,
    required this.mobileNumber,
    required this.profilePicture,
    required this.preferredCurrency,
    required this.preferredLanguage,
  });
}
