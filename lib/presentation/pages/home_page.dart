import 'package:dauco/data/services/reader_service.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/presentation/blocs/login_bloc.dart';
import 'package:dauco/domain/usercases/login_use_case.dart';
import 'package:dauco/presentation/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  LoginUserPageState createState() => LoginUserPageState();
}

class LoginUserPageState extends State<HomePage> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(loginUseCase: appInjector.get<LoginUseCase>()),
      child: Scaffold(
        body: Stack(
          children: [
            const Background(
              title: 'Cargar archivo',
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 300,
                        height: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 247, 238, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () {
                            ReaderService().readExcel();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Seleccionar\narchivo',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 43, 45, 66),
                                ),
                              ),
                              SizedBox(width: 40),
                              Icon(Icons.upload_file,
                                  size: 64,
                                  color: Color.fromARGB(255, 157, 137, 180)),
                            ],
                          ),
                        ),
                      ),
                    ],
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
