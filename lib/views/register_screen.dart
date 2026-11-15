import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      // Morty Smith
      imageUrl: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
      tagline: "JOIN THE\nADVENTURE.",
      form: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            title: "CREATE ACCOUNT",
            subtitle: "Fill in the details below to get started",
          ),
          const SizedBox(height: 24),
          AuthField(
            label: "Username",
            hint: "Enter your username",
            controller: controller.registerUsernameController,
          ),
          const SizedBox(height: 14),
          Obx(() {
            return AuthField(
              label: "Password",
              hint: "Enter your password",
              controller: controller.registerPasswordController,
              obscure: controller.obscureRegister.value,
              suffix: IconButton(
                icon: Icon(
                  controller.obscureRegister.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => controller.obscureRegister.toggle(),
              ),
            );
          }),
          const SizedBox(height: 14),
          Obx(() {
            return AuthField(
              label: "Confirm Password",
              hint: "Re-enter your password",
              controller: controller.registerConfirmController,
              obscure: controller.obscureRegister.value,
            );
          }),
          const SizedBox(height: 24),
          Obx(() {
            return AuthButton(
              label: "Sign Up",
              isLoading: controller.isLoading,
              onPressed: controller.register,
            );
          }),
          const SizedBox(height: 16),
          AuthSwitchLink(
            text: "Already have an account? ",
            action: "Sign in",
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}