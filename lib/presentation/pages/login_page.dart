import 'package:auto_size_text/auto_size_text.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/presentation/blocs/login_bloc.dart';
import 'package:dauco/domain/usercases/login_use_case.dart';
import 'package:dauco/presentation/pages/home_page.dart';
import 'package:dauco/presentation/widgets/background_widget.dart';
import 'package:dauco/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginUserPageState createState() => LoginUserPageState();
}

class LoginUserPageState extends State<LoginPage> {
  bool isObscure = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(loginUseCase: appInjector.get<LoginUseCase>()),
      child: Scaffold(
        body: Stack(
          children: [
            const Background(
              title: 'Inicia sesión',
              home: false,
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AutoSizeText(
                          "Bienvenido a DAUCO",
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
                        BlocListener<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login successful!'),
                                ),
                              );
                            } else if (state is LoginError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.error),
                                ),
                              );
                            }
                          },
                          child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                            if (state is LoginLoading) {
                              return const CircularProgressIndicator();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  text: 'Email',
                                  color: Colors.black,
                                ),
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: 'user@example.com',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const CustomText(
                                  text: 'Password',
                                  color: Colors.black,
                                ),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: isObscure,
                                  decoration: InputDecoration(
                                    hintText: '••••••••',
                                    border: const OutlineInputBorder(),
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
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      print(_emailController.text);
                                      context.read<LoginBloc>().add(LoginEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text));
                                    },
                                    child: const Text('Login'),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
