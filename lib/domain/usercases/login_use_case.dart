import 'package:dauco/data/repositories/implementation/user_repository.dart';

class LoginUseCase {
  final UserRepository userRepository;

  LoginUseCase({required this.userRepository});

  Future<void> execute(String email, String password) async {
    return await userRepository.login(email, password);
  }
}
