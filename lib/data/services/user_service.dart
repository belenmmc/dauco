import 'package:dauco/data/services/mappers/user_mapper.dart';
import 'package:dauco/data/services/imported_user_service.dart';
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

    // Validar que el managerId existe en la tabla Usuarios solo si es manager
    if (role == 'manager' && managerId > 0) {
      final importedUserService = ImportedUserService();
      final managerExists =
          await importedUserService.existsManagerId(managerId);
      if (!managerExists) {
        throw Exception(
            'El ID de responsable $managerId no existe en la base de datos. '
            'Debe importar primero los usuarios desde el archivo Excel.');
      }
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
          final errorMessage =
              rpcResult?['error']?.toString() ?? 'Error desconocido';
          if (errorMessage.contains('already') ||
              errorMessage.contains('duplicate')) {
            throw Exception('Ya existe un usuario con el email: $email');
          }
          throw Exception('RPC falló: $errorMessage');
        }
      } catch (rpcError) {
        if (rpcError.toString().contains('Ya existe un usuario')) {
          rethrow;
        }
      }

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
    } on AuthException catch (authError) {
      if (authError.message.contains('already') ||
          authError.message.contains('duplicate') ||
          authError.message.contains('registered')) {
        throw Exception('Ya existe un usuario registrado con el email: $email');
      } else {
        throw Exception('Error de autenticación: ${authError.message}');
      }
    } catch (error) {
      if (error.toString().contains('Ya existe un usuario')) {
        rethrow;
      } else if (error.toString().contains('User already registered')) {
        throw Exception('Ya existe un usuario registrado con el email: $email');
      } else if (error.toString().contains('duplicate') ||
          error.toString().contains('unique constraint')) {
        throw Exception('Ya existe un usuario con el email: $email');
      } else {
        rethrow;
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
    try {
      // Primero obtener el managerId del usuario antes de borrarlo
      final userData = await Supabase.instance.client
          .from('usuarios')
          .select('manager_id')
          .eq('email', email)
          .maybeSingle();

      // Borrar de tabla de autenticación
      await Supabase.instance.client.rpc('delete_user', params: {
        'user_email': email,
      });

      // Si el usuario tenía managerId, borrar también de tabla Usuarios
      if (userData != null && userData['manager_id'] != null) {
        final importedUserService = ImportedUserService();
        await importedUserService
            .deleteUserByManagerId(userData['manager_id'] as int);
      }
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  Future<List<UserModel>> getAllUsers(
    int page, {
    String? filterName,
    String? filterEmail,
    String? filterRole,
    String? filterManagerId,
  }) async {
    final session = Supabase.instance.client.auth.currentSession;
    String? currentUserEmail = session?.user.email;

    int limit = 10;

    final from = page * limit;
    final to = from + limit - 1;

    // Use usuarios table (lowercase) and filter by name field (which contains nombre + apellidos)
    var query = Supabase.instance.client.from('usuarios').select();

    if (currentUserEmail != null) {
      query = query.neq('email', currentUserEmail);
    }

    // Apply filters
    if (filterName != null && filterName.isNotEmpty) {
      query = query.ilike('name', '%$filterName%');
    }

    if (filterEmail != null && filterEmail.isNotEmpty) {
      query = query.ilike('email', '%$filterEmail%');
    }

    if (filterRole != null && filterRole.isNotEmpty) {
      query = query.eq('role', filterRole);
    }

    if (filterManagerId != null && filterManagerId.isNotEmpty) {
      query = query.eq('manager_id', filterManagerId);
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
