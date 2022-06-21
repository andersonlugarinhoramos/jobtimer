abstract class AuthService {
  Future<void> signIn();
  Future<void> signOut();
  Future<String> userName();
  Future<String> email();
  Future<String> photoUrl();
}
