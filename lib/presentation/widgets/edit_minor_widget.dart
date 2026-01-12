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

  DateTime? selectedBirthdate;
  DateTime? selectedRegisteredAt;

  @override
  void initState() {
    super.initState();
    final minor = widget.minor;

    selectedBirthdate = minor.birthdate;
    selectedRegisteredAt = minor.registeredAt;

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

  Future<void> _selectDate(BuildContext context, bool isBirthdate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthdate
          ? selectedBirthdate ?? DateTime.now()
          : selectedRegisteredAt ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 97, 135, 174),
              onPrimary: Colors.white,
              surface: const Color.fromARGB(255, 248, 251, 255),
              onSurface: const Color.fromARGB(255, 43, 45, 66),
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 248, 251, 255),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isBirthdate) {
          selectedBirthdate = picked;
          birthdateController.text =
              '${picked.day}/${picked.month}/${picked.year}';
        } else {
          selectedRegisteredAt = picked;
          registeredAtController.text =
              '${picked.day}/${picked.month}/${picked.year}';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1500),
              child: Card(
                margin: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: const Color.fromARGB(255, 111, 145, 179),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.414,
                            child: _buildCard('Información del menor',
                                _buildMinorInfoColumn()),
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
                                    const Color.fromARGB(255, 248, 251, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 248, 251, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 400),
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 97, 135, 174),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Confirmar cambios',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromARGB(
                                                      255, 43, 45, 66),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 12),
                                              const Text(
                                                '¿Está seguro de que desea guardar los cambios realizados?',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 107, 114, 128),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 24),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                        side: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              229,
                                                              231,
                                                              235),
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              107,
                                                              114,
                                                              128),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                97, 135, 174),
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      child:
                                                          const Text('Guardar'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    Minor updatedMinor = Minor(
                                      minorId: int.tryParse(
                                              minorIdController.text) ??
                                          widget.minor.minorId,
                                      reference: int.tryParse(
                                              referenceController.text) ??
                                          widget.minor.reference,
                                      managerId: int.tryParse(
                                              managerIdController.text) ??
                                          widget.minor.managerId,
                                      birthdate: selectedBirthdate ??
                                          widget.minor.birthdate,
                                      ageRange: ageRangeController.text,
                                      registeredAt: selectedRegisteredAt ??
                                          widget.minor.registeredAt,
                                      testsNum: int.tryParse(
                                              testsNumController.text) ??
                                          widget.minor.testsNum,
                                      completedTests: int.tryParse(
                                              completedTestsController.text) ??
                                          widget.minor.completedTests,
                                      sex: sexController.text,
                                      zipCode: int.tryParse(
                                              zipCodeController.text) ??
                                          widget.minor.zipCode,
                                      fatherAge: int.tryParse(
                                              fatherAgeController.text) ??
                                          widget.minor.fatherAge,
                                      motherAge: int.tryParse(
                                              motherAgeController.text) ??
                                          widget.minor.motherAge,
                                      fatherJob: fatherJobController.text,
                                      motherJob: motherJobController.text,
                                      fatherStudies:
                                          fatherStudiesController.text,
                                      motherStudies:
                                          motherStudiesController.text,
                                      parentsCivilStatus:
                                          parentsCivilStatusController.text,
                                      siblings: int.tryParse(
                                              siblingsController.text) ??
                                          widget.minor.siblings,
                                      siblingsPosition: int.tryParse(
                                              siblingsPositionController
                                                  .text) ??
                                          widget.minor.siblingsPosition,
                                      birthType: birthTypeController.text,
                                      gestationWeeks: int.tryParse(
                                              gestationWeeksController.text) ??
                                          widget.minor.gestationWeeks,
                                      birthIncidents:
                                          birthIncidentsController.text,
                                      birthWeight: int.tryParse(
                                              birthWeightController.text) ??
                                          widget.minor.birthWeight,
                                      socioeconomicSituation:
                                          socioeconomicSituationController.text,
                                      familyBackground:
                                          familyBackgroundController.text,
                                      familyMembers: int.tryParse(
                                              familyMembersController.text) ??
                                          widget.minor.familyMembers,
                                      familyDisabilities:
                                          familyDisabilitiesController.text,
                                      schoolingLevel:
                                          schoolingLevelController.text,
                                      schoolingObservations:
                                          schoolingObservationsController.text,
                                      relevantDiseases:
                                          relevantDiseasesController.text,
                                      evaluationReason:
                                          evaluationReasonController.text,
                                      apgarTest: int.tryParse(
                                              apgarTestController.text) ??
                                          widget.minor.apgarTest,
                                      adoption: adoptionController.text
                                                  .toLowerCase() ==
                                              'true'
                                          ? 1
                                          : 0,
                                      clinicalJudgement:
                                          clinicalJudgementController.text,
                                    );
                                    context.read<UpdateMinorBloc>().add(
                                        UpdateMinorEvent(minor: updatedMinor));
                                    widget.onSave(updatedMinor);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Por favor, corrija los errores en el formulario antes de guardar'),
                                      backgroundColor:
                                          Color.fromARGB(255, 55, 57, 82),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Guardar cambios',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: const Color.fromARGB(
                                            255, 55, 57, 82),
                                      )),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.save,
                                      size: 28,
                                      color: Color.fromARGB(255, 55, 67, 82)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: 50,
                            width: 250,
                            child:
                                BlocListener<DeleteMinorBloc, DeleteMinorState>(
                              listener: (context, state) {
                                if (state is DeleteMinorSuccess) {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context, true);
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Menor eliminado correctamente'),
                                      backgroundColor:
                                          Color.fromARGB(255, 55, 57, 82),
                                    ),
                                  );

                                  context
                                      .read<GetAllMinorsBloc>()
                                      .add(GetEvent());
                                } else if (state is DeleteMinorError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Error al eliminar el menor'),
                                      backgroundColor:
                                          Color.fromARGB(255, 55, 57, 82),
                                    ),
                                  );
                                }
                              },
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 57, 64, 87),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () async {
                                  final bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 248, 251, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 400),
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade400,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Confirmar eliminación',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromARGB(
                                                      255, 43, 45, 66),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 12),
                                              const Text(
                                                '¿Está seguro de que desea eliminar este menor? Esta acción no se puede deshacer.',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 107, 114, 128),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 24),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                        side: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              229,
                                                              231,
                                                              235),
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              107,
                                                              114,
                                                              128),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red.shade400,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                          'Eliminar'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    context.read<DeleteMinorBloc>().add(
                                          DeleteMinorEvent(
                                              minorId: widget.minor.minorId
                                                  .toString()),
                                        );
                                  }
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
                                        color:
                                            Color.fromARGB(255, 248, 251, 255)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMinorInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                  'ID Menor', minorIdController, TextInputType.number, true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField('Referencia', referenceController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                  'ID Gestor', managerIdController, TextInputType.number),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDatePickerField(
                  'Fecha de Nacimiento', birthdateController, true),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField('Rango de Edad', ageRangeController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDatePickerField(
                  'Fecha Registro', registeredAtController, false),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child:
                  _buildNumberTextField('Número de Tests', testsNumController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField(
                  'Tests Completados', completedTestsController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildSexDropdown(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField('Código Postal', zipCodeController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildSchoolingLevelDropdown(
                  'Nivel Escolaridad', schoolingLevelController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                  'Observaciones Escolaridad', schoolingObservationsController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildSocioeconomicDropdown(
                  'Situación Socioeconómica', socioeconomicSituationController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                  'Enfermedades Relevantes', relevantDiseasesController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildEvaluationReasonDropdown(
                  'Motivo Evaluación', evaluationReasonController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField('Test Apgar', apgarTestController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildAdoptionDropdown(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                  'Juicio Clínico', clinicalJudgementController),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFamilyInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildNumberTextField('Edad Madre', motherAgeController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField('Edad Padre', fatherAgeController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildJobDropdown('Trabajo Madre', motherJobController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildJobDropdown('Trabajo Padre', fatherJobController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildStudiesDropdown(
                  'Estudios Madre', motherStudiesController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStudiesDropdown(
                  'Estudios Padre', fatherStudiesController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child:
                  _buildNumberTextField('Número Hermanos', siblingsController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField(
                  'Posición Hermanos', siblingsPositionController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildCivilStatusDropdown(
                  'Estado Civil Padres', parentsCivilStatusController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFamilyBackgroundDropdown(
                  'Antecedentes Familiares', familyBackgroundController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildNumberTextField(
                  'Miembros Familia', familyMembersController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                  'Discapacidades Familia', familyDisabilitiesController),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBirthInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child:
                  _buildBirthTypeDropdown('Tipo de Parto', birthTypeController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField(
                  'Semanas de Gestación', gestationWeeksController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child:
                  _buildTextField('Incidentes Parto', birthIncidentsController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberTextField(
                  'Peso al Nacer (g)', birthWeightController),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: const Color.fromARGB(255, 248, 251, 255),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 97, 135, 174))),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
      String label, TextEditingController controller, bool isBirthdate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context, isBirthdate),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una fecha';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumberTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (label == 'Referencia' && (value == null || value.isEmpty)) {
            return 'Por favor complete este campo';
          }
          if (value != null &&
              value.isNotEmpty &&
              int.tryParse(value) == null) {
            return 'Por favor ingrese un número válido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSexDropdown() {
    String initialValue;
    if (sexController.text == 'M') {
      initialValue = 'Masculino';
    } else if (sexController.text == 'F') {
      initialValue = 'Femenino';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        decoration: const InputDecoration(
          labelText: 'Sexo',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
          DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
          DropdownMenuItem(value: 'Indefinido', child: Text('Indefinido')),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Masculino') {
              sexController.text = 'M';
            } else if (newValue == 'Femenino') {
              sexController.text = 'F';
            } else {
              sexController.text = '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAdoptionDropdown() {
    String initialValue;
    if (adoptionController.text.toLowerCase() == 'true') {
      initialValue = 'Sí';
    } else if (adoptionController.text.toLowerCase() == 'false') {
      initialValue = 'No';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        decoration: const InputDecoration(
          labelText: 'Adopción',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(value: 'Sí', child: Text('Sí')),
          DropdownMenuItem(value: 'No', child: Text('No')),
          DropdownMenuItem(value: 'Indefinido', child: Text('Indefinido')),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Sí') {
              adoptionController.text = 'true';
            } else if (newValue == 'No') {
              adoptionController.text = 'false';
            } else {
              adoptionController.text = '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildJobDropdown(String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'Más de un año en situación de desempleo') {
      initialValue = 'Más de un año en situación de desempleo';
    } else if (currentValue == 'Menos de un año en situación de desempleo') {
      initialValue = 'Menos de un año en situación de desempleo';
    } else if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else if (currentValue == 'Trabajo estable') {
      initialValue = 'Trabajo estable';
    } else if (currentValue == 'Trabajo temporal') {
      initialValue = 'Trabajo temporal';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'Más de un año en situación de desempleo',
              child: Text('Más de un año en situación de desempleo',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Menos de un año en situación de desempleo',
              child: Text('Menos de un año en situación de desempleo',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Trabajo estable',
              child: Text('Trabajo estable',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Trabajo temporal',
              child: Text('Trabajo temporal',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildStudiesDropdown(String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else if (currentValue == 'Primarios') {
      initialValue = 'Primarios';
    } else if (currentValue == 'Secundarios') {
      initialValue = 'Secundarios';
    } else if (currentValue == 'Universitarios') {
      initialValue = 'Universitarios';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Primarios',
              child: Text('Primarios',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Secundarios',
              child: Text('Secundarios',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Universitarios',
              child: Text('Universitarios',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCivilStatusDropdown(
      String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'Casado') {
      initialValue = 'Casado';
    } else if (currentValue == 'Divorciado') {
      initialValue = 'Divorciado';
    } else if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else if (currentValue == 'Otros') {
      initialValue = 'Otros';
    } else if (currentValue == 'Soltero') {
      initialValue = 'Soltero';
    } else if (currentValue == 'Viudo') {
      initialValue = 'Viudo';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'Casado',
              child:
                  Text('Casado', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Divorciado',
              child: Text('Divorciado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Otros',
              child:
                  Text('Otros', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Soltero',
              child: Text('Soltero',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Viudo',
              child:
                  Text('Viudo', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBirthTypeDropdown(
      String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'Distócico: Cesárea') {
      initialValue = 'Distócico: Cesárea';
    } else if (currentValue == 'Distócico: Forceps') {
      initialValue = 'Distócico: Forceps';
    } else if (currentValue == 'Distócico: Ventosa') {
      initialValue = 'Distócico: Ventosa';
    } else if (currentValue == 'Eutócico') {
      initialValue = 'Eutócico';
    } else if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'Distócico: Cesárea',
              child: Text('Distócico: Cesárea',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Distócico: Forceps',
              child: Text('Distócico: Forceps',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Distócico: Ventosa',
              child: Text('Distócico: Ventosa',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Eutócico',
              child: Text('Eutócico',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSocioeconomicDropdown(
      String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'Alta') {
      initialValue = 'Alta';
    } else if (currentValue == 'Baja') {
      initialValue = 'Baja';
    } else if (currentValue == 'Media') {
      initialValue = 'Media';
    } else if (currentValue == 'Medio alta') {
      initialValue = 'Medio alta';
    } else if (currentValue == 'Medio baja') {
      initialValue = 'Medio baja';
    } else if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'Alta',
              child:
                  Text('Alta', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Baja',
              child:
                  Text('Baja', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Media',
              child:
                  Text('Media', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Medio alta',
              child: Text('Medio alta',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Medio baja',
              child: Text('Medio baja',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildFamilyBackgroundDropdown(
      String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'Discapacidad') {
      initialValue = 'Discapacidad';
    } else if (currentValue == 'Trastornos del desarrollo') {
      initialValue = 'Trastornos del desarrollo';
    } else if (currentValue == 'Trastornos mentales') {
      initialValue = 'Trastornos mentales';
    } else if (currentValue == 'Otros') {
      initialValue = 'Otros';
    } else if (currentValue == 'Ninguno de los anteriores') {
      initialValue = 'Ninguno de los anteriores';
    } else if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'Discapacidad',
              child: Text('Discapacidad',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Trastornos del desarrollo',
              child: Text('Trastornos del desarrollo',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Trastornos mentales',
              child: Text('Trastornos mentales',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Otros',
              child:
                  Text('Otros', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Ninguno de los anteriores',
              child: Text('Ninguno de los anteriores',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSchoolingLevelDropdown(
      String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'Educación Infantil (0-1 año)') {
      initialValue = 'Educación Infantil (0-1 año)';
    } else if (currentValue == 'Educación Infantil (1-2 años)') {
      initialValue = 'Educación Infantil (1-2 años)';
    } else if (currentValue == 'Educación Infantil (2-3 años)') {
      initialValue = 'Educación Infantil (2-3 años)';
    } else if (currentValue == 'Educación Infantil (3-4 años)') {
      initialValue = 'Educación Infantil (3-4 años)';
    } else if (currentValue == 'Educación Infantil (4-5 años)') {
      initialValue = 'Educación Infantil (4-5 años)';
    } else if (currentValue == 'Educación Infantil (5-6 años)') {
      initialValue = 'Educación Infantil (5-6 años)';
    } else if (currentValue == 'Educación Primaria (6-8 años)') {
      initialValue = 'Educación Primaria (6-8 años)';
    } else if (currentValue == 'No escolarizado') {
      initialValue = 'No escolarizado';
    } else if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'Educación Infantil (0-1 año)',
              child: Text('Educación Infantil (0-1 año)',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Educación Infantil (1-2 años)',
              child: Text('Educación Infantil (1-2 años)',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Educación Infantil (2-3 años)',
              child: Text('Educación Infantil (2-3 años)',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Educación Infantil (3-4 años)',
              child: Text('Educación Infantil (3-4 años)',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Educación Infantil (4-5 años)',
              child: Text('Educación Infantil (4-5 años)',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Educación Infantil (5-6 años)',
              child: Text('Educación Infantil (5-6 años)',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Educación Primaria (6-8 años)',
              child: Text('Educación Primaria (6-8 años)',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No escolarizado',
              child: Text('No escolarizado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEvaluationReasonDropdown(
      String label, TextEditingController controller) {
    String initialValue;
    final currentValue = controller.text;

    if (currentValue == 'Diagnóstico') {
      initialValue = 'Diagnóstico';
    } else if (currentValue == 'Investigación-Validación') {
      initialValue = 'Investigación-Validación';
    } else if (currentValue == 'Niño sano') {
      initialValue = 'Niño sano';
    } else if (currentValue == 'Sospecha de retraso evolutivo') {
      initialValue = 'Sospecha de retraso evolutivo';
    } else if (currentValue == 'Otros') {
      initialValue = 'Otros';
    } else if (currentValue == 'Versión de prueba') {
      initialValue = 'Versión de prueba';
    } else if (currentValue == 'No informado') {
      initialValue = 'No informado';
    } else {
      initialValue = 'Indefinido';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: initialValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: const Color.fromARGB(255, 248, 251, 255),
        items: const [
          DropdownMenuItem(
              value: 'Diagnóstico',
              child: Text('Diagnóstico',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Investigación-Validación',
              child: Text('Investigación-Validación',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Niño sano',
              child: Text('Niño sano',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Sospecha de retraso evolutivo',
              child: Text('Sospecha de retraso evolutivo',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Otros',
              child:
                  Text('Otros', overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Versión de prueba',
              child: Text('Versión de prueba',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'No informado',
              child: Text('No informado',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
          DropdownMenuItem(
              value: 'Indefinido',
              child: Text('Indefinido',
                  overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Indefinido') {
              controller.text = '';
            } else {
              controller.text = newValue ?? '';
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      [TextInputType? keyboardType, bool isReadOnly = false]) {
    final isRequired =
        label == 'ID Menor' || label == 'Referencia' || label == 'ID Gestor';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: isReadOnly,
          fillColor: isReadOnly ? Color.fromARGB(255, 210, 220, 230) : null,
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
