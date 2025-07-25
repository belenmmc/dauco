import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';

class GetCurrentUserUseCase {
  final UserRepository userRepository;

  GetCurrentUserUseCase({required this.userRepository});

  Future<UserModel> execute() async {
    return await userRepository.getCurrentUser();
  }
}
