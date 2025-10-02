import 'package:auto_size_text/auto_size_text.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';
import 'package:dauco/domain/usecases/update_user_use_case.dart';
import 'package:dauco/presentation/blocs/update_user_bloc.dart';
import 'package:dauco/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String? _selectedRole;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _managerIdController =
        TextEditingController(text: widget.user.managerId.toString());
    _selectedRole = widget.user.role;
    super.initState();
  }

  void _onUpdatePressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = UserModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      managerId: int.tryParse(_managerIdController.text) ?? 0,
      role: _selectedRole ?? 'user',
    );

    context.read<UpdateUserBloc>().add(UpdateUserEvent(user: updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateUserBloc(
        updateUserUseCase: appInjector.get<UpdateUserUseCase>(),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 167, 190, 213),
        appBar: AppBar(
          title: const Text('Editar Usuario'),
          backgroundColor: const Color.fromARGB(255, 167, 190, 213),
          centerTitle: true,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
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
                          const CustomText(text: 'Nombre', color: Colors.black),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Nombre completo',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Requerido'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          const CustomText(text: 'Email', color: Colors.black),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'usuario@ejemplo.com',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Requerido'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          const CustomText(
                              text: 'ID del Manager', color: Colors.black),
                          TextFormField(
                            controller: _managerIdController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Ej: 123',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || int.tryParse(value) == null
                                    ? 'Debe ser un número'
                                    : null,
                          ),
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
                                  : const Text('Guardar cambios',
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
