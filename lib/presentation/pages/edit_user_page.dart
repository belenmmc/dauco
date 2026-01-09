import 'package:auto_size_text/auto_size_text.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/usecases/update_user_use_case.dart';
import 'package:dauco/data/services/imported_user_service.dart';
import 'package:dauco/presentation/blocs/update_user_bloc.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injector/injector.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;

  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _managerIdController;
  TextEditingController? _surnameController;
  TextEditingController? _zoneController;
  String? _selectedRole;
  ImportedUser? _importedUser;
  bool _loadingImportedUser = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _managerIdController =
        TextEditingController(text: widget.user.managerId.toString());
    _selectedRole = widget.user.role;

    // Cargar datos de tabla Usuarios si es manager (tiene managerId > 0)
    if (widget.user.managerId > 0 && widget.user.role != 'admin') {
      _loadImportedUserData(widget.user.managerId);
    }
  }

  Future<void> _loadImportedUserData(int managerId) async {
    setState(() {
      _loadingImportedUser = true;
    });

    try {
      final importedUserService =
          Injector.appInstance.get<ImportedUserService>();
      final importedUser =
          await importedUserService.getUserByManagerId(managerId);

      if (importedUser != null) {
        setState(() {
          _importedUser = importedUser;
          _surnameController =
              TextEditingController(text: importedUser.surname);
          _zoneController = TextEditingController(text: importedUser.zone);
          _loadingImportedUser = false;
        });
      } else {
        setState(() {
          _loadingImportedUser = false;
        });
      }
    } catch (e) {
      setState(() {
        _loadingImportedUser = false;
      });
    }
  }

  void _onUpdatePressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = UserModel(
      name: _nameController.text.trim(),
      email: widget.user.email, // Usar el email original, no editable
      managerId: int.tryParse(_managerIdController.text) ?? 0,
      role: _selectedRole ?? 'user',
    );

    context.read<UpdateUserBloc>().add(UpdateUserEvent(user: updatedUser));

    // Si hay datos importados, actualizar tabla Usuarios (nombre, apellidos, zona)
    if (_importedUser != null &&
        _surnameController != null &&
        _zoneController != null) {
      final importedUserService =
          Injector.appInstance.get<ImportedUserService>();
      final updatedImportedUser = ImportedUser(
        managerId: _importedUser!.managerId,
        name: _nameController.text.trim(),
        surname: _surnameController!.text.trim(),
        zone: _zoneController!.text.trim(),
        registeredAt: _importedUser!.registeredAt,
        minorsNum: _importedUser!.minorsNum,
        yes: _importedUser!.yes,
      );
      importedUserService.updateUser(updatedImportedUser);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _managerIdController.dispose();
    _surnameController?.dispose();
    _zoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateUserBloc(
        updateUserUseCase: appInjector.get<UpdateUserUseCase>(),
      ),
      child: AppScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Text(
              'Editar Usuario',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 57, 82),
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 8,
              color: const Color.fromARGB(255, 248, 251, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: BlocConsumer<UpdateUserBloc, UpdateUserState>(
                  listener: (context, state) {
                    if (state is UpdateUserSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuario actualizado')),
                      );
                      Navigator.pop(context, true);
                    } else if (state is UpdateUserError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is UpdateUserLoading;

                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AutoSizeText(
                            "Editar información del usuario",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            minFontSize: 12,
                          ),
                          const SizedBox(height: 20),
                          // Datos editables en dos columnas
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                          labelText: 'Nombre'),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Ingresa un nombre'
                                              : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _managerIdController,
                                      enabled: false,
                                      decoration: const InputDecoration(
                                          labelText: 'ID del responsable'),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (_importedUser != null) ...[
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _zoneController,
                                        decoration: const InputDecoration(
                                          labelText: 'Zona',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    if (_importedUser != null)
                                      TextFormField(
                                        controller: _surnameController,
                                        decoration: const InputDecoration(
                                            labelText: 'Apellidos'),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? 'Ingresa los apellidos'
                                                : null,
                                      )
                                    else
                                      TextFormField(
                                        controller: _emailController,
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          hintText:
                                              'El email no se puede modificar',
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      initialValue: _selectedRole == 'admin'
                                          ? 'Administrador'
                                          : 'Responsable',
                                      enabled: false,
                                      decoration: const InputDecoration(
                                        labelText: 'Rol',
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (_importedUser != null) ...[
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        initialValue:
                                            _importedUser!.minorsNum.toString(),
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Número de Menores',
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Campos de solo lectura en fila completa
                          if (_importedUser != null) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'El email no se puede modificar',
                              ),
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue:
                                  '${_importedUser!.registeredAt.day.toString().padLeft(2, '0')}/${_importedUser!.registeredAt.month.toString().padLeft(2, '0')}/${_importedUser!.registeredAt.year}',
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Fecha de Alta',
                              ),
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'El email no se puede modificar',
                              ),
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _onUpdatePressed(context),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                backgroundColor:
                                    const Color.fromARGB(255, 97, 135, 174),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text("Editar perfil",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
