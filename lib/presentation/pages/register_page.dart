import 'package:auto_size_text/auto_size_text.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/usecases/register_use_case.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/data/services/imported_user_service.dart';
import 'package:dauco/presentation/blocs/register_bloc.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _managerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _zoneController = TextEditingController();
  final _managerIdFocusNode = FocusNode();
  bool isObscure = true;
  String? _selectedRole;
  ImportedUser? _foundUser;
  bool _searchingUser = false;
  int?
      _generatedManagerId; // Para guardar el ID generado/usado al crear usuario

  @override
  void initState() {
    super.initState();
    _managerIdFocusNode.addListener(() {
      if (!_managerIdFocusNode.hasFocus &&
          _selectedRole != null &&
          _managerIdController.text.isNotEmpty) {
        // Cuando pierde el foco, buscar el usuario (tanto para manager como admin)
        _searchUserByManagerId(_managerIdController.text);
      }
    });
  }

  @override
  void dispose() {
    _managerIdFocusNode.dispose();
    super.dispose();
  }

  Future<void> _searchUserByManagerId(String managerId) async {
    if (managerId.isEmpty || int.tryParse(managerId) == null) {
      return;
    }

    setState(() {
      _searchingUser = true;
      _foundUser = null;
    });

    try {
      final importedUserService = ImportedUserService();
      final user =
          await importedUserService.getUserByManagerId(int.parse(managerId));

      setState(() {
        _foundUser = user;
        _searchingUser = false;
      });

      if (user != null && mounted) {
        // Mostrar diálogo de confirmación
        final shouldLink = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.link, color: Color.fromARGB(255, 97, 135, 174)),
                  SizedBox(width: 8),
                  Text('Usuario encontrado'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Se encontró el siguiente usuario en la base de datos:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 97, 135, 174),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Nombre', '${user.name} ${user.surname}'),
                        const SizedBox(height: 8),
                        _buildInfoRow('Zona', user.zone),
                        const SizedBox(height: 8),
                        _buildInfoRow('Fecha de Alta',
                            '${user.registeredAt.day.toString().padLeft(2, '0')}/${user.registeredAt.month.toString().padLeft(2, '0')}/${user.registeredAt.year}'),
                        const SizedBox(height: 8),
                        _buildInfoRow('Menores asignados', '${user.minorsNum}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿Deseas vincular este usuario con la cuenta de autenticación?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 97, 135, 174),
                  ),
                  child: const Text(
                    'Sí, vincular',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldLink == true) {
          // Auto-rellenar nombre, apellidos y zona
          _nameController.text = user.name;
          _surnameController.text = user.surname;
          _zoneController.text = user.zone;
        }
      } else if (user == null && mounted) {
        // No se encontró el usuario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró el usuario en la base de datos'),
            backgroundColor: Color.fromARGB(255, 55, 57, 82),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _searchingUser = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al buscar el usuario'),
            backgroundColor: Color.fromARGB(255, 55, 57, 82),
          ),
        );
      }
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegisterBloc(registerUseCase: appInjector.get<RegisterUseCase>()),
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
                  'Crear cuenta',
                  style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 55, 57, 82)),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color.fromARGB(255, 252, 254, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AutoSizeText(
                            "Crea una cuenta",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            minFontSize: 12,
                            stepGranularity: 1,
                          ),
                          const SizedBox(height: 20),
                          BlocListener<RegisterBloc, RegisterState>(
                            listener: (context, state) async {
                              if (state is RegisterSuccess) {
                                try {
                                  final importedUserService =
                                      ImportedUserService();

                                  // Usar el managerId que se guardó al crear el usuario
                                  final actualManagerId =
                                      _generatedManagerId ?? 0;

                                  // Si el usuario estaba vinculado (existía en Usuarios), actualizar
                                  if (_foundUser != null &&
                                      _selectedRole == 'manager') {
                                    final updatedImportedUser = ImportedUser(
                                      managerId: _foundUser!.managerId,
                                      name: _nameController.text.trim(),
                                      surname: _surnameController.text.trim(),
                                      yes: _foundUser!.yes,
                                      registeredAt: _foundUser!.registeredAt,
                                      zone: _zoneController.text.trim(),
                                      minorsNum: _foundUser!.minorsNum,
                                    );
                                    await importedUserService
                                        .updateUser(updatedImportedUser);
                                  } else if (actualManagerId > 0) {
                                    // Si NO estaba vinculado pero tiene managerId, crear nuevo registro en tabla Usuarios
                                    final now = DateTime.now();
                                    final registeredAt = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        now.hour,
                                        now.minute,
                                        now.second);
                                    print(
                                        '=== CREANDO USUARIO EN TABLA USUARIOS ===');
                                    print('managerId: $actualManagerId');
                                    print(
                                        'name: ${_nameController.text.trim()}');
                                    print(
                                        'surname: ${_surnameController.text.trim()}');
                                    print('registeredAt: $registeredAt');
                                    print(
                                        'registeredAt ISO: ${registeredAt.toIso8601String()}');
                                    final newImportedUser = ImportedUser(
                                      managerId: actualManagerId,
                                      name: _nameController.text.trim(),
                                      surname: _surnameController.text.trim(),
                                      yes: false,
                                      registeredAt: registeredAt,
                                      zone: _zoneController.text.isNotEmpty
                                          ? _zoneController.text.trim()
                                          : 'Sin asignar',
                                      minorsNum: 0,
                                    );
                                    await importedUserService
                                        .createUser(newImportedUser);
                                    print(
                                        'Usuario creado exitosamente en tabla Usuarios');
                                  }
                                } catch (e) {
                                  print(
                                      'Error al guardar en tabla Usuarios: $e');
                                }

                                if (!mounted) return;
                                Navigator.pop(context,
                                    true); // Devolver true para indicar que se creó el usuario
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Usuario creado exitosamente'),
                                    backgroundColor:
                                        Color.fromARGB(255, 55, 57, 82),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else if (state is RegisterError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error al crear el usuario'),
                                    backgroundColor:
                                        Color.fromARGB(255, 55, 57, 82),
                                  ),
                                );
                              }
                            },
                            child: BlocBuilder<RegisterBloc, RegisterState>(
                              builder: (context, state) {
                                if (state is RegisterLoading) {
                                  return const CircularProgressIndicator();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Banner informativo si hay usuario vinculado (solo para managers)
                                    if (_foundUser != null &&
                                        _selectedRole == 'manager')
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.green),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.check_circle,
                                                color: Colors.green, size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Usuario vinculado: ${_foundUser!.name} ${_foundUser!.surname}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    // PRIMERO: Selección de Rol
                                    DropdownButtonFormField<String>(
                                      value: _selectedRole,
                                      decoration: const InputDecoration(
                                        labelText: 'Rol',
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      dropdownColor: const Color.fromARGB(
                                          255, 248, 251, 255),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'admin',
                                          child: Text('Administrador'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'manager',
                                          child: Text('Responsable'),
                                        ),
                                      ],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedRole = newValue;
                                          // Limpiar usuario vinculado al cambiar de rol
                                          _foundUser = null;
                                          _searchingUser = false;
                                          _surnameController.clear();
                                          _zoneController.clear();
                                        });
                                      },
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Selecciona un rol'
                                              : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _managerIdController,
                                      focusNode: _managerIdFocusNode,
                                      enabled: _selectedRole != 'admin',
                                      decoration: InputDecoration(
                                        labelText: 'ID del responsable',
                                        hintText: _selectedRole == 'admin'
                                            ? 'Se generará automáticamente'
                                            : null,
                                        suffixIcon: _selectedRole ==
                                                    'manager' &&
                                                _searchingUser
                                            ? const Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2),
                                                ),
                                              )
                                            : _selectedRole == 'manager' &&
                                                    _foundUser != null
                                                ? const Icon(Icons.check_circle,
                                                    color: Colors.green)
                                                : null,
                                      ),
                                      style: _selectedRole == 'admin'
                                          ? TextStyle(color: Colors.grey[600])
                                          : null,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        // Para admin, no validar (se genera automático)
                                        if (_selectedRole == 'admin') {
                                          return null;
                                        }
                                        // Para manager, puede estar vacío (se genera automático) o ser un número válido
                                        if (value != null &&
                                            value.isNotEmpty &&
                                            int.tryParse(value) == null) {
                                          return 'ID inválido';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nombre',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ingresa un nombre';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _surnameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Apellidos',
                                      ),
                                      validator: (value) {
                                        if (_selectedRole == 'manager' &&
                                            (value == null || value.isEmpty)) {
                                          return 'Ingresa los apellidos';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _zoneController,
                                      decoration: const InputDecoration(
                                        labelText: 'Zona',
                                      ),
                                      validator: (value) {
                                        if (_selectedRole == 'manager' &&
                                            (value == null || value.isEmpty)) {
                                          return 'Ingresa la zona';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Correo electrónico',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ingresa un correo';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: isObscure,
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isObscure = !isObscure;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.length < 6) {
                                          return 'La contraseña debe tener al menos 6 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18.0),
                                          backgroundColor: const Color.fromARGB(
                                              255, 97, 135, 174),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final importedUserService =
                                                ImportedUserService();
                                            int managerId;

                                            // Si es admin, SIEMPRE generar ID automático
                                            if (_selectedRole == 'admin') {
                                              managerId =
                                                  await importedUserService
                                                      .generateUniqueManagerId();
                                              print(
                                                  'ID generado automáticamente para admin: $managerId');
                                            } else if (_selectedRole ==
                                                'manager') {
                                              // Para manager: si está vacío, generar automático
                                              if (_managerIdController
                                                  .text.isEmpty) {
                                                managerId =
                                                    await importedUserService
                                                        .generateUniqueManagerId();
                                                print(
                                                    'ID generado automáticamente para manager: $managerId');
                                              } else {
                                                // Si puso un ID, usarlo (sin advertencias)
                                                managerId = int.parse(
                                                    _managerIdController.text);
                                              }
                                            } else {
                                              // Fallback por si acaso
                                              managerId =
                                                  await importedUserService
                                                      .generateUniqueManagerId();
                                            }

                                            // Guardar el managerId para usarlo después en el listener
                                            setState(() {
                                              _generatedManagerId = managerId;
                                            });

                                            context.read<RegisterBloc>().add(
                                                RegisterEvent(
                                                    name:
                                                        '${_nameController.text.trim()} ${_surnameController.text.trim()}',
                                                    email:
                                                        _emailController.text,
                                                    managerId: managerId,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                    role: _selectedRole ?? ''));
                                          }
                                        },
                                        child: const Text('Registrarse',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))),
      ),
    );
  }
}
