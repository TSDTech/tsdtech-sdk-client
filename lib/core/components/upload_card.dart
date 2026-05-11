import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_circular_progress_indicator.dart';

enum FileUploadState { idle, uploading, uploaded }

class FileUploadCards extends StatefulWidget {
  final String title;
  final String description;
  final List<String> allowedExtensions;
  final void Function(PlatformFile) onFileSelected;
  final IconData icon;
  final VoidCallback? onDelete;
  final PlatformFile? initialFile; // Adicione este parâmetro

  const FileUploadCards({
    Key? key,
    required this.title,
    required this.description,
    required this.allowedExtensions,
    required this.onFileSelected,
    required this.icon,
    this.onDelete,
    this.initialFile, // Adicione aqui
  }) : super(key: key);

  @override
  _FileUploadCardsState createState() => _FileUploadCardsState();
}

class _FileUploadCardsState extends State<FileUploadCards> {
  late PlatformFile? _selectedFile;
  late FileUploadState _state;

  @override
  void initState() {
    super.initState();
    _selectedFile = widget.initialFile;
    _state =
        _selectedFile != null ? FileUploadState.uploaded : FileUploadState.idle;
  }

  @override
  void didUpdateWidget(covariant FileUploadCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFile != oldWidget.initialFile) {
      setState(() {
        _selectedFile = widget.initialFile;
        _state = _selectedFile != null
            ? FileUploadState.uploaded
            : FileUploadState.idle;
      });
    }
  }

  Future<void> pickFile() async {
    setState(() => _state = FileUploadState.uploading);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.size > 1 * 1024 * 1024) {
          // 1MB
          throw Exception('Tamanho máximo excedido (1MB)');
        }

        setState(() {
          _selectedFile = file;
          _state = FileUploadState.uploaded;
        });
        widget.onFileSelected(file);
      } else {
        setState(() => _state = FileUploadState.idle);
      }
    } catch (e) {
      setState(() => _state = FileUploadState.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _deleteFile() {
    setState(() {
      _selectedFile = null;
      _state = FileUploadState.idle;
    });
    widget.onDelete?.call();
  }

  String _getFileDescription() {
    if (_selectedFile == null) return widget.description;

    final file = _selectedFile!;
    final extension = file.extension?.toUpperCase() ?? '';
    final sizeInKB = file.size / 1024;

    if (sizeInKB < 1000) {
      return '$extension • ${sizeInKB.toStringAsFixed(1)} KB';
    } else {
      return '$extension • ${(sizeInKB / 1024).toStringAsFixed(1)} MB';
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText =
        _selectedFile != null ? _selectedFile!.name : widget.title;
    final descriptionText = _getFileDescription();
    final isUploading = _state == FileUploadState.uploading;

    Widget trailingButton;

    if (_state == FileUploadState.uploaded) {
      trailingButton = IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: _deleteFile,
      );
    } else {
      trailingButton = ElevatedButton(
        onPressed: isUploading ? null : pickFile,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.grey.shade800,
          elevation: 0,
        ),
        child: isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: DsCircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.upload_rounded, size: 24),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
        border: Border.all(
          color: Colors.grey.shade700,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 32, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleText,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  descriptionText,
                  style: TextStyle(
                      color: isUploading ? Colors.blue : Colors.grey.shade600,
                      fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailingButton,
        ],
      ),
    );
  }
}
