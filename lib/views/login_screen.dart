import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      // Rick Sanchez
      imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      tagline: "EXPLORE.\nDISCOVER.\nCOLLECT.",
      form: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            title: "WELCOME BACK",
            subtitle: "Enter your username and password to access your account",
          ),
          const SizedBox(height: 28),
          AuthField(
            label: "Username",
            hint: "Enter your username",
            controller: controller.loginUsernameController,
          ),
          const SizedBox(height: 16),
          Obx(() {
            return AuthField(
              label: "Password",
              hint: "Enter your password",
              controller: controller.loginPasswordController,
              obscure: controller.obscureLogin.value,
              suffix: IconButton(
                icon: Icon(
                  controller.obscureLogin.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => controller.obscureLogin.toggle(),
              ),
            );
          }),
          const SizedBox(height: 24),
          Obx(() {
            return AuthButton(
              label: "Sign In",
              isLoading: controller.isLoading,
              onPressed: controller.login,
            );
          }),
          const SizedBox(height: 16),
          AuthSwitchLink(
            text: "Don't have an account? ",
            action: "Sign up",
            onTap: () => Get.toNamed("/register"),
          ),
        ],
      ),
    );
  }
}