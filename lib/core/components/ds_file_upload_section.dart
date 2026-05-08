import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:voucherize/core/components/ds_card_container.dart';
import 'package:voucherize/core/components/ds_file_upload.dart';

/// Seção de upload de arquivo com título e descrição
class DsFileUploadSection extends StatelessWidget {
  final String title;
  final String uploadTitle;
  final String uploadDescription;
  final String maxSizeText;
  final List<String> allowedExtensions;
  final PlatformFile? selectedFile;
  final void Function(PlatformFile) onFileSelected;
  final void Function() onDelete;

  const DsFileUploadSection({
    super.key,
    required this.title,
    required this.uploadTitle,
    required this.uploadDescription,
    required this.maxSizeText,
    required this.allowedExtensions,
    this.selectedFile,
    required this.onFileSelected,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DsCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 16),
          DsFileUpload(
            title: uploadTitle,
            description: uploadDescription,
            maxSizeText: maxSizeText,
            allowedExtensions: allowedExtensions,
            selectedFile: selectedFile,
            onFileSelected: onFileSelected,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}
