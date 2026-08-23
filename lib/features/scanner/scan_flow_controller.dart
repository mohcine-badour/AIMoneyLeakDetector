import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import '../before_subscribe/domain/subscription_candidate.dart';
import '../../core/constants/app_strings.dart';
import '../../core/security/security_providers.dart';
import '../subscriptions/domain/subscription.dart';
import 'data/image_picker_receipt_source.dart';
import 'data/on_device_receipt_extraction_backend.dart';
import 'data/validated_receipt_extractor.dart';
import 'data/vision_receipt_ocr.dart';
import 'domain/extracted_receipt.dart';
import 'domain/receipt_extractor.dart';
import 'domain/receipt_image.dart';

final receiptImagePickerProvider = Provider<ReceiptImagePicker>((ref) {
  return ImagePickerReceiptSource();
});

final receiptExtractorProvider = Provider<ReceiptExtractor>((ref) {
  return const ValidatedReceiptExtractor(
    OnDeviceReceiptExtractionBackend(VisionReceiptOcr()),
  );
});

enum ScanFlowStep { source, preview, processing, extracted }

class ScanFlowState {
  const ScanFlowState({
    this.step = ScanFlowStep.source,
    this.image,
    this.extracted,
    this.error,
    this.isSaving = false,
  });

  final ScanFlowStep step;
  final ReceiptImage? image;
  final ExtractedReceipt? extracted;
  final String? error;
  final bool isSaving;

  ScanFlowState copyWith({
    ScanFlowStep? step,
    ReceiptImage? image,
    ExtractedReceipt? extracted,
    String? error,
    bool? isSaving,
    bool clearImage = false,
    bool clearExtracted = false,
    bool clearError = false,
  }) {
    return ScanFlowState(
      step: step ?? this.step,
      image: clearImage ? null : image ?? this.image,
      extracted: clearExtracted ? null : extracted ?? this.extracted,
      error: clearError ? null : error ?? this.error,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

final scanFlowControllerProvider =
    NotifierProvider<ScanFlowController, ScanFlowState>(
      ScanFlowController.new,
      isAutoDispose: true,
    );

class ScanFlowController extends Notifier<ScanFlowState> {
  @override
  ScanFlowState build() => const ScanFlowState();

  Future<void> pickFromCamera() async {
    await _pick((picker) => picker.pickFromCamera());
  }

  Future<void> pickFromGallery() async {
    await _pick((picker) => picker.pickFromGallery());
  }

  Future<void> usePhoto() async {
    final image = state.image;
    if (image == null) {
      return;
    }
    state = state.copyWith(
      step: ScanFlowStep.processing,
      clearError: true,
      clearExtracted: true,
    );
    try {
      final extracted = await ref.read(receiptExtractorProvider).extract(image);
      await ref.read(documentStoreProvider).discard();
      state = state.copyWith(
        step: ScanFlowStep.extracted,
        extracted: extracted,
        clearImage: true,
      );
      await ref
          .read(analyticsProvider)
          .track(
            AnalyticsEvent.receiptScanCompleted,
            properties: const {'success': true},
          );
    } on Object {
      state = state.copyWith(
        step: ScanFlowStep.preview,
        error: AppStrings.scanFailed,
      );
      await ref
          .read(analyticsProvider)
          .track(
            AnalyticsEvent.receiptScanCompleted,
            properties: const {'success': false},
          );
    }
  }

  SubscriptionCandidate? candidateFromExtracted() {
    final extracted = state.extracted;
    if (extracted == null) {
      return null;
    }
    return SubscriptionCandidate(
      name: extracted.merchant,
      merchant: extracted.merchant,
      amount: extracted.amount,
      currency: extracted.currency,
      billingCycle: extracted.billingCycle,
      nextBillingDate: extracted.date,
      category: extracted.category,
      source: SubscriptionSource.scan,
    );
  }

  void retake() {
    ref.read(documentStoreProvider).discard();
    state = const ScanFlowState();
  }

  Future<void> _pick(
    Future<ReceiptImage?> Function(ReceiptImagePicker picker) pick,
  ) async {
    final image = await pick(ref.read(receiptImagePickerProvider));
    if (image == null) {
      return;
    }
    await ref.read(documentStoreProvider).hold(image.bytes);
    state = ScanFlowState(step: ScanFlowStep.preview, image: image);
  }
}
