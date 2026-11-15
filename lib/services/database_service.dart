import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

// Local database (Hive) untuk menyimpan akun Login & Register.
// Box 'users' dibuka di main.dart
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Box<User> get _box => Hive.box<User>('users');

  // Return false kalau username sudah dipakai
  Future<bool> register(User user) async {
    final exists = _box.values.any((u) => u.username == user.username);
    if (exists) return false;

    await _box.add(user); 
    return true;
  }

  // Return null kalau username/password salah
  Future<User?> login(String username, String password) async {
    for (final user in _box.values) {
      if (user.username == username && user.password == password) {
        return user;
      }
    }
    return null;
  }
}
