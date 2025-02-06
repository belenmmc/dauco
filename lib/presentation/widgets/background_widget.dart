import 'package:dauco/presentation/pages/home_page.dart';
import 'package:dauco/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Background extends StatelessWidget {
  final String title;
  final bool? home;
  final Widget? page;
  final bool showAppBar;

  const Background({
    super.key,
    required this.title,
    this.home,
    this.page,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: showAppBar
          ? AppBar(
              toolbarHeight: 100, // Increase the height of the AppBar
              leading: (home ?? true)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 48),
                      onPressed: () {
                        if (page != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => page ?? Container()),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    )
                  : null,
              title: Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 40.0), // Add top padding
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 43, 45, 66),
                  ),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 151, 153, 202), // Sky Blue
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.access_alarm),
                  ),
                ),
              ],
            )
          : null,
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 151, 153, 202)),
      ),
    );
  }
}
