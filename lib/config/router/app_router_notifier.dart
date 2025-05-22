import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

final AppRouterNotifierProvider = Provider((ref) => AppRouterNotifier(ref.read(authProvider.notifier)));

class AppRouterNotifier extends ChangeNotifier{
  final AuthNotifier _authNotifier; 
  AuthStatus _auhStatus = AuthStatus.checking;

  AppRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      _auhStatus = state.authStatus;
      notifyListeners();
    });
  }

  AuthStatus get authStatus => _auhStatus;

  set authStatus(AuthStatus authStatus) {
    _auhStatus = authStatus;
    notifyListeners();
  }
}