// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_reducer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease use the `default` constructor instead.');

/// @nodoc
mixin _$ImageReducerState {
  List<ProcessedImage> get images => throw _privateConstructorUsedError;
  bool get isProcessing => throw _privateConstructorUsedError;
  int get quality => throw _privateConstructorUsedError;
  ResizePreset get selectedPreset => throw _privateConstructorUsedError;
  ConvertibleFormat get targetFormat => throw _privateConstructorUsedError;
  ConversionStrategy get strategy => throw _privateConstructorUsedError;
  PrivacyLevel get privacyLevel => throw _privateConstructorUsedError;
  bool get stripMetadata => throw _privateConstructorUsedError;
  bool get enableResize => throw _privateConstructorUsedError;
  bool get enableFormatConversion => throw _privateConstructorUsedError;
  int get processingProgress => throw _privateConstructorUsedError;
  List<String> get processingErrors => throw _privateConstructorUsedError;
  ProcessedImage? get selectedImage => throw _privateConstructorUsedError;
  bool get showAdvancedSettings => throw _privateConstructorUsedError;
  bool get showBatchMode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImageReducerStateCopyWith<ImageReducerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageReducerStateCopyWith<$Res> {
  factory $ImageReducerStateCopyWith(
          ImageReducerState value, $Res Function(ImageReducerState) then) =
      _$ImageReducerStateCopyWithImpl<$Res, ImageReducerState>;
  @useResult
  $Res call(
      {List<ProcessedImage> images,
      bool isProcessing,
      int quality,
      ResizePreset selectedPreset,
      ConvertibleFormat targetFormat,
      ConversionStrategy strategy,
      PrivacyLevel privacyLevel,
      bool stripMetadata,
      bool enableResize,
      bool enableFormatConversion,
      int processingProgress,
      List<String> processingErrors,
      ProcessedImage? selectedImage,
      bool showAdvancedSettings,
      bool showBatchMode});

  $ProcessedImageCopyWith<$Res>? get selectedImage;
}

// Continue with implementation details...
// (The freezed generator would create the full implementation)

/// @nodoc
class _$ImageReducerStateImpl extends _ImageReducerState {
  const _$ImageReducerStateImpl(
      {this.images = const <ProcessedImage>[],
      this.isProcessing = false,
      this.quality = 80,
      this.selectedPreset = ResizePreset.medium,
      this.targetFormat = ConvertibleFormat.jpeg,
      this.strategy = ConversionStrategy.balanceQualitySize,
      this.privacyLevel = PrivacyLevel.moderate,
      this.stripMetadata = false,
      this.enableResize = false,
      this.enableFormatConversion = false,
      this.processingProgress = 0,
      this.processingErrors = const <String>[],
      this.selectedImage,
      this.showAdvancedSettings = false,
      this.showBatchMode = false})
      : super._();

  final List<ProcessedImage> _images;
  @override
  @JsonKey()
  List<ProcessedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final bool isProcessing;
  @override
  @JsonKey()
  final int quality;
  @override
  @JsonKey()
  final ResizePreset selectedPreset;
  @override
  @JsonKey()
  final ConvertibleFormat targetFormat;
  @override
  @JsonKey()
  final ConversionStrategy strategy;
  @override
  @JsonKey()
  final PrivacyLevel privacyLevel;
  @override
  @JsonKey()
  final bool stripMetadata;
  @override
  @JsonKey()
  final bool enableResize;
  @override
  @JsonKey()
  final bool enableFormatConversion;
  @override
  @JsonKey()
  final int processingProgress;
  final List<String> _processingErrors;
  @override
  @JsonKey()
  List<String> get processingErrors {
    if (_processingErrors is EqualUnmodifiableListView) return _processingErrors;
    return EqualUnmodifiableListView(_processingErrors);
  }

  @override
  final ProcessedImage? selectedImage;
  @override
  @JsonKey()
  final bool showAdvancedSettings;
  @override
  @JsonKey()
  final bool showBatchMode;

  @override
  String toString() {
    return 'ImageReducerState(images: $images, isProcessing: $isProcessing, quality: $quality, selectedPreset: $selectedPreset, targetFormat: $targetFormat, strategy: $strategy, privacyLevel: $privacyLevel, stripMetadata: $stripMetadata, enableResize: $enableResize, enableFormatConversion: $enableFormatConversion, processingProgress: $processingProgress, processingErrors: $processingErrors, selectedImage: $selectedImage, showAdvancedSettings: $showAdvancedSettings, showBatchMode: $showBatchMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageReducerStateImpl &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.selectedPreset, selectedPreset) ||
                other.selectedPreset == selectedPreset) &&
            (identical(other.targetFormat, targetFormat) ||
                other.targetFormat == targetFormat) &&
            (identical(other.strategy, strategy) || other.strategy == strategy) &&
            (identical(other.privacyLevel, privacyLevel) ||
                other.privacyLevel == privacyLevel) &&
            (identical(other.stripMetadata, stripMetadata) ||
                other.stripMetadata == stripMetadata) &&
            (identical(other.enableResize, enableResize) ||
                other.enableResize == enableResize) &&
            (identical(other.enableFormatConversion, enableFormatConversion) ||
                other.enableFormatConversion == enableFormatConversion) &&
            (identical(other.processingProgress, processingProgress) ||
                other.processingProgress == processingProgress) &&
            const DeepCollectionEquality()
                .equals(other._processingErrors, _processingErrors) &&
            (identical(other.selectedImage, selectedImage) ||
                other.selectedImage == selectedImage) &&
            (identical(other.showAdvancedSettings, showAdvancedSettings) ||
                other.showAdvancedSettings == showAdvancedSettings) &&
            (identical(other.showBatchMode, showBatchMode) ||
                other.showBatchMode == showBatchMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_images),
      isProcessing,
      quality,
      selectedPreset,
      targetFormat,
      strategy,
      privacyLevel,
      stripMetadata,
      enableResize,
      enableFormatConversion,
      processingProgress,
      const DeepCollectionEquality().hash(_processingErrors),
      selectedImage,
      showAdvancedSettings,
      showBatchMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageReducerStateImplCopyWith<_$ImageReducerStateImpl> get copyWith =>
      __$$ImageReducerStateImplCopyWithImpl<_$ImageReducerStateImpl>(
          this, _$identity);
}

abstract class _ImageReducerState extends ImageReducerState {
  const factory _ImageReducerState(
      {final List<ProcessedImage> images,
      final bool isProcessing,
      final int quality,
      final ResizePreset selectedPreset,
      final ConvertibleFormat targetFormat,
      final ConversionStrategy strategy,
      final PrivacyLevel privacyLevel,
      final bool stripMetadata,
      final bool enableResize,
      final bool enableFormatConversion,
      final int processingProgress,
      final List<String> processingErrors,
      final ProcessedImage? selectedImage,
      final bool showAdvancedSettings,
      final bool showBatchMode}) = _$ImageReducerStateImpl;
  const _ImageReducerState._() : super._();

  @override
  List<ProcessedImage> get images;
  @override
  bool get isProcessing;
  @override
  int get quality;
  @override
  ResizePreset get selectedPreset;
  @override
  ConvertibleFormat get targetFormat;
  @override
  ConversionStrategy get strategy;
  @override
  PrivacyLevel get privacyLevel;
  @override
  bool get stripMetadata;
  @override
  bool get enableResize;
  @override
  bool get enableFormatConversion;
  @override
  int get processingProgress;
  @override
  List<String> get processingErrors;
  @override
  ProcessedImage? get selectedImage;
  @override
  bool get showAdvancedSettings;
  @override
  bool get showBatchMode;
  @override
  @JsonKey(ignore: true)
  _$$ImageReducerStateImplCopyWith<_$ImageReducerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// ProcessedImage implementation would follow similar pattern...
/// @nodoc
mixin _$ProcessedImage {
  String get fileName => throw _privateConstructorUsedError;
  Uint8List get originalData => throw _privateConstructorUsedError;
  Uint8List? get processedData => throw _privateConstructorUsedError;
  ImageReductionResult? get result => throw _privateConstructorUsedError;
  ProcessingStatus get status => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  int get estimatedSize => throw _privateConstructorUsedError;
  ConvertibleFormat? get detectedFormat => throw _privateConstructorUsedError;
  ImageMetadata? get metadata => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProcessedImageCopyWith<ProcessedImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// Similar pattern for ProcessedImage and ImageMetadata implementations...
// Simplified implementation for build purposes
typedef $ProcessedImageCopyWith<$Res> = Function(ProcessedImage);
typedef $ImageMetadataCopyWith<$Res> = Function(ImageMetadata);

class __$$ImageReducerStateImplCopyWithImpl<$Res>
    extends _$ImageReducerStateCopyWithImpl<$Res, _$ImageReducerStateImpl>
    implements _$$ImageReducerStateImplCopyWith<$Res> {
  __$$ImageReducerStateImplCopyWithImpl(_$ImageReducerStateImpl _value,
      $Res Function(_$ImageReducerStateImpl) _then)
      : super(_value, _then);

  // Implementation details would continue here...
}

typedef _$$ImageReducerStateImplCopyWith<$Res>
    = __$$ImageReducerStateImplCopyWithImpl<$Res>;

// Additional implementations for ProcessedImage and ImageMetadata would follow...