import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

/// Servicio que encapsula el escáner de documentos usando la cámara del teléfono.
/// Detecta bordes, recorta y mejora el contraste automáticamente.
/// Las imágenes se comprimen antes de devolverse para optimizar el upload en redes lentas.
class DocumentScannerService {
  /// Calidad de compresión JPEG (0-100). 70% ofrece buen balance tamaño/calidad.
  static const int _compressQuality = 70;

  /// Ancho máximo en píxeles. Las imágenes más grandes se redimensionan.
  static const int _maxWidth = 1920;

  /// Abre la cámara para escanear un documento.
  /// Devuelve la lista de rutas de los archivos escaneados y comprimidos.
  /// Retorna una lista vacía si el usuario cancela o hay un error.
  Future<List<String>> scanDocument() async {
    try {
      final images = await CunningDocumentScanner.getPictures(
        isGalleryImportAllowed: true,
      );

      if (images == null || images.isEmpty) return [];

      // Comprimir cada imagen para reducir el tamaño de upload
      final compressedPaths = <String>[];
      for (final imagePath in images) {
        final compressed = await _compressImage(imagePath);
        compressedPaths.add(compressed ?? imagePath);
      }

      return compressedPaths;
    } on PlatformException {
      return [];
    }
  }

  /// Comprime una imagen individual.
  /// Retorna la ruta del archivo comprimido, o null si falla.
  Future<String?> _compressImage(String sourcePath) async {
    try {
      final file = File(sourcePath);
      if (!await file.exists()) return null;

      // Generar ruta de destino con sufijo _compressed
      final dir = p.dirname(sourcePath);
      final name = p.basenameWithoutExtension(sourcePath);
      final targetPath = p.join(dir, '${name}_compressed.jpg');

      final result = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        quality: _compressQuality,
        minWidth: _maxWidth,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        final originalSize = await file.length();
        final compressedSize = await File(result.path).length();
        final savings = ((1 - compressedSize / originalSize) * 100).toStringAsFixed(1);
        debugPrint('📦 Imagen comprimida: $savings% reducción ($originalSize → $compressedSize bytes)');
        return result.path;
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
