class ImportedUser {
  final int managerId;
  final String name;
  final String surname;
  final bool yes;
  final DateTime registeredAt;
  final String zone;
  final int minorsNum;

  ImportedUser({
    required this.managerId,
    required this.name,
    required this.surname,
    required this.yes,
    required this.registeredAt,
    required this.zone,
    required this.minorsNum,
  });

  Map<String, dynamic> toJson() {
    return {
      'responsable_id': managerId,
      'nombre': name,
      'apellidos': surname,
      'si': yes,
      'alta': registeredAt.toIso8601String(),
      'zona': zone,
      'num_menores': minorsNum,
    };
  }
}
