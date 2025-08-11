import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? id;
  final String? email;
  final String? token;
  final DateTime? createdAt;

  const User({this.id, this.email, this.token, this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({String? id, String? email, String? token, DateTime? createdAt}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
