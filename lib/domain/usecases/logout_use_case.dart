import 'package:dauco/data/repositories/implementation/user_repository.dart';

class LogoutUseCase {
  final UserRepository userRepository;

  LogoutUseCase({required this.userRepository});

  Future<void> execute() async {
    return await userRepository.logout();
  }
}
