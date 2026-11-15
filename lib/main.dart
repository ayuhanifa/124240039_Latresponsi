import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bindings/detail_binding.dart';
import 'bindings/initial_binding.dart';
import 'bindings/main_binding.dart';
import 'models/user.dart';
import 'views/detail_screen.dart';
import 'views/login_screen.dart';
import 'views/main_screen.dart';
import 'views/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive & buka box untuk akun (Login/Register)
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  // Cek sesi login di Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rick & Morty Character Explorer",
      theme: ThemeData(colorSchemeSeed: const Color(0xFFBFDFFF), useMaterial3: true),
      initialBinding: InitialBinding(),
      
      // Halaman utama hanya bisa diakses kalau sudah login
      initialRoute: isLoggedIn ? "/main" : "/login",
      getPages: [
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/register", page: () => RegisterScreen()),
        GetPage(
          name: "/main",
          page: () => MainScreen(),
          binding: MainBinding(),
        ),
        GetPage(
          name: "/detail",
          page: () => DetailScreen(),
          binding: DetailBinding(),
        ),
      ],
    );
  }
}
