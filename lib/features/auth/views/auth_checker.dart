import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import 'login_view.dart';
import '../../../core/ui/main_scaffold.dart';
import '../../../core/constants/app_colors.dart';
import '../../settings/controllers/settings_controller.dart';

class AuthChecker extends ConsumerStatefulWidget {
  const AuthChecker({super.key});

  @override
  ConsumerState<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends ConsumerState<AuthChecker> {
  bool _hasPassedBiometric = false;
  bool _isCheckingBiometric = false;

  Future<void> _checkBiometric() async {
    if (_isCheckingBiometric) return;
    setState(() => _isCheckingBiometric = true);
    
    final settings = ref.read(settingsControllerProvider.notifier);
    final success = await settings.authenticate();
    
    if (mounted) {
      setState(() {
        _hasPassedBiometric = success;
        _isCheckingBiometric = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final settingsState = ref.watch(settingsControllerProvider);

    return authState.when(
      data: (user) {
        if (user == null) return const LoginView();
        
        // User logged in, check biometric
        if (settingsState.isBiometricEnabled && !_hasPassedBiometric) {
          // Trigger biometric prompt automatically on first render
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkBiometric();
          });
          
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, size: 80, color: AppColors.primary),
                  const SizedBox(height: 24),
                  const Text('Aplikasi Terkunci', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Gunakan sidik jari untuk membuka', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: _checkBiometric,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Buka Kunci', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        }

        return const MainScaffold();
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, trace) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Error: $e', style: const TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }
}
