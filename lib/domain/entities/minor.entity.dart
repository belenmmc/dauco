class Minor {
  final int minorId;
  final int reference;
  final int managerId;
  final DateTime birthdate;
  final String ageRange;
  final DateTime registeredAt;
  final int testsNum;
  final int completedTests;
  final String sex;
  final int zipCode;
  final int fatherAge;
  final int motherAge;
  final String fatherJob;
  final String motherJob;
  final String fatherStudies;
  final String motherStudies;
  final String parentsCivilStatus;
  final int siblings;
  final int siblingsPosition;
  final String birthType;
  final int gestationWeeks;
  final String birthIncidents;
  final int birthWeight;
  final String socioeconomicSituation;
  final String familyBackground;
  final int familyMembers;
  final String familyDisabilities;
  final String schoolingLevel;
  final String schoolingObservations;
  final String relevantDiseases;
  final String evaluationReason;
  final int apgarTest;
  final int adoption;
  final String clinicalJudgement;

  Minor({
    required this.minorId,
    required this.reference,
    required this.managerId,
    required this.birthdate,
    required this.ageRange,
    required this.registeredAt,
    required this.testsNum,
    required this.completedTests,
    required this.sex,
    required this.zipCode,
    required this.fatherAge,
    required this.motherAge,
    required this.fatherJob,
    required this.motherJob,
    required this.fatherStudies,
    required this.motherStudies,
    required this.parentsCivilStatus,
    required this.siblings,
    required this.siblingsPosition,
    required this.birthType,
    required this.gestationWeeks,
    required this.birthIncidents,
    required this.birthWeight,
    required this.socioeconomicSituation,
    required this.familyBackground,
    required this.familyMembers,
    required this.familyDisabilities,
    required this.schoolingLevel,
    required this.schoolingObservations,
    required this.relevantDiseases,
    required this.evaluationReason,
    required this.apgarTest,
    required this.adoption,
    required this.clinicalJudgement,
  });

  Map<String, dynamic> toJson() {
    return {
      'menor_id': minorId,
      'referencia': reference,
      'responsable_id': managerId,
      'fecha_nacimiento': birthdate.toIso8601String(),
      'rango_edad': ageRange,
      'alta': registeredAt.toIso8601String(),
      'num_tests': testsNum,
      'test_completados': completedTests,
      'sexo': sex,
      'cp': zipCode,
      'edad_padre': fatherAge,
      'edad_madre': motherAge,
      'trabajo_padre': fatherJob,
      'trabajo_madre': motherJob,
      'estudios_padre': fatherStudies,
      'estudios_madre': motherStudies,
      'estado_civil_padres': parentsCivilStatus,
      'hermanos': siblings,
      'posicion_hermanos': siblingsPosition,
      'tipo_parto': birthType,
      'semana_gestacion': gestationWeeks,
      'incidencias_parto': birthIncidents,
      'peso_nacimiento': birthWeight,
      'situacion_socioeconomica': socioeconomicSituation,
      'antecedentes_familiares': familyBackground,
      'familiares_domicilio': familyMembers,
      'familiares_discapacidad': familyDisabilities,
      'nivel_escolarizacion': schoolingLevel,
      'observaciones_escolarizacion': schoolingObservations,
      'enfermedades_relevantes': relevantDiseases,
      'motivo_valoracion': evaluationReason,
      'test_apgar': apgarTest,
      'adopcion': adoption,
      'juicio_clinico': clinicalJudgement,
    };
  }
}
