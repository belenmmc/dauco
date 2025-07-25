import 'package:auto_size_text/auto_size_text.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/domain/usecases/get_current_user_use_case.dart';
import 'package:dauco/domain/usecases/logout_use_case.dart';
import 'package:dauco/domain/usecases/update_user_use_case.dart';
import 'package:dauco/presentation/blocs/logout_bloc.dart';
import 'package:dauco/presentation/blocs/update_user_bloc.dart';
import 'package:dauco/presentation/blocs/get_current_user_bloc.dart';
import 'package:dauco/presentation/widgets/logout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  UserModel? _currentUser;

  void _setUserData(UserModel user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _managerIdController.text = user.managerId.toString();
    _roleController.text = user.role;
    _currentUser = user;
  }

  Future<void> _confirmAndUpdate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirmar cambios"),
          content: const Text("¿Deseas actualizar tu perfil?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Confirmar"),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final updatedUser = UserModel(
          name: _nameController.text,
          email: _emailController.text,
          managerId: int.tryParse(_managerIdController.text) ?? 0,
          role: _roleController.text,
        );

        if (updatedUser == _currentUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No se detectaron cambios.")),
          );
          return;
        }

        context.read<UpdateUserBloc>().add(UpdateUserEvent(user: updatedUser));
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
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 167, 168, 213),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mi perfil',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
                LogoutWidget(context: this.context),
              ],
            ),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255, 167, 168, 213),
        ),
        body: BlocListener<UpdateUserBloc, UpdateUserState>(
          listener: (context, state) {
            if (state is UpdateUserSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Perfil actualizado exitosamente")),
              );
            } else if (state is UpdateUserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.error}")),
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
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AutoSizeText(
                                "Editar perfil",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: 'Nombre'),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Ingresa un nombre'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa un email';
                                  }
                                  final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Email inválido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _managerIdController,
                                decoration: const InputDecoration(
                                    labelText: 'ID del responsable'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa un ID';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'ID inválido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _roleController,
                                decoration:
                                    const InputDecoration(labelText: 'Rol'),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Ingresa un rol'
                                        : null,
                              ),
                              const SizedBox(height: 32),
                              BlocBuilder<UpdateUserBloc, UpdateUserState>(
                                builder: (context, state) {
                                  final isLoading = state is UpdateUserLoading;
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => _confirmAndUpdate(context),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : const Text("Editar perfil"),
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
