import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/data/api_cache_service.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/repositories/alerts_repository.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final ApiCacheService _cache = ApiCacheService();

  @override
  Future<Either<Failure, List<AlertEntity>>> getAlerts() async {
    try {
      final alerts = await _cache.cachedRequest<List<dynamic>>(
        key: 'alerts_list',
        ttlSeconds: 600, // 10 minutos de caché
        fetcher: () async {
          // TODO: Reemplazar con llamada real a Dio cuando el endpoint esté listo
          // Ejemplo: final response = await dio.get('/api/v1/alerts');
          // return response.data;
          return _getMockAlerts();
        },
      );

      final alertEntities = alerts.map((a) => AlertEntity(
        priority: _parsePriority(a['priority'] as String? ?? 'informativo'),
        date: a['date'] as String? ?? '',
        title: a['title'] as String? ?? '',
        summary: a['summary'] as String? ?? '',
        institution: a['institution'] as String? ?? '',
      )).toList();

      return Right(alertEntities);
    } catch (e) {
      // Si la caché falla, devolver datos mock directamente
      return Right(_getDefaultAlerts());
    }
  }

  AlertPriority _parsePriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'alta':
        return AlertPriority.alta;
      case 'media':
        return AlertPriority.media;
      case 'baja':
        return AlertPriority.baja;
      case 'tlc':
        return AlertPriority.tlc;
      default:
        return AlertPriority.informativo;
    }
  }

  /// Mock data — se reemplazará por la respuesta del API
  Future<List<Map<String, dynamic>>> _getMockAlerts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _getDefaultAlerts().map((a) => {
      'priority': a.priority.name,
      'date': a.date,
      'title': a.title,
      'summary': a.summary,
      'institution': a.institution,
    }).toList();
  }

  List<AlertEntity> _getDefaultAlerts() {
    return const [
      AlertEntity(
        priority: AlertPriority.alta,
        date: '14 Oct 2024',
        title: 'Nuevo Decreto DIAN 1234 – Cambios en declaración de exportación',
        summary:
            'La DIAN modifica los formularios y requisitos para la declaración de exportación. Vigente desde el 1 de noviembre.',
        institution: 'DIAN',
      ),
      AlertEntity(
        priority: AlertPriority.media,
        date: '12 Oct 2024',
        title: 'Actualización de aranceles para productos agrícolas',
        summary:
            'MinCIT actualiza las tasas arancelarias para 42 subpartidas del sector agrícola.',
        institution: 'MinCIT',
      ),
      AlertEntity(
        priority: AlertPriority.tlc,
        date: '10 Oct 2024',
        title: 'TLC Colombia–Indonesia – Nuevas oportunidades de exportación',
        summary:
            'Entrada en vigor del TLC con Indonesia que reduce aranceles para 380 productos colombianos.',
        institution: 'MinCIT',
      ),
      AlertEntity(
        priority: AlertPriority.informativo,
        date: '08 Oct 2024',
        title: 'INVIMA actualiza lista de productos con Registro Sanitario',
        summary:
            'Se actualiza la lista de productos que requieren registro sanitario obligatorio.',
        institution: 'INVIMA',
      ),
      AlertEntity(
        priority: AlertPriority.baja,
        date: '05 Oct 2024',
        title: 'Recordatorio: Actualización VUCE programada',
        summary: 'El portal VUCE tendrá mantenimiento el próximo fin de semana.',
        institution: 'MinCIT',
      ),
    ];
  }
}
