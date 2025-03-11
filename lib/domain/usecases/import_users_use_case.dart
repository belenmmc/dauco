import 'package:dauco/data/repositories/implementation/import_repository.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';

class ImportUsersUseCase {
  final ImportRepository importRepository;

  ImportUsersUseCase({required this.importRepository});

  Future<List<ImportedUser>> execute(file,
      {int page = 1, int pageSize = 10}) async {
    return await importRepository.getUsers(file, page, pageSize);
  }
}
