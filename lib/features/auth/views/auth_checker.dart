import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import 'login_view.dart';
import '../../../core/ui/main_scaffold.dart';
import '../../../core/constants/app_colors.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) return const MainScaffold();
        return const LoginView();
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
