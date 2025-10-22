import 'package:dauco/data/repositories/implementation/user_repository.dart';

class UpdatePasswordUseCase {
  final UserRepository userRepository;

  UpdatePasswordUseCase({required this.userRepository});

  Future<void> execute(String newPassword) async {
    return await userRepository.updatePassword(newPassword);
  }
}
