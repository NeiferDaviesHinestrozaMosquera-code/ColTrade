import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/repo_document.dart';
import '../bloc/repository_bloc.dart';
import '../widgets/document_card.dart';

import '../../../../injection/injection.dart';

class RepositoryScreen extends StatelessWidget {
  const RepositoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RepositoryBloc>()..add(const LoadDocuments()),
      child: const _RepositoryView(),
    );
  }
}

class _RepositoryView extends StatelessWidget {
  const _RepositoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        title: 'Repositorio',
        dark: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_rounded, color: Colors.white),
            onPressed: () => context.read<RepositoryBloc>().add(const LoadDocuments()),
          ),
        ],
      ),
      body: BlocConsumer<RepositoryBloc, RepositoryState>(
        listener: (context, state) {
          if (state.status == RepositoryStatus.error) {
             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(state.errorMessage ?? 'Error')));
          }
        },
        builder: (context, state) {
          if (state.status == RepositoryStatus.initial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryDarkNavy));
          }

          return Stack(
            children: [
              Column(
                children: [
                  // Search Bar
                  Container(
                    color: AppColors.primaryDarkNavy,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TextField(
                      onChanged: (query) =>
                          context.read<RepositoryBloc>().add(SearchDocuments(query)),
                      decoration: InputDecoration(
                        hintText: 'Buscar documento...',
                        hintStyle: AppTextStyles.bodySmall,
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textLabel),
                        filled: true,
                        fillColor: AppColors.cardWhite,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // Categories Filter
                  Container(
                    height: 54,
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: DocCategory.values.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // "All" option
                          final isSelected = state.selectedCategory == null;
                          return ChoiceChip(
                            label: const Text('Todos'),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                context.read<RepositoryBloc>().add(const FilterByCategory(null));
                              }
                            },
                            backgroundColor: AppColors.surfaceGray,
                            selectedColor: AppColors.primaryDarkNavy,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          );
                        }
                        
                        final category = DocCategory.values[index - 1];
                        final isSelected = state.selectedCategory == category;
                        return ChoiceChip(
                          label: Text(category.name.toUpperCase()),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) {
                              context.read<RepositoryBloc>().add(FilterByCategory(category));
                            }
                          },
                          backgroundColor: AppColors.surfaceGray,
                          selectedColor: AppColors.primaryDarkNavy,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ),

                  // Loading List
                  if (state.status == RepositoryStatus.loading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator(color: AppColors.primaryDarkNavy)),
                    )
                  // Document List
                  else
                    Expanded(
                      child: state.filteredDocuments.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.filteredDocuments.length,
                              itemBuilder: (context, index) {
                                final doc = state.filteredDocuments[index];
                                return DocumentCard(
                                  document: doc,
                                  onDownload: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => DownloadProgressDialog(document: doc),
                                    );
                                  },
                                  onDelete: () {
                                    context.read<RepositoryBloc>().add(DeleteDocument(doc.id));
                                  },
                                );
                              },
                            ),
                    ),
                ],
              ),
              
              if (state.status == RepositoryStatus.uploading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: AppColors.accentOrange),
                          SizedBox(height: 16),
                          Text('Subiendo archivo...', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentOrange,
        icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
        label: const Text('Subir Archivo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showUploadSheet(context),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surfaceGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.folder_off_outlined,
                size: 48, color: AppColors.textLabel),
          ),
          const SizedBox(height: 16),
          Text(
            'Carpeta vacía',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay documentos que coincidan con la búsqueda.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showUploadSheet(BuildContext outerContext) {
    final bloc = outerContext.read<RepositoryBloc>();
    
    showModalBottomSheet(
      context: outerContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              const Icon(Icons.cloud_upload_outlined, size: 64, color: AppColors.primaryDarkNavy),
              const SizedBox(height: 16),
              Text('Subir Documento', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Selecciona un documento de tu dispositivo para subirlo al repositorio', textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarkNavy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
                      );
                      
                      if (result != null && result.files.single.path != null) {
                        final platformFile = result.files.single;
                        final name = platformFile.name.split('.').first;
                        final ext = platformFile.extension ?? 'pdf';
                        final sizeInBytes = platformFile.size;
                        final sizeInMB = (sizeInBytes / (1024 * 1024)).toStringAsFixed(1);
                        
                        DocCategory category;
                        if (ext == 'pdf') {
                          category = DocCategory.facturas;
                        } else if (ext == 'docx' || ext == 'doc') {
                          category = DocCategory.aduanas;
                        } else if (ext == 'xlsx' || ext == 'xls') {
                          category = DocCategory.otros;
                        } else {
                          category = DocCategory.otros;
                        }
                        
                        final newDoc = RepoDocument(
                          id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
                          name: name,
                          extension: ext,
                          size: '$sizeInMB MB',
                          uploadDate: DateTime.now(),
                          category: category,
                        );
                        
                        bloc.add(UploadDocument(newDoc));
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    } catch (e) {
                      debugPrint('Error picking file: $e');
                    }
                  },
                  child: const Text('Seleccionar Archivo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class DownloadProgressDialog extends StatefulWidget {
  final RepoDocument document;
  const DownloadProgressDialog({super.key, required this.document});

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double _progress = 0.0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startSimulatedDownload();
  }

  void _startSimulatedDownload() {
    const totalSteps = 20;
    const duration = Duration(milliseconds: 100);
    int currentStep = 0;

    Timer.periodic(duration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      currentStep++;
      setState(() {
        _progress = currentStep / totalSteps;
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        setState(() {
          _isCompleted = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkNavy.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isCompleted ? Icons.check_circle_rounded : Icons.downloading_rounded,
              color: _isCompleted ? AppColors.successGreen : AppColors.primaryDarkNavy,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _isCompleted ? '¡Descarga Completada!' : 'Descargando Archivo',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            widget.document.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          if (!_isCompleted) ...[
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: AppColors.surfaceGray,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_progress * 100).toInt()}%',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.accentOrange),
            ),
          ] else ...[
            Text(
              'El documento ha sido guardado exitosamente en tu dispositivo.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Cerrar', style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Abriendo ${widget.document.name}.${widget.document.extension}...'),
                          backgroundColor: AppColors.successGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDarkNavy,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Abrir', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
