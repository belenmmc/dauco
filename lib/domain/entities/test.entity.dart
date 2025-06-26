class Test {
  final int testId;
  final int minorId;
  final DateTime registeredAt;
  final String cronologicalAge;
  final String evolutionaryAge;
  final bool mChatTest;
  final String progress;
  final int activeAreas;
  final String professionalType;

  Test({
    required this.testId,
    required this.minorId,
    required this.registeredAt,
    required this.cronologicalAge,
    required this.evolutionaryAge,
    required this.mChatTest,
    required this.progress,
    required this.activeAreas,
    required this.professionalType,
  });

  Map<String, dynamic> toJson() {
    return {
      'test_id': testId,
      'menor_id': minorId,
      'alta': registeredAt.toIso8601String(),
      'edad_cronologica': cronologicalAge,
      'edad_evolutiva': evolutionaryAge,
      'test_mchat': mChatTest,
      'progreso': progress,
      'areas_activas': activeAreas,
      'tipo_profesional': professionalType,
    };
  }
}
