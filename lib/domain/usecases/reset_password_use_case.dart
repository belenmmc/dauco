import 'package:dauco/data/repositories/implementation/user_repository.dart';

class ResetPasswordUseCase {
  final UserRepository userRepository;

  ResetPasswordUseCase({required this.userRepository});

  Future<void> execute(String email) async {
    return await userRepository.resetPassword(email);
  }
}
