import 'package:dauco/presentation/pages/profile_page.dart';
import 'package:dauco/presentation/widgets/circular_button_widget.dart';
import 'package:flutter/material.dart';

class ProfileButtonWidget extends StatelessWidget {
  const ProfileButtonWidget({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return CircularButtonWidget(
      iconData: Icons.person,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      ),
    );
  }
}
