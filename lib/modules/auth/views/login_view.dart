import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../shared/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';

/// LoginView उपयोगकर्ता को पहचान व ओटीपी दर्ज करने देता है।
class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'app_title'.tr,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'login_welcome'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _identifierController,
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.otpSent.value
                        ? TextField(
                            key: const ValueKey('otp-field'),
                            controller: _otpController,
                            decoration: InputDecoration(
                              labelText: 'otp'.tr,
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: controller.updateOtp,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => controller.otpSent.value
                      ? PrimaryButton(
                          label: 'verify'.tr,
                          isLoading: controller.isVerifying.value,
                          onPressed: controller.verifyOtp,
                          icon: Icons.verified_user,
                        )
                      : PrimaryButton(
                          label: 'send_otp'.tr,
                          onPressed: () {
                            controller.submitIdentifier(
                              _identifierController.text,
                            );
                          },
                          icon: Icons.sms,
                        ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () => _showAdminLoginDialog(context),
                  icon: const Icon(Icons.desktop_windows_outlined),
                  label: const Text('Admin console'),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.12),
                        colorScheme.secondary.withOpacity(0.12),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.policy_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Late after 10:30 → Half Day (unless approved).',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAdminLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Admin Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                // Email field
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Admin Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Password field
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        final pass = passwordController.text.trim();

                        if (email == 'admin@gmail.com' && pass == '123456') {
                          Get.back(); // close dialog
                          Get.snackbar(
                            'Login Successful',
                            'Welcome Admin!',
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          Get.offAllNamed(AppRoutes.adminShell);
                        } else {
                          Get.snackbar(
                            'Login Failed',
                            'Invalid credentials',
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
