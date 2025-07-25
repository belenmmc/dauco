import 'package:dauco/presentation/pages/register_page.dart';
import 'package:dauco/presentation/widgets/circular_button_widget.dart';
import 'package:flutter/material.dart';

class RegisterUserButtonWidget extends StatelessWidget {
  const RegisterUserButtonWidget({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return CircularButtonWidget(
      iconData: Icons.person_add_alt_1,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ),
      ),
    );
  }
}
