import 'package:dauco/data/services/imported_user_service.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';

class GetImportedUserUseCase {
  final ImportedUserService _importedUserService;

  GetImportedUserUseCase({required ImportedUserService importedUserService})
      : _importedUserService = importedUserService;

  Future<ImportedUser?> execute(int managerId) async {
    return await _importedUserService.getUserByManagerId(managerId);
  }
}
