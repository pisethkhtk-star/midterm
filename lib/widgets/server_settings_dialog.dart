import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/core/constants/api_endpoints.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/core/storage/token_storage.dart';

class ServerSettingsDialog extends StatelessWidget {
  const ServerSettingsDialog({super.key});

  static void show() {
    Get.dialog(const ServerSettingsDialog());
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: ApiEndpoints.baseUrl);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings_ethernet_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'API Server Configuration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Specify your backend API host. Examples:\n'
              '• Emulator: http://10.0.2.2:30033\n'
              '• Desktop/Web: http://localhost:30033\n'
              '• Physical Device: http://<YOUR_IP>:30033',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Base URL',
                hintText: 'http://10.0.2.2:30033',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    await TokenStorage.saveBaseUrl(ApiEndpoints.defaultBaseUrl);
                    Get.back();
                    Get.snackbar('Reset', 'Default URL restored: ${ApiEndpoints.defaultBaseUrl}',
                        backgroundColor: Colors.white,
                        colorText: AppColors.textPrimary,
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  child: const Text('Reset Default'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final newUrl = controller.text.trim();
                    if (newUrl.isNotEmpty) {
                      await TokenStorage.saveBaseUrl(newUrl);
                      Get.back();
                      Get.snackbar('Saved', 'API Base URL updated',
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

