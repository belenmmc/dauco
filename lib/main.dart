import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  initInjection();
  runApp(const Dauco());
}

class Dauco extends StatelessWidget {
  const Dauco({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dauco',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
