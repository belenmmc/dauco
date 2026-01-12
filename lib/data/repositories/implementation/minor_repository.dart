import 'package:dauco/data/repositories/minor_repository_interface.dart';
import 'package:dauco/data/services/minor_service.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

class MinorRepository implements MinorRepositoryInterface {
  MinorService minorService = MinorService();

  MinorRepository({required this.minorService});

  @override
  Future<List<Minor>> getAllMinors(
    int page, {
    String? filterManagerId,
    String? filterName,
    String? filterSex,
    String? filterZipCode,
    DateTime? filterBirthdateFrom,
    DateTime? filterBirthdateTo,
  }) {
    return minorService.getMinorsPage(
      page,
      filterManagerId: filterManagerId,
      filterName: filterName,
      filterSex: filterSex,
      filterZipCode: filterZipCode,
      filterBirthdateFrom: filterBirthdateFrom,
      filterBirthdateTo: filterBirthdateTo,
    );
  }

  @override
  Future<List<Minor>> getAllMinorsForExport() {
    return minorService.getAllMinorsForExport();
  }

  @override
  Future<void> updateMinor(Minor minor) {
    return minorService.updateMinor(minor);
  }

  @override
  Future<void> deleteMinor(String minorId) {
    return minorService.deleteMinor(minorId);
  }
}
