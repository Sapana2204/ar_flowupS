class SavedAccount {
  final String username;
  final String password;

  SavedAccount({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
  };

  factory SavedAccount.fromJson(Map<String, dynamic> json) {
    return SavedAccount(
      username: json["username"],
      password: json["password"],
    );
  }
}