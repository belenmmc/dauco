import 'package:auto_size_text/auto_size_text.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/usecases/get_current_user_use_case.dart';
import 'package:dauco/domain/usecases/get_imported_user_use_case.dart';
import 'package:dauco/domain/usecases/update_imported_user_use_case.dart';
import 'package:dauco/domain/usecases/logout_use_case.dart';
import 'package:dauco/domain/usecases/update_password_use_case.dart';
import 'package:dauco/domain/usecases/update_user_use_case.dart';
import 'package:dauco/presentation/blocs/logout_bloc.dart';
import 'package:dauco/presentation/blocs/update_user_bloc.dart';
import 'package:dauco/presentation/blocs/get_current_user_bloc.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:dauco/presentation/widgets/logout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dauco/data/services/imported_user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _managerIdController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Campos adicionales de tabla Usuarios
  final _surnameController = TextEditingController();
  final _zoneController = TextEditingController();
  final _registeredAtController = TextEditingController();
  final _minorsNumController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  UserModel? _currentUser;
  ImportedUser? _importedUser;
  bool _loadingImportedUser = false;

  void _setUserData(UserModel user) {
    // Separar nombre y apellidos del campo name
    final nameParts = user.name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    _nameController.text = firstName;
    _surnameController.text = lastName;
    _emailController.text = user.email;
    _managerIdController.text = user.managerId.toString();
    _roleController.text =
        user.role == 'admin' ? 'Administrador' : 'Responsable';
    _currentUser = user;

    // Cargar datos de tabla Usuarios si es profesional (tiene managerId > 0)
    if (user.managerId > 0 && _importedUser == null) {
      // Usar addPostFrameCallback para evitar setState durante build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadImportedUserData(user.managerId);
      });
    }
  }

  Future<void> _loadImportedUserData(int managerId) async {
    setState(() {
      _loadingImportedUser = true;
    });

    try {
      final importedUserService = ImportedUserService();
      final importedUser =
          await importedUserService.getUserByManagerId(managerId);

      if (importedUser != null) {
        setState(() {
          _importedUser = importedUser;
          // Actualizar nombre y apellidos desde tabla Usuarios
          _nameController.text = importedUser.name;
          _surnameController.text = importedUser.surname;
          _zoneController.text = importedUser.zone;
          _registeredAtController.text =
              '${importedUser.registeredAt.day.toString().padLeft(2, '0')}/${importedUser.registeredAt.month.toString().padLeft(2, '0')}/${importedUser.registeredAt.year}';
          _minorsNumController.text = '${importedUser.minorsNum} menores';
          _loadingImportedUser = false;
        });
      } else {
        setState(() {
          _loadingImportedUser = false;
        });
      }
    } catch (e) {
      print('Error loading imported user data: $e');
      setState(() {
        _loadingImportedUser = false;
      });
    }
  }

  Future<void> _confirmAndUpdate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: const Color.fromARGB(255, 248, 251, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 97, 135, 174),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Confirmar cambios",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 43, 45, 66),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "¿Deseas actualizar tu perfil?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 107, 114, 128),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 229, 231, 235),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Color.fromARGB(255, 107, 114, 128),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 97, 135, 174),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Confirmar"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (confirm == true) {
        bool hasChanges = false;

        // Concatenar nombre + apellidos para el campo name en usuarios
        final String fullName =
            '${_nameController.text.trim()} ${_surnameController.text.trim()}';

        final updatedUser = UserModel(
          name: fullName,
          email: _currentUser?.email ?? '',
          managerId: _currentUser?.managerId ?? 0,
          role: _currentUser?.role ?? '',
        );

        if (updatedUser.name != _currentUser?.name) {
          context
              .read<UpdateUserBloc>()
              .add(UpdateUserEvent(user: updatedUser));
          hasChanges = true;
        }

        // Actualizar apellidos y zona en la tabla Usuarios si cambiaron
        if (_importedUser != null) {
          if (_nameController.text != _importedUser!.name ||
              _surnameController.text != _importedUser!.surname ||
              _zoneController.text != _importedUser!.zone) {
            try {
              final importedUserService = ImportedUserService();
              final updatedImportedUser = ImportedUser(
                managerId: _importedUser!.managerId,
                name: _nameController.text.trim(),
                surname: _surnameController.text.trim(),
                yes: _importedUser!.yes,
                registeredAt: _importedUser!.registeredAt,
                zone: _zoneController.text.trim(),
                minorsNum: _importedUser!.minorsNum,
              );

              await importedUserService.updateUser(updatedImportedUser);

              setState(() {
                _importedUser = updatedImportedUser;
              });

              hasChanges = true;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Datos actualizados exitosamente"),
                  backgroundColor: Color.fromARGB(255, 55, 57, 82),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error al actualizar los datos"),
                  backgroundColor: Color.fromARGB(255, 55, 57, 82),
                ),
              );
            }
          }
        }

        if (_passwordController.text.isNotEmpty) {
          try {
            final updatePasswordUseCase =
                appInjector.get<UpdatePasswordUseCase>();
            await updatePasswordUseCase.execute(_passwordController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Contraseña actualizada exitosamente"),
                backgroundColor: Color.fromARGB(255, 55, 57, 82),
              ),
            );
            _passwordController.clear();
            _confirmPasswordController.clear();
            hasChanges = true;
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error al actualizar la contraseña"),
                backgroundColor: Color.fromARGB(255, 55, 57, 82),
              ),
            );
          }
        }

        if (!hasChanges) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No se detectaron cambios"),
              backgroundColor: Color.fromARGB(255, 55, 57, 82),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetCurrentUserBloc(
            getCurrentUserUseCase: appInjector.get<GetCurrentUserUseCase>(),
          )..add(GetUserEvent()),
        ),
        BlocProvider(
          create: (context) => UpdateUserBloc(
              updateUserUseCase: appInjector.get<UpdateUserUseCase>()),
        ),
        BlocProvider(
          create: (context) =>
              LogoutBloc(logoutUseCase: appInjector.get<LogoutUseCase>())
                ..add(LogoutEvent()),
        )
      ],
      child: AppScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mi perfil',
                  style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 55, 57, 82)),
                ),
                SizedBox(width: 20),
                LogoutWidget(context: this.context),
              ],
            ),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocListener<UpdateUserBloc, UpdateUserState>(
          listener: (context, state) {
            if (state is UpdateUserSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Perfil actualizado exitosamente"),
                  backgroundColor: Color.fromARGB(255, 55, 57, 82),
                ),
              );
            } else if (state is UpdateUserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error al actualizar el perfil"),
                  backgroundColor: Color.fromARGB(255, 55, 57, 82),
                ),
              );
            }
          },
          child: BlocBuilder<GetCurrentUserBloc, GetCurrentUserState>(
            builder: (context, userState) {
              if (userState is GetCurrentUserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (userState is GetCurrentUserError) {
                return Center(child: Text("Error: ${userState.error}"));
              } else if (userState is GetCurrentUserSuccess) {
                if (_currentUser == null) {
                  _setUserData(userState.currentUser);
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Card(
                        color: Color.fromARGB(255, 252, 254, 255),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const AutoSizeText(
                                    "Editar perfil",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 55, 57, 82),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Campos en dos columnas para todos
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                labelText: 'ID del responsable',
                                                hintText:
                                                    'El ID no se puede modificar',
                                              ),
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: _zoneController,
                                              decoration: const InputDecoration(
                                                labelText: 'Zona',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: _surnameController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Apellidos'),
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                      ? 'Ingresa los apellidos'
                                                      : null,
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: _roleController,
                                              enabled: false,
                                              decoration: const InputDecoration(
                                                labelText: 'Rol',
                                                hintText:
                                                    'El rol no se puede modificar',
                                              ),
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            const SizedBox(height: 16),
                                            if (_currentUser?.role != 'admin')
                                              TextFormField(
                                                controller:
                                                    _minorsNumController,
                                                enabled: false,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Menores Asignados',
                                                  hintText:
                                                      'Número de menores bajo su responsabilidad',
                                                ),
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Email y fecha en toda la fila
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _emailController,
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText:
                                          'El email no se puede modificar',
                                    ),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _registeredAtController,
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Fecha de Alta',
                                      hintText:
                                          'Fecha de registro en el sistema',
                                    ),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    decoration: InputDecoration(
                                      labelText: 'Nueva contraseña',
                                      hintText: 'Nueva contraseña',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      // Solo validar si se ha ingresado algo
                                      if (value != null &&
                                          value.isNotEmpty &&
                                          value.length < 6) {
                                        return 'La contraseña debe tener al menos 6 caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: !_isConfirmPasswordVisible,
                                    decoration: InputDecoration(
                                      labelText: 'Confirmar nueva contraseña',
                                      hintText: 'Confirmar nueva contraseña',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isConfirmPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isConfirmPasswordVisible =
                                                !_isConfirmPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      // Solo validar si se ha ingresado contraseña
                                      if (_passwordController.text.isNotEmpty) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor confirma la contraseña';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Las contraseñas no coinciden';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 32),
                                  BlocBuilder<UpdateUserBloc, UpdateUserState>(
                                    builder: (context, state) {
                                      final isLoading =
                                          state is UpdateUserLoading;
                                      return SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: isLoading
                                              ? null
                                              : () =>
                                                  _confirmAndUpdate(context),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18.0),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 97, 135, 174),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2),
                                                )
                                              : const Text("Editar perfil",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const Center(child: Text("No hay datos del usuario."));
            },
          ),
        ),
      ),
    );
  }
}
