import 'package:dauco/domain/entities/test.entity.dart';

class TestMapper {
  static Test toDomain(Map<String, dynamic> test) {
    return Test(
      testId: test['test_id'] as int,
      minorId: test['menor_id'] as int,
      registeredAt: DateTime.parse(test['alta'] as String),
      cronologicalAge: test['edad_cronologica'] as String,
      evolutionaryAge: test['edad_evolutiva'] as String,
      mChatTest: test['test_mchat'] as bool,
      progress: test['progreso'] as String,
      activeAreas: test['areas_activas'] as int,
      professionalType: test['tipo_profesional'] as String,
    );
  }

  static Map<String, dynamic> toJson(Test test) {
    return {
      'test_id': test.testId,
      'menor_id': test.minorId,
      'alta': test.registeredAt.toIso8601String(),
      'edad_cronologica': test.cronologicalAge,
      'edad_evolutiva': test.evolutionaryAge,
      'test_mchat': test.mChatTest,
      'progreso': test.progress,
      'areas_activas': test.activeAreas,
      'tipo_profesional': test.professionalType,
    };
  }
}
