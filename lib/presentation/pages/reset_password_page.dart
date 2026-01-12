import 'package:auto_size_text/auto_size_text.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/usecases/reset_password_use_case.dart';
import 'package:dauco/presentation/blocs/reset_password_bloc.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(
          resetPasswordUseCase: appInjector.get<ResetPasswordUseCase>()),
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
                  'Restablecer contraseña',
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
              color: const Color.fromARGB(255, 248, 251, 255),
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
                        "Ingresa tu email para recibir un enlace de restablecimiento",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        minFontSize: 12,
                        stepGranularity: 1,
                      ),
                      const SizedBox(height: 24),
                      BlocListener<ResetPasswordBloc, ResetPasswordState>(
                        listener: (context, state) {
                          if (state is ResetPasswordSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Se ha enviado un enlace de restablecimiento a tu email'),
                                backgroundColor:
                                    Color.fromARGB(255, 55, 57, 82),
                              ),
                            );
                            Navigator.pop(context);
                          } else if (state is ResetPasswordError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Error al restablecer la contraseña'),
                                backgroundColor:
                                    Color.fromARGB(255, 55, 57, 82),
                              ),
                            );
                          }
                        },
                        child:
                            BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                          builder: (context, state) {
                            if (state is ResetPasswordLoading) {
                              return const CircularProgressIndicator();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingresa un email';
                                    }
                                    final emailRegex = RegExp(
                                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Email inválido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18.0),
                                      backgroundColor: const Color.fromARGB(
                                          255, 97, 135, 174),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<ResetPasswordBloc>().add(
                                            ResetPasswordRequestEvent(
                                                email: _emailController.text));
                                      }
                                    },
                                    child: const Text('Enviar enlace',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Volver al login',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 97, 135, 174))),
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
            ),
          ),
        ),
      ),
    );
  }
}
