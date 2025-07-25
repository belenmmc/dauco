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
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    return await userService.getCurrentUser();
  }

  @override
  Future<void> register(
      String email, String password, int managerId, String name) async {
    await userService.register(email, password, managerId, name);
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
  Future<List<UserModel>> getAllUsers(int page) {
    return userService.getAllUsers(page);
  }
}
