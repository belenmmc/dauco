import 'package:dauco/data/repositories/implementation/minor_repository.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

class GetAllMinorsUseCase {
  final MinorRepository minorRepository;

  GetAllMinorsUseCase({required this.minorRepository});

  Future<List<Minor>> execute(int page) async {
    return await minorRepository.getAllMinors(page);
  }
}
