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

  Future<void> resetPassword(String email) async {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword(String newPassword) async {
    await Supabase.instance.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<UserModel> getCurrentUser() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      throw Exception('No hay sesión activa. Por favor, inicia sesión.');
    }

    try {
      final user = await Supabase.instance.client
          .from('usuarios')
          .select()
          .eq('email', session.user.email.toString())
          .single();

      print(user);

      return UserMapper.toDomain(user);
    } catch (e) {
      throw Exception('Error al obtener datos del usuario: $e');
    }
  }

  Future<void> register(String email, String password, int managerId,
      String name, String role) async {
    final adminSession = Supabase.instance.client.auth.currentSession;
    if (adminSession == null) {
      throw Exception('No hay sesión de admin activa para crear usuarios');
    }

    final existingUser = await Supabase.instance.client
        .from('usuarios')
        .select('email, id, manager_id')
        .or('email.eq.$email,manager_id.eq.$managerId')
        .maybeSingle();

    if (existingUser != null) {
      if (existingUser['email'] == email) {
        throw Exception('Ya existe un usuario con el email: $email');
      }
      if (existingUser['manager_id'] == managerId) {
        throw Exception(
            'Ya existe un usuario con el ID de responsable: $managerId');
      }
    }

    try {
      try {
        final rpcResult =
            await Supabase.instance.client.rpc('admin_create_user', params: {
          'user_email': email,
          'user_password': password,
          'user_name': name,
          'user_manager_id': managerId,
          'user_role': role,
        });

        if (rpcResult != null && rpcResult['success'] == true) {
          return;
        } else {
          throw Exception(
              'RPC falló: ${rpcResult?['error'] ?? 'Error desconocido'}');
        }
      } catch (rpcError) {}

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        try {
          await Supabase.instance.client.from('usuarios').insert({
            'id': response.user!.id,
            'email': email,
            'manager_id': managerId,
            'name': name,
            'role': role,
          });

          await Supabase.instance.client.auth.signOut();
        } catch (insertError) {
          await Supabase.instance.client.auth.signOut();

          if (insertError.toString().contains('duplicate') ||
              insertError.toString().contains('already exists') ||
              insertError.toString().contains('unique constraint')) {
            throw Exception('Ya existe un usuario con el email: $email');
          } else {
            throw Exception('Error al guardar datos del usuario: $insertError');
          }
        }
      } else {
        throw Exception('Error en signUp: No se recibió usuario');
      }
    } catch (error) {
      if (error.toString().contains('User already registered')) {
        throw Exception('Ya existe un usuario registrado con el email: $email');
      } else if (error.toString().contains('duplicate') ||
          error.toString().contains('unique constraint')) {
        throw Exception('Ya existe un usuario con el email: $email');
      } else {
        throw Exception('Error creando usuario: $error');
      }
    }
  }

  Future<void> editUser(UserModel user) async {
    // Solo verificar que el manager_id no esté siendo usado por otro usuario
    // (el email no se puede cambiar, así que no necesitamos validarlo)
    final existingUser = await Supabase.instance.client
        .from('usuarios')
        .select('manager_id')
        .neq('email', user.email) // Excluir el usuario actual
        .eq('manager_id', user.managerId)
        .maybeSingle();

    if (existingUser != null) {
      throw Exception(
          'Ya existe otro usuario con el ID de responsable: ${user.managerId}');
    }

    try {
      await Supabase.instance.client.from('usuarios').update({
        'manager_id': user.managerId,
        'name': user.name,
        // No actualizamos el email ya que no se puede cambiar
      }).eq('email', user.email);
    } catch (error) {
      if (error.toString().contains('duplicate') ||
          error.toString().contains('unique constraint')) {
        throw Exception('Error: Ya existe un usuario con estos datos');
      } else {
        throw Exception('Error al actualizar usuario: $error');
      }
    }
  }

  Future<void> deleteUser(String email) async {
    await Supabase.instance.client.rpc('delete_user', params: {
      'user_email': email,
    });
  }

  Future<List<UserModel>> getAllUsers(int page) async {
    final session = Supabase.instance.client.auth.currentSession;
    String? currentUserEmail = session?.user.email;

    int limit = 10;

    final from = page * limit;
    final to = from + limit - 1;

    var query = Supabase.instance.client.from('usuarios').select();

    if (currentUserEmail != null) {
      query = query.neq('email', currentUserEmail);
    }

    final response = await query
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
