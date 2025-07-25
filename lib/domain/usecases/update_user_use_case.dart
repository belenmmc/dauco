import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';

class UpdateUserUseCase {
  final UserRepository userRepository;

  UpdateUserUseCase({required this.userRepository});

  Future<void> execute(UserModel user) async {
    return await userRepository.updateUser(user);
  }
}
