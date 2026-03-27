import 'package:get_it/get_it.dart';
import '../features/alerts/data/repositories/alerts_repository_impl.dart';
import '../features/alerts/domain/repositories/alerts_repository.dart';
import '../features/alerts/domain/usecases/get_alerts_usecase.dart';
import '../features/alerts/presentation/bloc/alerts_bloc.dart';
import '../features/checklist/presentation/bloc/checklist_bloc.dart';
import '../features/calculator/presentation/bloc/calculator_bloc.dart';
import '../features/security/presentation/bloc/security_bloc.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/academy/presentation/bloc/academy_bloc.dart';
import '../features/assistant/presentation/bloc/assistant_bloc.dart';
import '../features/erp/presentation/bloc/erp_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  // ── Repositories ──────────────────────────────────────────────────────
  sl.registerLazySingleton<AlertsRepository>(
    () => AlertsRepositoryImpl(),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetAlertsUseCase(sl()));

  // ── BLoCs (factory = new instance per BlocProvider) ───────────────────
  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => AlertsBloc(getAlerts: sl()));
  sl.registerFactory(() => ChecklistBloc());
  sl.registerFactory(() => CalculatorBloc());
  sl.registerFactory(() => SecurityBloc());
  sl.registerFactory(() => ProfileBloc());
  sl.registerFactory(() => AcademyBloc());
  sl.registerFactory(() => AssistantBloc());
  sl.registerFactory(() => ErpBloc());
}
