import 'package:dauco/presentation/pages/register_page.dart';
import 'package:dauco/presentation/widgets/circular_button_widget.dart';
import 'package:flutter/material.dart';

class RegisterUserButtonWidget extends StatelessWidget {
  final VoidCallback? onUserCreated;

  const RegisterUserButtonWidget({super.key, this.onUserCreated});

  @override
  Widget build(
    BuildContext context,
  ) {
    return CircularButtonWidget(
      iconData: Icons.person_add_alt_1,
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterPage(),
          ),
        );

        // Si se creó un usuario (result == true), llamar al callback
        if (result == true && onUserCreated != null) {
          onUserCreated!();
        }
      },
    );
  }
}
