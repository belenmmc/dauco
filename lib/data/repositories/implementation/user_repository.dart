import 'package:dauco/data/repositories/user_repository_interface.dart';
import 'package:dauco/data/services/user_service.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';

class UserRepository implements UserRepositoryInterface {
  UserService userService = UserService();

  UserRepository({required this.userService});

  @override
  Future<void> login(String email, String password) async {
    await userService.login(email, password);
  }

  @override
  Future<void> logout() {
    return userService.logout();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    return await userService.getCurrentUser();
  }

  @override
  Future<void> register(String email, String password, int managerId,
      String name, String role) async {
    await userService.register(email, password, managerId, name, role);
  }

  @override
  Future<void> resetPassword(String email) async {
    await userService.resetPassword(email);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await userService.updatePassword(newPassword);
  }

  @override
  Future<void> deleteUser(String email) {
    return userService.deleteUser(email);
  }

  @override
  Future<void> updateUser(UserModel user) {
    return userService.editUser(user);
  }

  @override
  Future<List<UserModel>> getAllUsers(
    int page, {
    String? filterName,
    String? filterEmail,
    String? filterRole,
    String? filterManagerId,
  }) {
    return userService.getAllUsers(
      page,
      filterName: filterName,
      filterEmail: filterEmail,
      filterRole: filterRole,
      filterManagerId: filterManagerId,
    );
  }
}
