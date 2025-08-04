import 'package:dauco/data/repositories/implementation/minor_repository.dart';

class DeleteMinorUseCase {
  final MinorRepository minorRepository;

  DeleteMinorUseCase({required this.minorRepository});

  Future<void> execute(String minorId) async {
    return await minorRepository.deleteMinor(minorId);
  }
}
