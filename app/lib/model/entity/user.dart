import 'package:shared/user.dart';

class User extends BaseUser {
  User({
    required super.id,
    required super.companyId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  User.fromBaseUser({required super.user}) : super.fromBaseUser();
}

class UserFactory extends BaseUserFactory<User> {
  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromBaseUser(user: super.fromJson(json));
  }
}
