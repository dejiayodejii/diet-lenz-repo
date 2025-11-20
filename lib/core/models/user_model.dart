class UserModel {
  final String id;
  final String name;
  final String email;
  final double walletBalance;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.walletBalance,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    double? walletBalance,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}
