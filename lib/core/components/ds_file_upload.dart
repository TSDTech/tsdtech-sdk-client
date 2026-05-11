import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_circular_progress_indicator.dart';

enum DsFileUploadState { idle, uploading, uploaded }

class DsFileUpload extends StatelessWidget {
  static const int _maxFileSizeInBytes = 10 * 1024 * 1024; // 10MB
  static const int _bytesPerKB = 1024;
  static const int _kbThreshold = 1000;
  static const String _maxSizeErrorMessage =
      'Arquivo muito grande. Tamanho máximo: 10MB';

  final String title;
  final String description;
  final String maxSizeText;
  final List<String> allowedExtensions;
  final void Function(PlatformFile) onFileSelected;
  final VoidCallback? onDelete;
  final VoidCallback? onCameraPressed;
  final PlatformFile? selectedFile;
  final DsFileUploadState state;
  final String? errorMessage;

  const DsFileUpload({
    Key? key,
    required this.title,
    required this.description,
    required this.maxSizeText,
    required this.allowedExtensions,
    required this.onFileSelected,
    this.onDelete,
    this.onCameraPressed,
    this.selectedFile,
    this.state = DsFileUploadState.idle,
    this.errorMessage,
  }) : super(key: key);

  String get allowedExtensionsText {
    return 'Formatos aceitos: ${allowedExtensions.map((ext) => ext.toUpperCase()).join(', ')}';
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.size > _maxFileSizeInBytes) {
          throw Exception(_maxSizeErrorMessage);
        }

        onFileSelected(file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _deleteFile() {
    onDelete?.call();
  }

  void _showCameraOption(BuildContext context) {
    if (onCameraPressed != null) {
      onCameraPressed!();
    } else {
      // Placeholder para funcionalidade de câmera
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Funcionalidade de câmera em breve!')),
      );
    }
  }

  String _getFileInfo() {
    if (selectedFile == null) return description;

    final file = selectedFile!;
    final sizeInKB = file.size / _bytesPerKB;

    if (sizeInKB < _kbThreshold) {
      return '${sizeInKB.toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInKB / _bytesPerKB).toStringAsFixed(1)} MB';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (state == DsFileUploadState.uploaded && selectedFile != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.description,
                color: Colors.green[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedFile!.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getFileInfo(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _deleteFile,
              icon: const Icon(Icons.close),
              iconSize: 20,
              color: Colors.grey[600],
            ),
          ],
        ),
      );
    }

    // Estado inicial (sem arquivo selecionado)
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícone e título lado a lado
          Row(
            children: [
              Icon(
                Icons.file_present,
                size: 32,
                color: Colors.blue[600],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[600],
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Descrição
          Text(
            'Certifique-se de que todas as informações\nno documento estão legíveis.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),

          // Tamanho máximo
          Text(
            maxSizeText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 4),

          // Formatos aceitos
          Text(
            allowedExtensionsText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 20),

          // Botões
          Column(
            children: [
              // Botão principal - Tirar foto
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state == DsFileUploadState.uploading
                      ? null
                      : () => _showCameraOption(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: state == DsFileUploadState.uploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: DsCircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Tirar foto do arquivo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // Botão secundário - Selecionar arquivo
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: state == DsFileUploadState.uploading
                      ? null
                      : () => _pickFile(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Selecionar Arquivo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
