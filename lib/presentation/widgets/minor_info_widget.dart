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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: _buildMinorInfoCard(),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildFamilyInfoCard(),
                    SizedBox(height: 16),
                    _buildBirthInfoCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinorInfoCard() {
    return _buildCard(
      title: 'Info del menor',
      children: [
        _buildSingleInfoLine('Id del menor', minor.minorId.toString()),
        _buildSingleInfoLine('Referencia', minor.reference),
        _buildSingleInfoLine('Id del responsable', minor.managerId.toString()),
        _buildSingleInfoLine('Fecha de nacimiento',
            '${minor.birthdate.day}/${minor.birthdate.month}/${minor.birthdate.year}'),
        _buildSingleInfoLine('Rango de edad', minor.ageRange),
        _buildSingleInfoLine('Registrado el',
            '${minor.registeredAt.day}/${minor.registeredAt.month}/${minor.registeredAt.year}'),
        _buildSingleInfoLine('Número de pruebas', minor.testsNum.toString()),
        _buildSingleInfoLine(
            'Pruebas completadas', minor.completedTests.toString()),
        _buildSingleInfoLine('Sexo', minor.sex),
        _buildSingleInfoLine('Código Postal', minor.zipCode.toString()),
        _buildSingleInfoLine('Nivel de escolarización', minor.schoolingLevel),
        _buildSingleInfoLine(
            'Observaciones escolarización', minor.schoolingObservations),
        _buildSingleInfoLine(
            'Situación socioeconómica', minor.socioeconomicSituation),
        _buildSingleInfoLine('Enfermedades relevantes', minor.relevantDiseases),
        _buildSingleInfoLine('Motivo de valoración', minor.evaluationReason),
        _buildSingleInfoLine('Test de Apgar', minor.apgarTest.toString()),
        _buildSingleInfoLine('Adopción', minor.adoption.toString()),
        _buildSingleInfoLine('Juicio clínico', minor.clinicalJudgement),
      ],
    );
  }

  Widget _buildFamilyInfoCard() {
    return _buildCard(
      title: 'Info familia',
      children: [
        _buildDoubleInfoLine('Edad madre', minor.motherAge.toString(),
            'Edad padre', minor.fatherAge.toString()),
        _buildDoubleInfoLine(
            'Trabajo madre', minor.motherJob, 'Trabajo padre', minor.fatherJob),
        _buildDoubleInfoLine('Estudios madre', minor.motherStudies,
            'Estudios padre', minor.fatherStudies),
        _buildDoubleInfoLine('Nº hermanos', minor.siblings.toString(),
            'Posición herm.', minor.siblingsPosition.toString()),
        _buildDoubleInfoLine('Estado civil padres', minor.parentsCivilStatus,
            'Antecedentes familiares', minor.familyBackground),
        _buildDoubleInfoLine('Miembros familia', minor.familyMembers.toString(),
            'Discapacidades familia', minor.familyDisabilities),
      ],
    );
  }

  Widget _buildBirthInfoCard() {
    return _buildCard(
      title: 'Info parto',
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
      color: Color.fromARGB(255, 247, 238, 255),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSingleInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 32),
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

  Widget _buildDoubleInfoLine(
      String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: _buildSingleInfoLine(label1, value1)),
          SizedBox(width: 16),
          Expanded(child: _buildSingleInfoLine(label2, value2)),
        ],
      ),
    );
  }
}
