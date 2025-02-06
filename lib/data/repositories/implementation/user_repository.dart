import 'package:dauco/data/repositories/user_repository_interface.dart';
import 'package:dauco/data/services/user_service.dart';

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
  Future<void> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
