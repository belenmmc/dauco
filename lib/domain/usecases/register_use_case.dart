import 'package:dauco/data/repositories/implementation/user_repository.dart';

class RegisterUseCase {
  final UserRepository userRepository;

  RegisterUseCase({required this.userRepository});

  Future<void> execute(
      String email, String password, int managerId, String name) async {
    return await userRepository.register(email, password, managerId, name);
  }
}
