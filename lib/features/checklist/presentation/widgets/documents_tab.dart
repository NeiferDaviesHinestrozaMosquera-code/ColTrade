import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/doc_item_entity.dart';
import '../bloc/checklist_bloc.dart';

class DocumentsTab extends StatelessWidget {
  final List<DocItemEntity> docs;
  const DocumentsTab({super.key, required this.docs});

  @override
  Widget build(BuildContext context) {
    final completed = docs.where((d) => d.completed).length;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DOCUMENTOS NECESARIOS', style: AppTextStyles.labelUppercase),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$completed/${docs.length}',
                  style: AppTextStyles.badgeText
                      .copyWith(color: AppColors.textSecondary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...docs.asMap().entries.map((e) => _buildDocRow(context, e.value, e.key)),
        const SizedBox(height: 20),
        Text('ENTIDADES ALIADAS', style: AppTextStyles.labelUppercase),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: const [
            EntityBadge('DIAN', AppColors.textSecondary),
            EntityBadge('ICA', AppColors.successGreen),
            EntityBadge('INVIMA', AppColors.infoBlue),
            EntityBadge('MinCIT', AppColors.accentOrange),
          ],
        ),
      ],
    );
  }

  Widget _buildDocRow(BuildContext context, DocItemEntity doc, int index) {
    return GestureDetector(
      onTap: () => context.read<ChecklistBloc>().add(ToggleDocument(index)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    doc.completed ? AppColors.successGreen : Colors.transparent,
                border: doc.completed
                    ? null
                    : Border.all(
                        color: doc.hasError
                            ? AppColors.errorRed
                            : AppColors.border,
                        width: 1.5),
                shape: BoxShape.circle,
              ),
              child: doc.completed
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : doc.hasError
                      ? const Icon(Icons.error_outline_rounded,
                          color: AppColors.errorRed, size: 14)
                      : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.name,
                      style: AppTextStyles.bodyRegular
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('ENTIDAD: ${doc.entity}',
                      style:
                          AppTextStyles.labelUppercase.copyWith(fontSize: 10)),
                ],
              ),
            ),
            if (doc.needsUpload)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('SUBIR',
                    style: AppTextStyles.badgeText
                        .copyWith(fontSize: 10, color: Colors.white)),
              )
            else
              const Icon(Icons.visibility_outlined,
                  size: 18, color: AppColors.textLabel),
          ],
        ),
      ),
    );
  }
}

class EntityBadge extends StatelessWidget {
  final String label;
  final Color color;

  const EntityBadge(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: AppTextStyles.badgeText.copyWith(color: color, fontSize: 10)),
    );
  }
}
