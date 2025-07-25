import 'package:dauco/presentation/blocs/logout_bloc.dart';
import 'package:dauco/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key, required BuildContext context});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(237, 247, 238, 255),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
        onPressed: () {
          context.read<LogoutBloc>().add(LogoutEvent());
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Cerrar sesión',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Color.fromARGB(255, 43, 45, 66),
                )),
            const SizedBox(width: 10),
            const Icon(Icons.logout,
                size: 28, color: Color.fromARGB(255, 55, 57, 82)),
          ],
        ),
      ),
    );
  }
}
