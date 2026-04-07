import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../injection/injection.dart';
import '../../core/utils/auth_notifier.dart';

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
import '../../features/profile/presentation/screens/subscription_plans_screen.dart';

// Subscription BLoC
import '../../features/subscription/presentation/bloc/subscription_bloc.dart';

// Missing Imports
import '../../features/profile/presentation/screens/personal_info_screen.dart';
import '../../features/profile/presentation/screens/company_info_screen.dart';
import '../../features/profile/presentation/screens/my_tickets_screen.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/security/presentation/screens/security_screen.dart';
import '../../features/repository/presentation/screens/repository_screen.dart';
import '../../features/academy/presentation/screens/quiz_screen.dart';
import '../../features/academy/presentation/screens/lesson_player_screen.dart';
import '../../features/academy/presentation/screens/certificate_screen.dart';
import '../../features/erp/presentation/screens/api_erp_screen.dart';
import '../../features/erp/presentation/bloc/erp_bloc.dart';
import '../../features/assistant/presentation/screens/nandina_classifier_screen.dart';
import '../../features/assistant/presentation/bloc/assistant_bloc.dart';
import '../../features/assistant/presentation/screens/agent_contact_screen.dart';

final _authNotifier = sl<AuthNotifier>();

final appRouter = GoRouter(
  initialLocation: '/home',
  refreshListenable: _authNotifier,
  redirect: (context, state) {
    final isAuthenticated = _authNotifier.isAuthenticated;
    final authRoutes = {'/login', '/register', '/otp', '/forgot-password'};
    final isAuthRoute = authRoutes.contains(state.matchedLocation);

    // Unauthenticated user trying to access protected route → go to login
    if (!isAuthenticated && !isAuthRoute) return '/home';
    // Authenticated user on an auth route → go to home
    if (isAuthenticated && isAuthRoute) return '/home';
    // No redirect needed
    return null;
  },
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
    GoRoute(
      path: '/subscription-plans',
      builder: (context, state) => BlocProvider<SubscriptionBloc>(
        create: (_) => sl<SubscriptionBloc>(),
        child: const SubscriptionPlansScreen(),
      ),
    ),
    GoRoute(
      path: '/personal-info',
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: '/company-info',
      builder: (context, state) => BlocProvider<ProfileBloc>(
        create: (_) => sl<ProfileBloc>(),
        child: const CompanyInfoScreen(),
      ),
    ),
    GoRoute(
      path: '/my-tickets',
      builder: (context, state) => const MyTicketsScreen(),
    ),
    GoRoute(
      path: '/security',
      builder: (context, state) => const SecurityScreen(),
    ),
    GoRoute(
      path: '/repository',
      builder: (context, state) => const RepositoryScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/quiz-results',
      builder: (context, state) => const QuizResultsScreen(),
    ),
    GoRoute(
      path: '/certificate',
      builder: (context, state) => const CertificateScreen(),
    ),
    GoRoute(
      path: '/lesson-player',
      builder: (context, state) => const LessonPlayerScreen(),
    ),
    GoRoute(
      path: '/api-erp',
      builder: (context, state) => BlocProvider<ErpBloc>(
        create: (_) => sl<ErpBloc>(),
        child: const ApiErpScreen(),
      ),
    ),
    GoRoute(
      path: '/nandina-classifier',
      builder: (context, state) => BlocProvider<AssistantBloc>(
        create: (_) => sl<AssistantBloc>(),
        child: const NandinaClassifierScreen(),
      ),
    ),
    GoRoute(
      path: '/agent-contact',
      builder: (context, state) {
        final agent = state.extra as Agent;
        return AgentContactScreen(agent: agent);
      },
    ),
  ],
);
