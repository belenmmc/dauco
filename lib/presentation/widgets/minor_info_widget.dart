import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:flutter/material.dart';

class MinorInfoWidget extends StatelessWidget {
  final Minor minor;

  const MinorInfoWidget({super.key, required this.minor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Info del menor'),
          _buildInfoRow('Id del menor', minor.minorId.toString()),
          _buildInfoRow('Id del responsable', minor.managerId.toString()),
          _buildInfoRow('Fecha de nacimiento', minor.birthdate.toString()),
          _buildInfoRow('Sexo', minor.sex),
          _buildInfoRow('Código Postal', minor.zipCode.toString()),
          _buildInfoRow('Nivel de escolarización', minor.schoolingLevel),
          _buildInfoRow(
              'Situación socioeconómica', minor.socioeconomicSituation),
          _buildInfoRow('Enfermedades relevantes', minor.relevantDiseases),
          _buildInfoRow('Motivo de valoración', minor.evaluationReason),
          SizedBox(height: 20),
          _buildSectionTitle('Info familia'),
          _buildFamilyInfoRow('Edad madre', minor.motherAge.toString(),
              'Edad padre', minor.fatherAge.toString()),
          _buildFamilyInfoRow('Trabajo madre', minor.motherJob, 'Trabajo padre',
              minor.fatherJob),
          _buildFamilyInfoRow('Nº hermanos', minor.siblings.toString(),
              'Posición herm.', minor.siblingsPosition.toString()),
          _buildFamilyInfoRow('Nví estudios madre', minor.motherStudies,
              'Nví estudios padre', minor.fatherStudies),
          _buildFamilyInfoRow('Estado civil madre', minor.motherJob,
              'Estado civil padre', minor.fatherJob),
          SizedBox(height: 20),
          _buildSectionTitle('Info parto'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyInfoRow(
      String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoRow(label1, value1),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildInfoRow(label2, value2),
          ),
        ],
      ),
    );
  }
}
