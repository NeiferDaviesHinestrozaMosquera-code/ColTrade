import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../core/data/api_cache_service.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/sync_service.dart';
import '../core/utils/auth_notifier.dart';
import '../core/services/biometric_service.dart';
import '../core/services/document_scanner_service.dart';

// Alerts
import '../features/alerts/data/repositories/alerts_repository_impl.dart';
import '../features/alerts/domain/repositories/alerts_repository.dart';
import '../features/alerts/domain/usecases/get_alerts_usecase.dart';
import '../features/alerts/presentation/bloc/alerts_bloc.dart';

// Checklist
import '../features/checklist/presentation/bloc/checklist_bloc.dart';

// Calculator
import '../features/calculator/presentation/bloc/calculator_bloc.dart';

// Security
import '../features/security/presentation/bloc/security_bloc.dart';
import '../features/security/presentation/bloc/auth/auth_bloc.dart';

// Home
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

// Repository feature
import '../features/repository/data/datasources/repository_local_datasource.dart';
import '../features/repository/data/repositories/document_repository_impl.dart';
import '../features/repository/domain/repositories/document_repository.dart';
import '../features/repository/domain/usecases/document_usecases.dart';
import '../features/repository/presentation/bloc/repository_bloc.dart';

// Logistics feature
import '../features/logistics/data/datasources/logistics_local_datasource.dart';
import '../features/logistics/data/repositories/logistics_repository_impl.dart';
import '../features/logistics/domain/repositories/logistics_repository.dart';
import '../features/logistics/domain/usecases/get_ports_usecase.dart';
import '../features/logistics/domain/usecases/get_routes_usecase.dart';
import '../features/logistics/presentation/bloc/logistics_bloc.dart';

// History feature
import '../features/history/data/datasources/history_local_datasource.dart';
import '../features/history/data/repositories/history_repository_impl.dart';
import '../features/history/domain/repositories/history_repository.dart';
import '../features/history/domain/usecases/get_history_usecase.dart';
import '../features/history/presentation/bloc/history_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  // ── Core Services ───────────────────────────────────────────────────────
  sl.registerLazySingleton(() => BiometricService());
  sl.registerLazySingleton(() => DocumentScannerService());

  // ── Auth State ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthNotifier());

  // ── Network & Sync ─────────────────────────────────────────────────
  sl.registerLazySingleton(() => Dio(BaseOptions(
    // TODO: Reemplazar con la URL real del backend en producción
    baseUrl: 'https://api.coltrade.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )));
  sl.registerLazySingleton(() => ApiCacheService());
  sl.registerLazySingleton(() {
    final connectivity = ConnectivityService();
    connectivity.startMonitoring();
    return connectivity;
  });
  sl.registerLazySingleton(() {
    final syncService = SyncService();
    syncService.configure(sl<Dio>());
    syncService.startAutoSync();
    return syncService;
  });

  // ── Datasources ───────────────────────────────────────────────────────
  sl.registerLazySingleton(() => RepositoryLocalDatasource());
  sl.registerLazySingleton(() => LogisticsLocalDatasource());
  sl.registerLazySingleton(() => HistoryLocalDatasource());

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
  sl.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<LogisticsRepository>(
    () => LogisticsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(sl()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetAlertsUseCase(sl()));
  sl.registerLazySingleton(() => GetActivePlanUseCase(sl()));
  sl.registerLazySingleton(() => ChangePlanUseCase(sl()));
  sl.registerLazySingleton(() => SyncErpUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCompanyInfoUseCase(sl()));
  sl.registerLazySingleton(() => ContactAgentUseCase(sl()));
  sl.registerLazySingleton(() => ClassifyNandinaUseCase(sl()));
  
  sl.registerLazySingleton(() => GetDocumentsUseCase(sl()));
  sl.registerLazySingleton(() => UploadDocumentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDocumentUseCase(sl()));

  sl.registerLazySingleton(() => GetPortsUseCase(sl()));
  sl.registerLazySingleton(() => GetRoutesUseCase(sl()));
  sl.registerLazySingleton(() => GetAlternativesUseCase(sl()));

  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));

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
  sl.registerFactory(
    () => RepositoryBloc(
      getDocuments: sl(),
      uploadDocument: sl(),
      deleteDocument: sl(),
    ),
  );
  sl.registerFactory(
    () => LogisticsBloc(
      getPorts: sl(),
      getRoutes: sl(),
      getAlternatives: sl(),
    ),
  );
  sl.registerFactory(
    () => HistoryBloc(
      getHistory: sl(),
    ),
  );

  // Force instantiation of SyncService to start auto-monitoring background sync
  sl<SyncService>();
}
