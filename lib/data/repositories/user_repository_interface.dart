import 'package:dauco/domain/entities/user_model.entity.dart';

abstract class UserRepositoryInterface {
  Future<void> login(String email, String password);

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<void> register(
      String email, String password, int managerId, String name, String role);

  Future<void> resetPassword(String email);

  Future<void> updatePassword(String newPassword);

  Future<void> updateUser(UserModel user);

  Future<void> deleteUser(String email);

  Future<List<UserModel>> getAllUsers(
    int page, {
    String? filterName,
    String? filterEmail,
    String? filterRole,
    String? filterManagerId,
  });
}
