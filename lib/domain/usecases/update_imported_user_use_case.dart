import 'package:dauco/data/services/imported_user_service.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';

class UpdateImportedUserUseCase {
  final ImportedUserService _importedUserService;

  UpdateImportedUserUseCase({required ImportedUserService importedUserService})
      : _importedUserService = importedUserService;

  Future<void> execute(ImportedUser user) async {
    await _importedUserService.updateUser(user);
  }
}
