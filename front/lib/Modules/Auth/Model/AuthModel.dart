class AuthModel {
  String email;
  String password;

  AuthModel(this.email, this.password);

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}