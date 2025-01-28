import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  Future<void> login(String email, String password) async {
    await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);
  }
}
