import 'package:dauco/data/repositories/implementation/minor_repository.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

class GetAllMinorsUseCase {
  final MinorRepository minorRepository;

  GetAllMinorsUseCase({required this.minorRepository});

  Future<List<Minor>> execute(
    int page, {
    String? filterManagerId,
    String? filterName,
    String? filterSex,
    String? filterZipCode,
    DateTime? filterBirthdateFrom,
    DateTime? filterBirthdateTo,
  }) async {
    return await minorRepository.getAllMinors(
      page,
      filterManagerId: filterManagerId,
      filterName: filterName,
      filterSex: filterSex,
      filterZipCode: filterZipCode,
      filterBirthdateFrom: filterBirthdateFrom,
      filterBirthdateTo: filterBirthdateTo,
    );
  }
}
