enum ConflictType { user, minor }

class ImportConflict {
  final dynamic entityId; // Can be int or String depending on the entity
  final ConflictType type;
  final String name;
  final String details;
  final Map<String, dynamic> existingData;
  final Map<String, dynamic> newData;
  bool shouldReplace;

  ImportConflict({
    required this.entityId,
    required this.type,
    required this.name,
    required this.details,
    required this.existingData,
    required this.newData,
    this.shouldReplace = false,
  });

  String get displayName {
    switch (type) {
      case ConflictType.user:
        return "Usuario ID: $entityId";
      case ConflictType.minor:
        return "Menor ID: $entityId";
    }
  }
}
