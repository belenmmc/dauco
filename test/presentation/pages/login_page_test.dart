import 'package:dauco/domain/usecases/login_use_case.dart';
import 'package:dauco/presentation/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock classes
class MockLoginUseCase extends Mock implements LoginUseCase {}

// Simplified version of LoginPage content for testing
class LoginPageContent extends StatefulWidget {
  const LoginPageContent({super.key});

  @override
  LoginPageContentState createState() => LoginPageContentState();
}

class LoginPageContentState extends State<LoginPageContent> {
  bool isObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 203, 220, 238),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Bienvenido a DAUCO",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Scaffold(body: Text('Home Page'))),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Sesión iniciada correctamente')),
                        );
                      } else if (state is LoginError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
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
                            const Text('Email',
                                style: TextStyle(color: Colors.black)),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'usuario@ejemplo.com',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Contraseña',
                                style: TextStyle(color: Colors.black)),
                            TextField(
                              controller: _passwordController,
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  backgroundColor:
                                      const Color.fromARGB(255, 97, 135, 174),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<LoginBloc>().add(LoginEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ));
                                },
                                child: const Text('Iniciar sesión',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Scaffold(
                                            body: Text('Reset Password Page'))),
                                  );
                                },
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 97, 135, 174),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
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
    );
  }
}

void main() {
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
  });

  // Helper function to create a simplified widget for testing
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(loginUseCase: mockLoginUseCase),
          child: const LoginPageContent(),
        ),
      ),
      routes: {
        '/home': (context) => const Scaffold(body: Text('Home Page')),
        '/reset-password': (context) =>
            const Scaffold(body: Text('Reset Password Page')),
      },
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('renders all required UI elements',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Check all UI elements are present
      expect(find.text('Bienvenido a DAUCO'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);

      // Check input fields
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      // Check hint texts
      expect(find.text('usuario@ejemplo.com'), findsOneWidget);
      expect(find.text('••••••••'), findsOneWidget);
    });

    testWidgets('password visibility toggle works correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the password field and visibility icon
      final passwordField = find.byType(TextField).last;
      final visibilityIcon = find.byIcon(Icons.visibility_off);

      // Assert - Password is initially obscured
      expect(visibilityIcon, findsOneWidget);

      // Get the initial state of the password field
      final initialPasswordWidget = tester.widget<TextField>(passwordField);
      expect(initialPasswordWidget.obscureText, isTrue);

      // Act - Tap the visibility icon
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Assert - Password should now be visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      final updatedPasswordWidget = tester.widget<TextField>(passwordField);
      expect(updatedPasswordWidget.obscureText, isFalse);
    });

    testWidgets('login button triggers BLoC event with correct data',
        (WidgetTester tester) async {
      // Arrange
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      when(() => mockLoginUseCase.execute(testEmail, testPassword))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter email and password
      await tester.enterText(find.byType(TextField).first, testEmail);
      await tester.enterText(find.byType(TextField).last, testPassword);

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Verify the use case was called with correct parameters
      verify(() => mockLoginUseCase.execute(testEmail, testPassword)).called(1);
    });

    testWidgets('shows loading indicator during login process',
        (WidgetTester tester) async {
      // Arrange
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      // Use a shorter delay to avoid timer issues
      when(() => mockLoginUseCase.execute(testEmail, testPassword)).thenAnswer(
          (_) async => Future.delayed(const Duration(milliseconds: 100)));

      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter credentials and start login
      await tester.enterText(find.byType(TextField).first, testEmail);
      await tester.enterText(find.byType(TextField).last, testPassword);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the operation to complete
      await tester.pumpAndSettle();
    });

    testWidgets('shows error snackbar on login failure',
        (WidgetTester tester) async {
      // Arrange
      const testEmail = 'invalid@example.com';
      const testPassword = 'wrongpassword';
      const errorMessage = 'Credenciales incorrectas. Inténtelo de nuevo.';

      when(() => mockLoginUseCase.execute(testEmail, testPassword))
          .thenThrow(const AuthException('Invalid credentials'));

      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter invalid credentials and attempt login
      await tester.enterText(find.byType(TextField).first, testEmail);
      await tester.enterText(find.byType(TextField).last, testPassword);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert - Error snackbar should be visible
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('navigation to reset password page works',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Tap the "forgot password" link
      await tester.tap(find.text('¿Olvidaste tu contraseña?'));
      await tester.pumpAndSettle();

      // Assert - Should navigate to reset password page
      expect(find.text('Reset Password Page'), findsOneWidget);
    });
  });
}
