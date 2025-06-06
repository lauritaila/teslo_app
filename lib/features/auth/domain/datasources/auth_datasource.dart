import 'package:teslo_shop/features/auth/domain/domain.dart';

abstract class AuthDataSource {
  Future<User> login( String email, String password );
  Future<User> checkAuthStatus( String token );
  Future<User> register( String email, String password, String fullName );
}