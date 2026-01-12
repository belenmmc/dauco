import 'package:flutter/material.dart';

/// Enhanced duplicate conflict dialog that:
/// 1. Compares records and identifies differences
/// 2. Shows all fields with differences highlighted
/// 3. Provides a static method to check if records are identical
/// 4. Includes "Apply to All" functionality for batch operations
///
/// Usage:
/// ```dart
/// // First check if records are identical to avoid showing dialog
/// if (DuplicateConflictDialog.areRecordsIdentical(existingRecord, newRecord)) {
///   // Records are identical, continue processing
///   return;
/// }
///
/// // Records have differences, show dialog
/// final result = await showDialog<Map<String, dynamic>>(
///   context: context,
///   builder: (context) => DuplicateConflictDialog(
///     recordType: 'Usuario',
///     primaryKey: 'email',
///     primaryKeyValue: existingRecord['email'],
///     existingRecord: existingRecord,
///     newRecord: newRecord,
///   ),
/// );
///
/// if (result != null) {
///   final resolution = result['resolution'] as ConflictResolution;
///   final applyToAll = result['applyToAll'] as bool;
///   // Handle resolution and apply-to-all logic
/// }
/// ```

enum ConflictResolution {
  keepExisting,
  replaceWithNew,
}

class DuplicateConflictDialog extends StatefulWidget {
  final String recordType;
  final String primaryKey;
  final dynamic primaryKeyValue;
  final Map<String, dynamic> existingRecord;
  final Map<String, dynamic> newRecord;

  const DuplicateConflictDialog({
    super.key,
    required this.recordType,
    required this.primaryKey,
    required this.primaryKeyValue,
    required this.existingRecord,
    required this.newRecord,
  });

  /// Returns true if the records are identical (no need to show dialog)
  static bool areRecordsIdentical(
      Map<String, dynamic> existing, Map<String, dynamic> newRecord) {
    // Get all keys from both records
    final allKeys = {...existing.keys, ...newRecord.keys};

    for (final key in allKeys) {
      final existingValue = existing[key];
      final newValue = newRecord[key];

      // Normalize values for comparison
      final normalizedExisting = _normalizeValue(existingValue);
      final normalizedNew = _normalizeValue(newValue);

      if (normalizedExisting != normalizedNew) {
        return false; // Found a difference
      }
    }

    return true; // No differences found
  }

  /// Normalize values for comparison, handling dates and empty strings
  static String? _normalizeValue(dynamic value) {
    if (value == null) return null;

    String stringValue = value.toString().trim();
    if (stringValue.isEmpty) return null;

    // Handle date normalization for common date formats
    if (_isDateString(stringValue)) {
      return _normalizeDateString(stringValue);
    }

    // Normalize numeric strings (remove leading zeros, handle 0 as null)
    final numValue = num.tryParse(stringValue);
    if (numValue != null) {
      if (numValue == 0) return null; // Treat 0 as null
      return numValue.toString();
    }

    return stringValue;
  }

  /// Check if a string looks like a date
  static bool _isDateString(String value) {
    // Match patterns like:
    // 2023-12-25
    // 2023-12-25T10:30:00
    // 2023-12-25T10:30:00.000
    // 2023-12-25 10:30:00
    // Also check if DateTime.tryParse can handle it
    final dateRegex =
        RegExp(r'^\d{4}-\d{2}-\d{2}([T ]\d{2}:\d{2}:\d{2}(\.\d{3})?)?$');
    if (dateRegex.hasMatch(value)) return true;

    // Try parsing as DateTime to catch other formats
    return DateTime.tryParse(value) != null;
  }

  /// Normalize date strings to a common format for comparison
  static String _normalizeDateString(String dateString) {
    try {
      // Parse the date string
      DateTime? date;

      // Handle different formats
      if (dateString.contains('T')) {
        // ISO format with T separator
        date = DateTime.tryParse(dateString);
      } else if (dateString.contains(' ')) {
        // Format with space separator
        date = DateTime.tryParse(dateString.replaceFirst(' ', 'T'));
      } else if (dateString.length == 10) {
        // Date only format (yyyy-mm-dd)
        date = DateTime.tryParse('${dateString}T00:00:00');
      }

      if (date != null) {
        // Always return just the date part (yyyy-mm-dd) for comparison
        // This ignores time component completely
        return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      // If parsing fails, return original string
    }

    return dateString;
  }

  @override
  State<DuplicateConflictDialog> createState() =>
      _DuplicateConflictDialogState();
}

class _DuplicateConflictDialogState extends State<DuplicateConflictDialog> {
  ConflictResolution? _selectedResolution;
  late Set<String> _differentFields;
  bool _applyToAll = false;

  @override
  void initState() {
    super.initState();
    _compareRecords();
  }

  void _compareRecords() {
    _differentFields = <String>{};

    // Get all keys from both records
    final allKeys = {...widget.existingRecord.keys, ...widget.newRecord.keys};

    for (final key in allKeys) {
      final existingValue = widget.existingRecord[key];
      final newValue = widget.newRecord[key];

      // Normalize values for comparison using the same logic
      final normalizedExisting =
          DuplicateConflictDialog._normalizeValue(existingValue);
      final normalizedNew = DuplicateConflictDialog._normalizeValue(newValue);

      // Only mark as different if both values are not null and they differ
      // If one is null and the other is not, only mark as different if the non-null value is meaningful
      if (normalizedExisting == null && normalizedNew == null) {
        // Both null, consider equal
        continue;
      } else if (normalizedExisting == null || normalizedNew == null) {
        // One is null, check if the other is a meaningful value (not 0, not empty)
        final nonNullValue = normalizedExisting ?? normalizedNew;
        if (nonNullValue == '0' || nonNullValue?.isEmpty == true) {
          // Treat 0 or empty as equivalent to null
          continue;
        }
        _differentFields.add(key);
      } else if (normalizedExisting != normalizedNew) {
        _differentFields.add(key);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 248, 251, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.warning_amber,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Registro Duplicado Encontrado',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 43, 45, 66),
              ),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 600, // Constrain height to prevent overflow
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Un registro con ${widget.primaryKey}: ${widget.primaryKeyValue} ya existe en la base de datos.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 43, 45, 66),
                ),
              ),

              // Show differences summary
              if (_differentFields.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Se encontraron ${_differentFields.length} campos diferentes: ${_differentFields.map((field) => _formatFieldName(field)).join(", ")}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Comparison View (scrollable)
              SizedBox(
                height: 300, // Reduced height to fit better
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Existing Record
                    Expanded(
                      child: _buildRecordCard(
                        'Registro Existente (Base de Datos)',
                        widget.existingRecord,
                        const Color.fromARGB(
                            255, 255, 243, 230), // Light orange
                        const Color.fromARGB(
                            255, 230, 126, 34), // Orange border
                      ),
                    ),
                    const SizedBox(width: 16),

                    // New Record
                    Expanded(
                      child: _buildRecordCard(
                        'Nuevo Registro (Archivo)',
                        widget.newRecord,
                        const Color.fromARGB(255, 230, 247, 255), // Light blue
                        const Color.fromARGB(255, 97, 135, 174), // Blue border
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Resolution Options
              const Text(
                '¿Qué deseas hacer?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 43, 45, 66),
                ),
              ),
              const SizedBox(height: 12),

              _buildResolutionOption(
                ConflictResolution.keepExisting,
                'Mantener el registro existente',
                'No realizar cambios en la base de datos',
                Icons.block,
                Colors.grey,
              ),

              _buildResolutionOption(
                ConflictResolution.replaceWithNew,
                'Reemplazar con el nuevo registro',
                'Actualizar la base de datos con los nuevos datos',
                Icons.update,
                Colors.blue,
              ),

              const SizedBox(height: 16),

              // Apply to All checkbox
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _applyToAll,
                      onChanged: (value) {
                        setState(() {
                          _applyToAll = value ?? false;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aplicar a todos los registros',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _applyToAll
                                  ? Colors.blue[800]
                                  : const Color.fromARGB(255, 43, 45, 66),
                            ),
                          ),
                          Text(
                            'Usar esta decisión para todos los futuros conflictos',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: Color.fromARGB(255, 98, 100, 116),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _selectedResolution != null
              ? () => Navigator.of(context).pop({
                    'resolution': _selectedResolution,
                    'applyToAll': _applyToAll,
                  })
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: const Color.fromARGB(255, 97, 135, 174),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: const Text(
            'Aplicar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCard(String title, Map<String, dynamic> record,
      Color backgroundColor, Color borderColor) {
    // Get all keys from both records to show everything
    final allKeys = {...widget.existingRecord.keys, ...widget.newRecord.keys};

    // Create a complete record with all possible fields
    final completeRecord = <String, dynamic>{};
    for (final key in allKeys) {
      completeRecord[key] =
          record[key]; // Will be null if field doesn't exist in this record
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: borderColor,
            ),
          ),
          const SizedBox(height: 8),
          // Show ALL fields including dates
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: completeRecord.entries
                    .map((entry) => _buildFieldRow(entry.key, entry.value))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String key, dynamic value) {
    final isDifferent = _differentFields.contains(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: isDifferent
          ? BoxDecoration(
              color: Colors.yellow.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.orange, width: 1),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDifferent)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.warning_amber,
                size: 12,
                color: Colors.orange,
              ),
            ),
          Expanded(
            flex: 2,
            child: Text(
              '${_formatFieldName(key)}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isDifferent ? FontWeight.bold : FontWeight.w600,
                color: isDifferent
                    ? Colors.orange[800]
                    : const Color.fromARGB(255, 43, 45, 66),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatFieldValue(key, value),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isDifferent ? FontWeight.w600 : FontWeight.normal,
                color: isDifferent
                    ? Colors.orange[800]
                    : const Color.fromARGB(255, 43, 45, 66),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionOption(
    ConflictResolution resolution,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedResolution == resolution;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedResolution = resolution;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Radio<ConflictResolution>(
              value: resolution,
              groupValue: _selectedResolution,
              onChanged: (value) {
                setState(() {
                  _selectedResolution = value;
                });
              },
              activeColor: color,
            ),
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? color
                          : const Color.fromARGB(255, 43, 45, 66),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFieldName(String fieldName) {
    // Convert field names to more readable format
    switch (fieldName.toLowerCase()) {
      case 'responsable_id':
      case 'manager_id':
        return 'ID Responsable';
      case 'menor_id':
      case 'minor_id':
        return 'ID Menor';
      case 'test_id':
        return 'ID Test';
      case 'nombre':
      case 'name':
        return 'Nombre';
      case 'apellidos':
      case 'surname':
        return 'Apellidos';
      case 'email':
        return 'Email';
      case 'zona':
      case 'zone':
        return 'Zona';
      case 'alta':
      case 'registered_at':
        return 'Fecha Alta';
      case 'fecha_nacimiento':
      case 'birthdate':
        return 'Fecha Nacimiento';
      case 'sexo':
      case 'sex':
        return 'Sexo';
      case 'codigo_postal':
      case 'zip_code':
        return 'Código Postal';
      case 'telefono':
      case 'phone':
        return 'Teléfono';
      case 'direccion':
      case 'address':
        return 'Dirección';
      case 'role':
      case 'rol':
        return 'Rol';
      case 'id':
        return 'ID';
      case 'created_at':
      case 'fecha_creacion':
        return 'Fecha Creación';
      case 'updated_at':
      case 'fecha_actualizacion':
        return 'Fecha Actualización';
      case 'activo':
      case 'active':
        return 'Activo';
      default:
        return fieldName
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isEmpty
                ? ''
                : word[0].toUpperCase() + word.substring(1).toLowerCase())
            .join(' ');
    }
  }

  String _formatFieldValue(String fieldName, dynamic value) {
    if (value == null) return 'N/A';

    String stringValue = value.toString();

    // Format dates based on field type
    switch (fieldName.toLowerCase()) {
      case 'fecha_nacimiento':
      case 'birthdate':
        // Format birthdate as DD-MM-YYYY
        return _formatDateForDisplay(stringValue, includeTime: false);
      case 'alta':
      case 'registered_at':
      case 'created_at':
      case 'fecha_creacion':
      case 'updated_at':
      case 'fecha_actualizacion':
        // Format fecha de alta as DD-MM-YYYY HH:MM:SS
        return _formatDateForDisplay(stringValue, includeTime: true);
      default:
        return stringValue;
    }
  }

  String _formatDateForDisplay(String dateString, {required bool includeTime}) {
    if (dateString.isEmpty) return 'N/A';

    try {
      DateTime? date;

      // Handle different input formats
      if (dateString.contains('T')) {
        // ISO format with T separator
        date = DateTime.tryParse(dateString);
      } else if (dateString.contains(' ')) {
        // Format with space separator
        date = DateTime.tryParse(dateString.replaceFirst(' ', 'T'));
      } else if (dateString.length == 10) {
        // Date only format (yyyy-mm-dd)
        date = DateTime.tryParse('${dateString}T00:00:00');
      } else {
        // Try parsing as-is
        date = DateTime.tryParse(dateString);
      }

      if (date != null) {
        if (includeTime) {
          // Format as DD-MM-YYYY HH:MM:SS
          return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
        } else {
          // Format as DD-MM-YYYY
          return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
        }
      }
    } catch (e) {
      // If parsing fails, return original string
    }

    return dateString;
  }
}
