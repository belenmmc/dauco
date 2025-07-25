import 'package:dauco/domain/entities/user_model.entity.dart';

class UserMapper {
  static UserModel toDomain(Map<String, dynamic> user) {
    return UserModel(
      email: user['email'],
      name: user['name'],
      managerId: user['manager_id'],
      role: user['role'],
    );
  }
}
