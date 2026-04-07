import 'package:get_it/get_it.dart';
import '../core/utils/auth_notifier.dart';
import '../features/alerts/data/repositories/alerts_repository_impl.dart';
import '../features/alerts/domain/repositories/alerts_repository.dart';
import '../features/alerts/domain/usecases/get_alerts_usecase.dart';
import '../features/alerts/presentation/bloc/alerts_bloc.dart';
import '../features/checklist/presentation/bloc/checklist_bloc.dart';
import '../features/calculator/presentation/bloc/calculator_bloc.dart';
import '../features/security/presentation/bloc/security_bloc.dart';
import '../features/security/presentation/bloc/auth/auth_bloc.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

// Subscription
import '../features/subscription/data/repositories/subscription_repository_impl.dart';
import '../features/subscription/domain/repositories/subscription_repository.dart';
import '../features/subscription/domain/usecases/get_active_plan_usecase.dart';
import '../features/subscription/domain/usecases/change_plan_usecase.dart';
import '../features/subscription/presentation/bloc/subscription_bloc.dart';

// ERP
import '../features/erp/data/repositories/erp_repository_impl.dart';
import '../features/erp/domain/repositories/erp_repository.dart';
import '../features/erp/domain/usecases/sync_erp_usecase.dart';
import '../features/erp/presentation/bloc/erp_bloc.dart';

// Profile
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/update_company_info_usecase.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';

// Assistant
import '../features/assistant/data/repositories/assistant_repository_impl.dart';
import '../features/assistant/domain/repositories/assistant_repository.dart';
import '../features/assistant/domain/usecases/contact_agent_usecase.dart';
import '../features/assistant/domain/usecases/classify_nandina_usecase.dart';
import '../features/assistant/presentation/bloc/assistant_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  // ── Auth State ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthNotifier());

  // ── Repositories ──────────────────────────────────────────────────────
  sl.registerLazySingleton<AlertsRepository>(
    () => AlertsRepositoryImpl(),
  );
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(),
  );
  sl.registerLazySingleton<ErpRepository>(
    () => ErpRepositoryImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(),
  );
  sl.registerLazySingleton<AssistantRepository>(
    () => AssistantRepositoryImpl(),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetAlertsUseCase(sl()));
  sl.registerLazySingleton(() => GetActivePlanUseCase(sl()));
  sl.registerLazySingleton(() => ChangePlanUseCase(sl()));
  sl.registerLazySingleton(() => SyncErpUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCompanyInfoUseCase(sl()));
  sl.registerLazySingleton(() => ContactAgentUseCase(sl()));
  sl.registerLazySingleton(() => ClassifyNandinaUseCase(sl()));

  // ── BLoCs (factory = new instance per BlocProvider) ───────────────────
  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => AlertsBloc(getAlerts: sl()));
  sl.registerFactory(() => ChecklistBloc());
  sl.registerFactory(() => CalculatorBloc());
  sl.registerFactory(() => SecurityBloc());
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(
    () => SubscriptionBloc(
      getActivePlan: sl(),
      changePlan: sl(),
    ),
  );
  sl.registerFactory(
    () => ErpBloc(
      syncErp: sl(),
    ),
  );
  sl.registerFactory(
    () => ProfileBloc(
      updateCompanyInfo: sl(),
    ),
  );
  sl.registerFactory(
    () => AssistantBloc(
      contactAgent: sl(),
      classifyNandina: sl(),
    ),
  );
}
