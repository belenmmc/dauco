import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/blocs/delete_minor_bloc.dart';
import 'package:dauco/presentation/blocs/get_all_minors_bloc.dart';
import 'package:dauco/presentation/blocs/update_minor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditMinorWidget extends StatefulWidget {
  final Minor minor;
  final void Function(Minor updatedMinor) onSave;

  const EditMinorWidget({super.key, required this.minor, required this.onSave});

  @override
  State<EditMinorWidget> createState() => _EditMinorWidgetState();
}

class _EditMinorWidgetState extends State<EditMinorWidget> {
  late TextEditingController minorIdController;
  late TextEditingController referenceController;
  late TextEditingController managerIdController;
  late TextEditingController birthdateController;
  late TextEditingController ageRangeController;
  late TextEditingController registeredAtController;
  late TextEditingController testsNumController;
  late TextEditingController completedTestsController;
  late TextEditingController sexController;
  late TextEditingController zipCodeController;
  late TextEditingController schoolingLevelController;
  late TextEditingController schoolingObservationsController;
  late TextEditingController socioeconomicSituationController;
  late TextEditingController relevantDiseasesController;
  late TextEditingController evaluationReasonController;
  late TextEditingController apgarTestController;
  late TextEditingController adoptionController;
  late TextEditingController clinicalJudgementController;

  late TextEditingController motherAgeController;
  late TextEditingController fatherAgeController;
  late TextEditingController motherJobController;
  late TextEditingController fatherJobController;
  late TextEditingController motherStudiesController;
  late TextEditingController fatherStudiesController;
  late TextEditingController siblingsController;
  late TextEditingController siblingsPositionController;
  late TextEditingController parentsCivilStatusController;
  late TextEditingController familyBackgroundController;
  late TextEditingController familyMembersController;
  late TextEditingController familyDisabilitiesController;

  late TextEditingController birthTypeController;
  late TextEditingController gestationWeeksController;
  late TextEditingController birthIncidentsController;
  late TextEditingController birthWeightController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final minor = widget.minor;
    minorIdController = TextEditingController(text: minor.minorId.toString());
    referenceController =
        TextEditingController(text: minor.reference.toString());
    managerIdController =
        TextEditingController(text: minor.managerId.toString());
    birthdateController = TextEditingController(
      text:
          '${minor.birthdate.day}/${minor.birthdate.month}/${minor.birthdate.year}',
    );
    ageRangeController = TextEditingController(text: minor.ageRange);
    registeredAtController = TextEditingController(
      text:
          '${minor.registeredAt.day}/${minor.registeredAt.month}/${minor.registeredAt.year}',
    );
    testsNumController = TextEditingController(text: minor.testsNum.toString());
    completedTestsController =
        TextEditingController(text: minor.completedTests.toString());
    sexController = TextEditingController(text: minor.sex);
    zipCodeController = TextEditingController(text: minor.zipCode.toString());
    schoolingLevelController =
        TextEditingController(text: minor.schoolingLevel);
    schoolingObservationsController =
        TextEditingController(text: minor.schoolingObservations);
    socioeconomicSituationController =
        TextEditingController(text: minor.socioeconomicSituation);
    relevantDiseasesController =
        TextEditingController(text: minor.relevantDiseases);
    evaluationReasonController =
        TextEditingController(text: minor.evaluationReason);
    apgarTestController =
        TextEditingController(text: minor.apgarTest.toString());
    adoptionController =
        TextEditingController(text: minor.adoption == 1 ? 'true' : 'false');
    clinicalJudgementController =
        TextEditingController(text: minor.clinicalJudgement);

    motherAgeController =
        TextEditingController(text: minor.motherAge.toString());
    fatherAgeController =
        TextEditingController(text: minor.fatherAge.toString());
    motherJobController = TextEditingController(text: minor.motherJob);
    fatherJobController = TextEditingController(text: minor.fatherJob);
    motherStudiesController = TextEditingController(text: minor.motherStudies);
    fatherStudiesController = TextEditingController(text: minor.fatherStudies);
    siblingsController = TextEditingController(text: minor.siblings.toString());
    siblingsPositionController =
        TextEditingController(text: minor.siblingsPosition.toString());
    parentsCivilStatusController =
        TextEditingController(text: minor.parentsCivilStatus);
    familyBackgroundController =
        TextEditingController(text: minor.familyBackground);
    familyMembersController =
        TextEditingController(text: minor.familyMembers.toString());
    familyDisabilitiesController =
        TextEditingController(text: minor.familyDisabilities);

    birthTypeController = TextEditingController(text: minor.birthType);
    gestationWeeksController =
        TextEditingController(text: minor.gestationWeeks.toString());
    birthIncidentsController =
        TextEditingController(text: minor.birthIncidents);
    birthWeightController =
        TextEditingController(text: minor.birthWeight.toString());
  }

  @override
  void dispose() {
    minorIdController.dispose();
    referenceController.dispose();
    managerIdController.dispose();
    birthdateController.dispose();
    ageRangeController.dispose();
    registeredAtController.dispose();
    testsNumController.dispose();
    completedTestsController.dispose();
    sexController.dispose();
    zipCodeController.dispose();
    schoolingLevelController.dispose();
    schoolingObservationsController.dispose();
    socioeconomicSituationController.dispose();
    relevantDiseasesController.dispose();
    evaluationReasonController.dispose();
    apgarTestController.dispose();
    adoptionController.dispose();
    clinicalJudgementController.dispose();

    motherAgeController.dispose();
    fatherAgeController.dispose();
    motherJobController.dispose();
    fatherJobController.dispose();
    motherStudiesController.dispose();
    fatherStudiesController.dispose();
    siblingsController.dispose();
    siblingsPositionController.dispose();
    parentsCivilStatusController.dispose();
    familyBackgroundController.dispose();
    familyMembersController.dispose();
    familyDisabilitiesController.dispose();

    birthTypeController.dispose();
    gestationWeeksController.dispose();
    birthIncidentsController.dispose();
    birthWeightController.dispose();

    super.dispose();
  }

  DateTime? _parseDate(String text) {
    try {
      final parts = text.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Card(
              margin: const EdgeInsets.only(top: 20.0, right: 16.0, left: 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: const Color.fromARGB(255, 120, 120, 175),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * 0.472,
                        child: _buildCard(
                            'Información del menor', _buildMinorInfoColumn()),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildCard('Información de la familia',
                                _buildFamilyInfoColumn()),
                            const SizedBox(height: 20),
                            _buildCard('Información del parto',
                                _buildBirthInfoColumn()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(237, 247, 238, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            Minor updatedMinor = Minor(
                              minorId: int.tryParse(minorIdController.text) ??
                                  widget.minor.minorId,
                              reference:
                                  int.tryParse(referenceController.text) ??
                                      widget.minor.reference,
                              managerId:
                                  int.tryParse(managerIdController.text) ??
                                      widget.minor.managerId,
                              birthdate: _parseDate(birthdateController.text) ??
                                  widget.minor.birthdate,
                              ageRange: ageRangeController.text,
                              registeredAt:
                                  _parseDate(registeredAtController.text) ??
                                      widget.minor.registeredAt,
                              testsNum: int.tryParse(testsNumController.text) ??
                                  widget.minor.testsNum,
                              completedTests:
                                  int.tryParse(completedTestsController.text) ??
                                      widget.minor.completedTests,
                              sex: sexController.text,
                              zipCode: int.tryParse(zipCodeController.text) ??
                                  widget.minor.zipCode,
                              fatherAge:
                                  int.tryParse(fatherAgeController.text) ??
                                      widget.minor.fatherAge,
                              motherAge:
                                  int.tryParse(motherAgeController.text) ??
                                      widget.minor.motherAge,
                              fatherJob: fatherJobController.text,
                              motherJob: motherJobController.text,
                              fatherStudies: fatherStudiesController.text,
                              motherStudies: motherStudiesController.text,
                              parentsCivilStatus:
                                  parentsCivilStatusController.text,
                              siblings: int.tryParse(siblingsController.text) ??
                                  widget.minor.siblings,
                              siblingsPosition: int.tryParse(
                                      siblingsPositionController.text) ??
                                  widget.minor.siblingsPosition,
                              birthType: birthTypeController.text,
                              gestationWeeks:
                                  int.tryParse(gestationWeeksController.text) ??
                                      widget.minor.gestationWeeks,
                              birthIncidents: birthIncidentsController.text,
                              birthWeight:
                                  int.tryParse(birthWeightController.text) ??
                                      widget.minor.birthWeight,
                              socioeconomicSituation:
                                  socioeconomicSituationController.text,
                              familyBackground: familyBackgroundController.text,
                              familyMembers:
                                  int.tryParse(familyMembersController.text) ??
                                      widget.minor.familyMembers,
                              familyDisabilities:
                                  familyDisabilitiesController.text,
                              schoolingLevel: schoolingLevelController.text,
                              schoolingObservations:
                                  schoolingObservationsController.text,
                              relevantDiseases: relevantDiseasesController.text,
                              evaluationReason: evaluationReasonController.text,
                              apgarTest:
                                  int.tryParse(apgarTestController.text) ??
                                      widget.minor.apgarTest,
                              adoption: adoptionController.text.toLowerCase() ==
                                      'true'
                                  ? 1
                                  : 0,
                              clinicalJudgement:
                                  clinicalJudgementController.text,
                            );
                            context
                                .read<UpdateMinorBloc>()
                                .add(UpdateMinorEvent(minor: updatedMinor));
                            widget.onSave(updatedMinor);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Guardar cambios',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 55, 57, 82),
                                  )),
                              const SizedBox(width: 10),
                              const Icon(Icons.save,
                                  size: 28,
                                  color: Color.fromARGB(255, 55, 57, 82)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: BlocListener<DeleteMinorBloc, DeleteMinorState>(
                          listener: (context, state) {
                            if (state is DeleteMinorSuccess) {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Menor eliminado correctamente')),
                              );
                              Future.delayed(Duration.zero, () {
                                context
                                    .read<GetAllMinorsBloc>()
                                    .add(GetEvent());
                              });
                            } else if (state is DeleteMinorError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error al eliminar: ${state.error}')),
                              );
                            }
                          },
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 55, 57, 82),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              context.read<DeleteMinorBloc>().add(
                                    DeleteMinorEvent(
                                        minorId:
                                            widget.minor.minorId.toString()),
                                  );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Eliminar menor',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: const Color.fromARGB(
                                          237, 247, 238, 255),
                                    )),
                                const SizedBox(width: 10),
                                const Icon(Icons.delete,
                                    size: 28,
                                    color: Color.fromARGB(237, 247, 238, 255)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMinorInfoColumn() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  'ID Menor', minorIdController, TextInputType.number),
              _buildTextField(
                  'Referencia', referenceController, TextInputType.number),
              _buildTextField(
                  'ID Gestor', managerIdController, TextInputType.number),
              _buildTextField(
                  'Fecha de Nacimiento (dd/mm/yyyy)', birthdateController),
              _buildTextField('Rango de Edad', ageRangeController),
              _buildTextField(
                  'Fecha Registro (dd/mm/yyyy)', registeredAtController),
              _buildTextField(
                  'Número de Tests', testsNumController, TextInputType.number),
              _buildTextField('Tests Completados', completedTestsController,
                  TextInputType.number),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Sexo', sexController),
              _buildTextField(
                  'Código Postal', zipCodeController, TextInputType.number),
              _buildTextField('Nivel Escolaridad', schoolingLevelController),
              _buildTextField(
                  'Observaciones Escolaridad', schoolingObservationsController),
              _buildTextField(
                  'Situación Socioeconómica', socioeconomicSituationController),
              _buildTextField(
                  'Enfermedades Relevantes', relevantDiseasesController),
              _buildTextField('Motivo Evaluación', evaluationReasonController),
              _buildTextField(
                  'Test Apgar', apgarTestController, TextInputType.number),
              _buildTextField('Adopción (true/false)', adoptionController),
              _buildTextField('Juicio Clínico', clinicalJudgementController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyInfoColumn() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  'Edad Madre', motherAgeController, TextInputType.number),
              _buildTextField('Trabajo Madre', motherJobController),
              _buildTextField('Estudios Madre', motherStudiesController),
              _buildTextField(
                  'Número Hermanos', siblingsController, TextInputType.number),
              _buildTextField(
                  'Estado Civil Padres', parentsCivilStatusController),
              _buildTextField('Miembros Familia', familyMembersController,
                  TextInputType.number),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  'Edad Padre', fatherAgeController, TextInputType.number),
              _buildTextField('Trabajo Padre', fatherJobController),
              _buildTextField('Estudios Padre', fatherStudiesController),
              _buildTextField('Posición Hermanos', siblingsPositionController,
                  TextInputType.number),
              _buildTextField(
                  'Antecedentes Familiares', familyBackgroundController),
              _buildTextField(
                  'Discapacidades Familia', familyDisabilitiesController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBirthInfoColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Tipo de Parto', birthTypeController),
              _buildTextField('Semanas de Gestación', gestationWeeksController,
                  TextInputType.number),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Incidentes Parto', birthIncidentsController),
              _buildTextField('Peso al Nacer (kg)', birthWeightController,
                  TextInputType.number),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: const Color.fromARGB(255, 247, 238, 255),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 104, 106, 195))),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      [TextInputType? keyboardType]) {
    final isRequired =
        label == 'ID Menor' || label == 'Referencia' || label == 'ID Gestor';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Por favor complete este campo';
          }
          return null;
        },
      ),
    );
  }
}
