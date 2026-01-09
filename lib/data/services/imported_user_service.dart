import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImportedUserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Obtiene los datos de un usuario profesional por su responsable_id
  Future<ImportedUser?> getUserByManagerId(int managerId) async {
    try {
      final response = await _supabase
          .from('Usuarios')
          .select()
          .eq('responsable_id', managerId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ImportedUser(
        managerId: response['responsable_id'] as int,
        name: response['nombre'] as String,
        surname: response['apellidos'] as String,
        yes: response['si'] as bool,
        registeredAt: DateTime.parse(response['alta'] as String),
        zone: response['zona'] as String,
        minorsNum: response['num_menores'] as int,
      );
    } catch (e) {
      print('Error al obtener usuario por managerId: $e');
      return null;
    }
  }

  /// Verifica si existe un usuario con el responsable_id dado
  Future<bool> existsManagerId(int managerId) async {
    try {
      final response = await _supabase
          .from('Usuarios')
          .select('responsable_id')
          .eq('responsable_id', managerId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error al verificar managerId: $e');
      return false;
    }
  }

  /// Actualiza los datos de un usuario profesional
  Future<void> updateUser(ImportedUser user) async {
    try {
      await _supabase.from('Usuarios').update({
        'nombre': user.name,
        'apellidos': user.surname,
        'zona': user.zone,
        'num_menores': user.minorsNum,
      }).eq('responsable_id', user.managerId);
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  /// Elimina un usuario de la tabla Usuarios
  Future<void> deleteUserByManagerId(int managerId) async {
    try {
      await _supabase.from('Usuarios').delete().eq('responsable_id', managerId);
    } catch (e) {
      throw Exception('Error al eliminar usuario de tabla Usuarios: $e');
    }
  }

  /// Obtiene todos los usuarios profesionales (para admin)
  Future<List<ImportedUser>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('Usuarios')
          .select()
          .order('apellidos', ascending: true);

      return (response as List).map((user) {
        return ImportedUser(
          managerId: user['responsable_id'] as int,
          name: user['nombre'] as String,
          surname: user['apellidos'] as String,
          yes: user['si'] as bool,
          registeredAt: DateTime.parse(user['alta'] as String),
          zone: user['zona'] as String,
          minorsNum: user['num_menores'] as int,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener todos los usuarios: $e');
    }
  }

  /// Crea un nuevo usuario en la tabla Usuarios (cuando se crea usuario auth)
  Future<void> createUser(ImportedUser user) async {
    try {
      await _supabase.from('Usuarios').insert(user.toJson());
    } catch (e) {
      throw Exception('Error al crear usuario en tabla Usuarios: $e');
    }
  }

  /// Genera un ID único que no exista en la tabla Usuarios
  Future<int> generateUniqueManagerId() async {
    try {
      // Obtener el ID máximo actual
      final response = await _supabase
          .from('Usuarios')
          .select('responsable_id')
          .order('responsable_id', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        // No hay usuarios, empezar desde 1
        return 1;
      }

      // Retornar el máximo + 1
      return (response['responsable_id'] as int) + 1;
    } catch (e) {
      print('Error al generar ID único: $e');
      // Si hay error, usar timestamp como fallback
      return DateTime.now().millisecondsSinceEpoch % 1000000;
    }
  }
}
