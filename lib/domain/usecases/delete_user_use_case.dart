import 'package:dauco/data/repositories/implementation/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository userRepository;

  DeleteUserUseCase({required this.userRepository});

  Future<void> execute(String email) async {
    return await userRepository.deleteUser(email);
  }
}
