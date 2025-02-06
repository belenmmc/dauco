abstract class UserRepositoryInterface {
  Future<void> login(String email, String password);

  Future<void> logout();

  Future<void> register(String email, String password);

  Future<void> resetPassword(String email);
}
