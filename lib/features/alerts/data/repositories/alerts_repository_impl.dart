import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/repositories/alerts_repository.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  @override
  Future<Either<Failure, List<AlertEntity>>> getAlerts() async {
    // Mock data – reemplazar por API/local DB en el futuro
    return const Right([
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
    ]);
  }
}
