import 'package:dauco/data/repositories/implementation/minor_repository.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

class GetAllMinorsForExportUseCase {
  final MinorRepository minorRepository;

  GetAllMinorsForExportUseCase({required this.minorRepository});

  Future<List<Minor>> execute() async {
    return await minorRepository.getAllMinorsForExport();
  }
}
