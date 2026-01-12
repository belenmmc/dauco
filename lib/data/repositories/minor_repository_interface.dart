import 'package:dauco/domain/entities/minor.entity.dart';

abstract class MinorRepositoryInterface {
  Future<List<Minor>> getAllMinors(
    int page, {
    String? filterManagerId,
    String? filterName,
    String? filterSex,
    String? filterZipCode,
    DateTime? filterBirthdateFrom,
    DateTime? filterBirthdateTo,
  });

  Future<List<Minor>> getAllMinorsForExport();

  Future<void> updateMinor(Minor minor);

  Future<void> deleteMinor(String minorId);
}
