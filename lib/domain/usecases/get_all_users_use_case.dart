import 'package:dauco/data/repositories/implementation/user_repository.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';

class GetAllUsersUseCase {
  final UserRepository userRepository;

  GetAllUsersUseCase({required this.userRepository});

  Future<List<UserModel>> execute(int page) async {
    return await userRepository.getAllUsers(page);
  }
}
