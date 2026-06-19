import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../l10n/app_localizations.dart';
import '../data/bulk_onboarding_repository.dart';
import '../domain/bulk_onboarding_type.dart';
import 'bulk_onboarding_providers.dart';
import 'widgets/bulk_onboarding_file_picker_field.dart';
import 'widgets/bulk_onboarding_upload_card.dart';

class BulkOnboardingUploadScreen extends ConsumerStatefulWidget {
  const BulkOnboardingUploadScreen({super.key});

  @override
  ConsumerState<BulkOnboardingUploadScreen> createState() =>
      _BulkOnboardingUploadScreenState();
}

class _BulkOnboardingUploadScreenState extends ConsumerState<BulkOnboardingUploadScreen> {
  final _companyIdController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _noteController = TextEditingController();

  BulkOnboardingJobType _selectedType = BulkOnboardingJobType.drivers;
  String? _fileName;
  List<int>? _fileBytes;
  int? _fileSizeBytes;
  String? _fileError;
  bool _isUploading = false;
  bool _isDownloadingTemplate = false;
  double? _uploadProgress;

  @override
  void dispose() {
    _companyIdController.dispose();
    _companyNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final picked = await pickBulkOnboardingCsvFile();
    if (!mounted || picked == null) return;

    if (isExcelBulkOnboardingFileName(picked.name)) {
      setState(() {
        _fileName = picked.name;
        _fileBytes = null;
        _fileSizeBytes = picked.size;
        _fileError = resolveBulkOnboardingKey(
          context,
          'bulkOnboardingExcelComingLater',
        );
      });
      return;
    }

    final bytes = picked.bytes;
    if (bytes == null || bytes.isEmpty) {
      setState(() {
        _fileError = resolveBulkOnboardingKey(context, 'bulkOnboardingEmptyFile');
      });
      return;
    }

    setState(() {
      _fileName = picked.name;
      _fileBytes = bytes;
      _fileSizeBytes = picked.size;
      _fileError = null;
    });
  }

  Future<void> _downloadTemplate() async {
    setState(() => _isDownloadingTemplate = true);
    try {
      final template = await ref
          .read(bulkOnboardingRepositoryProvider)
          .downloadTemplate(_selectedType);
      await Clipboard.setData(ClipboardData(text: template));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingTemplateCopied'),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingUploadFailed')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isDownloadingTemplate = false);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_fileBytes == null || _fileName == null) {
      setState(() {
        _fileError = resolveBulkOnboardingKey(context, 'bulkOnboardingFileRequired');
      });
      return;
    }
    if (_selectedType == BulkOnboardingJobType.unknown) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bulkOnboardingUploadTypeRequired)),
      );
      return;
    }
    if (isExcelBulkOnboardingFileName(_fileName)) {
      setState(() {
        _fileError = resolveBulkOnboardingKey(
          context,
          'bulkOnboardingExcelComingLater',
        );
      });
      return;
    }

    final companyId = int.tryParse(_companyIdController.text.trim());
    setState(() {
      _isUploading = true;
      _uploadProgress = null;
      _fileError = null;
    });

    try {
      final result = await ref.read(bulkOnboardingRepositoryProvider).uploadCsv(
        bytes: _fileBytes!,
        fileName: _fileName!,
        type: _selectedType,
        companyId: companyId,
        companyName: _companyNameController.text.trim().isEmpty
            ? null
            : _companyNameController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        onProgress: (sent, total) {
          if (!mounted || total <= 0) return;
          setState(() => _uploadProgress = sent / total);
        },
      );

      ref.invalidate(bulkOnboardingJobsProvider);
      ref.invalidate(bulkOnboardingSummaryProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingUploadSuccessful')),
        ),
      );
      context.go(AdminRoutes.bulkOnboardingJobDetail(result.job.id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingUploadFailed')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final usesMock = ref.watch(bulkOnboardingRepositoryProvider).usesMockData;
    final canUpload = ref.watch(adminAuthProvider).user?.role.canUploadBulkOnboarding ?? false;

    if (!canUpload) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bulkOnboardingUploadCsv)),
        body: Center(
          child: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingUploadForbidden')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bulkOnboardingUploadCsv),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveBulkOnboardingKey(context, 'bulkOnboardingMockUploadBadge'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BulkOnboardingUploadCard(
            selectedType: _selectedType,
            companyIdController: _companyIdController,
            companyNameController: _companyNameController,
            noteController: _noteController,
            fileName: _fileName,
            fileSizeBytes: _fileSizeBytes,
            fileError: _fileError,
            isUploading: _isUploading,
            uploadProgress: _uploadProgress,
            isDownloadingTemplate: _isDownloadingTemplate,
            onTypeChanged: (type) => setState(() => _selectedType = type),
            onPickFile: _pickFile,
            onDownloadTemplate: _downloadTemplate,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }
}
