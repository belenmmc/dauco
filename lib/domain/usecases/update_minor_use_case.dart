import 'package:dauco/data/repositories/implementation/minor_repository.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

class UpdateMinorUseCase {
  final MinorRepository minorRepository;

  UpdateMinorUseCase({required this.minorRepository});

  Future<void> execute(Minor minor) async {
    return await minorRepository.updateMinor(minor);
  }
}
