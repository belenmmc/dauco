import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:flutter/material.dart';

class MinorInfoWidget extends StatelessWidget {
  final Minor minor;

  const MinorInfoWidget({super.key, required this.minor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Card(
            margin: const EdgeInsets.only(top: 20.0, right: 16.0, left: 16.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: const Color.fromARGB(255, 111, 145, 179),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.495,
                            child: _buildMinorInfoCard(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                _buildFamilyInfoCard(),
                                const SizedBox(height: 16),
                                _buildBirthInfoCard(),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinorInfoCard() {
    return _buildCard(
      title: 'Información del menor',
      children: [
        _buildDoubleInfoLine('Id del menor', minor.minorId.toString(),
            'Referencia', minor.reference.toString()),
        _buildDoubleInfoLine(
            'Id del responsable',
            minor.managerId.toString(),
            'Fecha de nacimiento',
            '${minor.birthdate.day}/${minor.birthdate.month}/${minor.birthdate.year}'),
        _buildDoubleInfoLine('Rango de edad', minor.ageRange, 'Registrado el',
            '${minor.registeredAt.day}/${minor.registeredAt.month}/${minor.registeredAt.year}'),
        _buildDoubleInfoLine('Número de pruebas', minor.testsNum.toString(),
            'Pruebas completadas', minor.completedTests.toString()),
        _buildDoubleInfoLine(
            'Sexo', minor.sex, 'Código Postal', minor.zipCode.toString()),
        _buildDoubleInfoLine('Nivel de escolarización', minor.schoolingLevel,
            'Observaciones escolarización', minor.schoolingObservations),
        _buildDoubleInfoLine(
            'Situación socioeconómica',
            minor.socioeconomicSituation,
            'Enfermedades relevantes',
            minor.relevantDiseases),
        _buildDoubleInfoLine('Motivo de valoración', minor.evaluationReason,
            'Test de Apgar', minor.apgarTest.toString()),
        _buildDoubleInfoLine('Adopción', minor.adoption.toString(),
            'Juicio clínico', minor.clinicalJudgement),
      ],
    );
  }

  Widget _buildFamilyInfoCard() {
    return _buildCard(
      title: 'Información de la familia',
      children: [
        _buildDoubleInfoLine('Edad madre', minor.motherAge.toString(),
            'Edad padre', minor.fatherAge.toString()),
        _buildDoubleInfoLine(
            'Trabajo madre', minor.motherJob, 'Trabajo padre', minor.fatherJob),
        _buildDoubleInfoLine('Estudios madre', minor.motherStudies,
            'Estudios padre', minor.fatherStudies),
        _buildDoubleInfoLine('Número de hermanos', minor.siblings.toString(),
            'Posición hermanos', minor.siblingsPosition.toString()),
        _buildDoubleInfoLine('Estado civil padres', minor.parentsCivilStatus,
            'Antecedentes familiares', minor.familyBackground),
        _buildDoubleInfoLine('Miembros familia', minor.familyMembers.toString(),
            'Discapacidades familia', minor.familyDisabilities),
      ],
    );
  }

  Widget _buildBirthInfoCard() {
    return _buildCard(
      title: 'Información del parto',
      children: [
        _buildSingleInfoLine('Tipo de parto', minor.birthType),
        _buildSingleInfoLine(
            'Semanas de gestación', minor.gestationWeeks.toString()),
        _buildSingleInfoLine('Incidentes en el parto', minor.birthIncidents),
        _buildSingleInfoLine('Peso al nacer', minor.birthWeight.toString())
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: const Color.fromARGB(255, 248, 251, 255),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 69, 100, 131)),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSingleInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoubleInfoLine(
      String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildSingleInfoLine(label1, value1),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSingleInfoLine(label2, value2),
          ),
        ],
      ),
    );
  }
}
