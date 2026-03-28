import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../injection/injection.dart';

// Home
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

// Security
import '../../features/security/presentation/screens/login_screen.dart';
import '../../features/security/presentation/screens/register_screen.dart';
import '../../features/security/presentation/screens/otp_verification_screen.dart';
import '../../features/security/presentation/screens/forgot_password_screen.dart';
import '../../features/security/presentation/bloc/auth/auth_bloc.dart';
import '../../features/checklist/presentation/screens/checklist_screen.dart';
import '../../features/calculator/presentation/screens/calculator_screen.dart';
import '../../features/logistics/presentation/screens/logistics_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/alerts/presentation/screens/alert_detail_screen.dart';
import '../../features/alerts/domain/entities/alert_entity.dart';

// Assistant
import '../../features/assistant/presentation/screens/import_assistant_screen.dart';
import '../../features/assistant/presentation/screens/export_assistant_screen.dart';
import '../../features/assistant/presentation/screens/agents_screen.dart';
import '../../features/assistant/presentation/screens/agent_profile_screen.dart';
import '../../features/assistant/domain/entities/agent.dart';

// Academy
import '../../features/academy/presentation/screens/knowledge_center_screen.dart';

// Profile
import '../../features/profile/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/notification_settings_screen.dart';
import '../../features/profile/presentation/screens/tutorials_screen.dart';
import '../../features/profile/presentation/screens/support_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  // TODO: Add redirect guard here using Security/Auth state once it's persistent
  routes: [
    // ── Security ─────────────────────────────────────────────────────────────
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: OtpVerificationScreen(
            maskedEmail: extra['maskedEmail'] as String? ?? '',
            flowType: extra['flowType'] as OtpFlowType? ?? OtpFlowType.register,
          ),
        );
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: const ForgotPasswordScreen(),
      ),
    ),

    // ── Home ─────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/home',
      builder: (context, state) => BlocProvider<HomeBloc>(
        create: (_) => sl<HomeBloc>(),
        child: const HomeScreen(),
      ),
    ),

    // ── Tools & Operations ───────────────────────────────────────────────────
    GoRoute(
      path: '/checklist',
      builder: (context, state) => const ChecklistScreen(),
    ),
    GoRoute(
      path: '/calculator',
      builder: (context, state) => const CalculatorScreen(),
    ),
    GoRoute(
      path: '/logistics',
      builder: (context, state) => const LogisticsScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const AlertsScreen(),
    ),
    GoRoute(
      path: '/alert-detail',
      builder: (context, state) {
        final alert = state.extra as AlertEntity;
        return AlertDetailScreen(alert: alert);
      },
    ),

    // ── Assistant ────────────────────────────────────────────────────────────
    GoRoute(
      path: '/import-assistant',
      builder: (context, state) => const ImportAssistantScreen(),
    ),
    GoRoute(
      path: '/export-assistant',
      builder: (context, state) => const ExportAssistantScreen(),
    ),
    GoRoute(
      path: '/agents',
      builder: (context, state) => const AgentsScreen(),
    ),
    GoRoute(
      path: '/agent-profile',
      builder: (context, state) {
        final agent = state.extra as Agent;
        return AgentProfileScreen(agent: agent);
      },
    ),

    // ── Academy ──────────────────────────────────────────────────────────────
    GoRoute(
      path: '/knowledge-center',
      builder: (context, state) => const KnowledgeCenterScreen(),
    ),

    // ── Profile ──────────────────────────────────────────────────────────────
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/notification-settings',
      builder: (context, state) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/tutorials',
      builder: (context, state) => const TutorialsScreen(),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => const SupportScreen(),
    ),
  ],
);
