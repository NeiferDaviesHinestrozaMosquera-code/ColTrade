import 'package:flutter/material.dart';
import '../../../../core/widgets/common_widgets.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        TimelineStatus.completed,
        'Solicitud creada',
        'Inicio del proceso',
        '12 Oct, 09:00'
      ),
      (
        TimelineStatus.completed,
        'Documentos DIAN listos',
        'Factura y lista de empaque aprobados',
        '14 Oct, 11:30'
      ),
      (
        TimelineStatus.active,
        'Obtener Certificado ICA',
        'Pendiente de inspección fitosanitaria',
        null
      ),
      (TimelineStatus.pending, 'Declaración de Exportación', null, null),
      (TimelineStatus.pending, 'Embarque y BL', null, null),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final (status, title, subtitle, timestamp) = steps[index];
        return TimelineStep(
          status: status,
          title: title,
          subtitle: subtitle,
          timestamp: timestamp,
          isLast: index == steps.length - 1,
        );
      },
    );
  }
}
