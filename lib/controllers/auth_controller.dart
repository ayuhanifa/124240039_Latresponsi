import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthController extends GetxController {
  final _db = DatabaseService.instance;

  // Input Login
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Input Register
  final registerUsernameController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmController = TextEditingController();

  // Simpan variable state
  final RxBool _isLoading = false.obs;
  final RxBool obscureLogin = true.obs;
  final RxBool obscureRegister = true.obs;

  bool get isLoading => _isLoading.value;

  void _showMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> register() async {
    final username = registerUsernameController.text.trim();
    final password = registerPasswordController.text;
    final confirm = registerConfirmController.text;

    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showMessage("Register gagal", "Semua field harus diisi");
      return;
    }
    if (password.length < 6) {
      _showMessage("Register gagal", "Password minimal 6 karakter");
      return;
    }
    if (password != confirm) {
      _showMessage("Register gagal", "Konfirmasi password tidak sama");
      return;
    }

    try {
      _isLoading.value = true;

      final success = await _db.register(
        User(username: username, password: password),
      );

      if (!success) {
        _showMessage("Register gagal", "Username sudah digunakan");
        return;
      }

      registerUsernameController.clear();
      registerPasswordController.clear();
      registerConfirmController.clear();

      // Kembali dulu ke Login, baru tampilkan snackbar
      Get.back();
      _showMessage("Berhasil", "Akun dibuat, silakan login");
    } catch (e) {
      _showMessage("Register gagal", "Terjadi kesalahan: $e");
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> login() async {
    final username = loginUsernameController.text.trim();
    final password = loginPasswordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage("Login gagal", "Username dan password harus diisi");
      return;
    }

    try {
      _isLoading.value = true;

      final user = await _db.login(username, password);

      if (user == null) {
        _showMessage("Login gagal", "Username atau password salah");
        return;
      }

      // Simpan sesi login di Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', user.username);

      loginUsernameController.clear();
      loginPasswordController.clear();

      Get.offAllNamed("/main");
    } catch (e) {
      _showMessage("Login gagal", "Terjadi kesalahan: $e");
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');

    Get.offAllNamed("/login");
  }
}
