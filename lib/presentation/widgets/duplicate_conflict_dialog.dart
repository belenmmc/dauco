import 'package:flutter/material.dart';

enum ConflictResolution {
  keepExisting,
  replaceWithNew,
  skipRecord,
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

  @override
  State<DuplicateConflictDialog> createState() =>
      _DuplicateConflictDialogState();
}

class _DuplicateConflictDialogState extends State<DuplicateConflictDialog> {
  ConflictResolution? _selectedResolution;

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
      content: SizedBox(
        width: 600,
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
            const SizedBox(height: 20),

            // Comparison View
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Existing Record
                Expanded(
                  child: _buildRecordCard(
                    'Registro Existente (Base de Datos)',
                    widget.existingRecord,
                    const Color.fromARGB(255, 255, 243, 230), // Light orange
                    const Color.fromARGB(255, 230, 126, 34), // Orange border
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

            _buildResolutionOption(
              ConflictResolution.skipRecord,
              'Omitir este registro',
              'No procesar este registro y continuar',
              Icons.skip_next,
              Colors.orange,
            ),
          ],
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
              ? () => Navigator.of(context).pop(_selectedResolution)
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
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
          ...record.entries
              .take(6)
              .map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${_formatFieldName(entry.key)}:',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 43, 45, 66),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${entry.value ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 43, 45, 66),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          if (record.entries.length > 6)
            Text(
              '... y ${record.entries.length - 6} campos más',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
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
      default:
        return fieldName.replaceAll('_', ' ').toUpperCase();
    }
  }
}
