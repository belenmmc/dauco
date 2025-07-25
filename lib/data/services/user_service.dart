import 'package:dauco/data/services/mappers/user_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dauco/domain/entities/user_model.entity.dart';

class UserService {
  Future<void> login(String email, String password) async {
    await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<UserModel> getCurrentUser() async {
    final session = Supabase.instance.client.auth.currentSession;

    final user = await Supabase.instance.client
        .from('usuarios')
        .select()
        .eq('email', session!.user.email.toString())
        .single();

    print(user);

    return UserMapper.toDomain(user);
  }

  Future<void> register(
      String email, String password, int managerId, String name) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    await Supabase.instance.client.from('usuarios').insert({
      'id': response.user!.id,
      'email': email,
      'manager_id': managerId,
      'name': name,
      'role': 'manager',
    });
  }

  Future<void> editUser(UserModel user) async {
    await Supabase.instance.client.from('usuarios').update({
      'email': user.email,
      'manager_id': user.managerId,
      'name': user.name,
    }).eq('email', user.email);
  }

  Future<void> deleteUser(String email) async {
    await Supabase.instance.client.rpc('delete_user', params: {
      'user_email': email,
    });
  }

  Future<List<UserModel>> getAllUsers(int page) async {
    int limit = 10;

    final from = page * limit;
    final to = from + limit - 1;

    final response = await Supabase.instance.client
        .from('usuarios')
        .select()
        .eq('role', 'manager')
        .range(from, to)
        .order('email', ascending: true)
        .then((response) {
      return (response.toList())
          .map((item) => UserMapper.toDomain(item))
          .toList();
    });
    return response;
  }
}
