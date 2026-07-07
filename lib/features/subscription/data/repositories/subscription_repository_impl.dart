import '../../domain/entities/subscription_plan.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../../../core/data/api_cache_service.dart';

/// Repository con caché SQLite — la llamada al API real se descomenta
/// cuando el endpoint de subscripciones esté en producción.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiCacheService _cache = ApiCacheService();

  /// Simulates the authenticated user's current plan (in-memory for now).
  PlanTier _activePlan = PlanTier.pro;

  @override
  Future<PlanTier> getActivePlan() async {
    final cached = await _cache.cachedRequest<String>(
      key: 'active_subscription_plan',
      ttlSeconds: 900, // 15 minutos
      fetcher: () async {
        // TODO: Reemplazar con llamada real a Dio
        // final response = await dio.get('/api/v1/subscriptions/active');
        // return response.data['tier'] as String;
        await Future.delayed(const Duration(milliseconds: 100));
        return _activePlan.name;
      },
    );

    return PlanTier.values.firstWhere(
      (p) => p.name == cached,
      orElse: () => PlanTier.free,
    );
  }

  @override
  Future<bool> changePlan(PlanTier newTier) async {
    // Invalidar la caché del plan activo tras cambiar
    await _cache.invalidate('active_subscription_plan');

    // TODO: Reemplazar con llamada real a Dio
    // await dio.post('/api/v1/subscriptions/change', data: { 'tier': newTier.name });
    await Future.delayed(const Duration(milliseconds: 400));
    _activePlan = newTier;
    return true;
  }
}
