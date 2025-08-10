import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null);
}

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) {
  return UserProvider();
});
