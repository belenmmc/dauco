import 'package:dauco/data/services/imported_user_service.dart';

class ValidateManagerIdUseCase {
  final ImportedUserService _importedUserService;

  ValidateManagerIdUseCase({required ImportedUserService importedUserService})
      : _importedUserService = importedUserService;

  Future<bool> execute(int managerId) async {
    return await _importedUserService.existsManagerId(managerId);
  }
}
