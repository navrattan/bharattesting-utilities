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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

/// @nodoc
class _$ImageReducerStateCopyWithImpl<$Res, $Val extends ImageReducerState>
    implements $ImageReducerStateCopyWith<$Res> {
  _$ImageReducerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = null,
    Object? isProcessing = null,
    Object? quality = null,
    Object? selectedPreset = null,
    Object? targetFormat = null,
    Object? strategy = null,
    Object? privacyLevel = null,
    Object? stripMetadata = null,
    Object? enableResize = null,
    Object? enableFormatConversion = null,
    Object? processingProgress = null,
    Object? processingErrors = null,
    Object? selectedImage = freezed,
    Object? showAdvancedSettings = null,
    Object? showBatchMode = null,
  }) {
    return _then(_value.copyWith(
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProcessedImage>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      selectedPreset: null == selectedPreset
          ? _value.selectedPreset
          : selectedPreset // ignore: cast_nullable_to_non_nullable
              as ResizePreset,
      targetFormat: null == targetFormat
          ? _value.targetFormat
          : targetFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as ConversionStrategy,
      privacyLevel: null == privacyLevel
          ? _value.privacyLevel
          : privacyLevel // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      stripMetadata: null == stripMetadata
          ? _value.stripMetadata
          : stripMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      enableResize: null == enableResize
          ? _value.enableResize
          : enableResize // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFormatConversion: null == enableFormatConversion
          ? _value.enableFormatConversion
          : enableFormatConversion // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _value.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _value.processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as ProcessedImage?,
      showAdvancedSettings: null == showAdvancedSettings
          ? _value.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      showBatchMode: null == showBatchMode
          ? _value.showBatchMode
          : showBatchMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProcessedImageCopyWith<$Res>? get selectedImage {
    if (_value.selectedImage == null) {
      return null;
    }

    return $ProcessedImageCopyWith<$Res>(_value.selectedImage!, (value) {
      return _then(_value.copyWith(selectedImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImageReducerStateImplCopyWith<$Res>
    implements $ImageReducerStateCopyWith<$Res> {
  factory _$$ImageReducerStateImplCopyWith(_$ImageReducerStateImpl value,
          $Res Function(_$ImageReducerStateImpl) then) =
      __$$ImageReducerStateImplCopyWithImpl<$Res>;
  @override
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

  @override
  $ProcessedImageCopyWith<$Res>? get selectedImage;
}

/// @nodoc
class __$$ImageReducerStateImplCopyWithImpl<$Res>
    extends _$ImageReducerStateCopyWithImpl<$Res, _$ImageReducerStateImpl>
    implements _$$ImageReducerStateImplCopyWith<$Res> {
  __$$ImageReducerStateImplCopyWithImpl(_$ImageReducerStateImpl _value,
      $Res Function(_$ImageReducerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = null,
    Object? isProcessing = null,
    Object? quality = null,
    Object? selectedPreset = null,
    Object? targetFormat = null,
    Object? strategy = null,
    Object? privacyLevel = null,
    Object? stripMetadata = null,
    Object? enableResize = null,
    Object? enableFormatConversion = null,
    Object? processingProgress = null,
    Object? processingErrors = null,
    Object? selectedImage = freezed,
    Object? showAdvancedSettings = null,
    Object? showBatchMode = null,
  }) {
    return _then(_$ImageReducerStateImpl(
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProcessedImage>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      selectedPreset: null == selectedPreset
          ? _value.selectedPreset
          : selectedPreset // ignore: cast_nullable_to_non_nullable
              as ResizePreset,
      targetFormat: null == targetFormat
          ? _value.targetFormat
          : targetFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as ConversionStrategy,
      privacyLevel: null == privacyLevel
          ? _value.privacyLevel
          : privacyLevel // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      stripMetadata: null == stripMetadata
          ? _value.stripMetadata
          : stripMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      enableResize: null == enableResize
          ? _value.enableResize
          : enableResize // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFormatConversion: null == enableFormatConversion
          ? _value.enableFormatConversion
          : enableFormatConversion // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _value.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _value._processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as ProcessedImage?,
      showAdvancedSettings: null == showAdvancedSettings
          ? _value.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      showBatchMode: null == showBatchMode
          ? _value.showBatchMode
          : showBatchMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ImageReducerStateImpl extends _ImageReducerState {
  const _$ImageReducerStateImpl(
      {final List<ProcessedImage> images = const <ProcessedImage>[],
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
      final List<String> processingErrors = const <String>[],
      this.selectedImage,
      this.showAdvancedSettings = false,
      this.showBatchMode = false})
      : _images = images,
        _processingErrors = processingErrors,
        super._();

  final List<ProcessedImage> _images;
  @override
  @JsonKey()
  List<ProcessedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
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
    if (_processingErrors is EqualUnmodifiableListView)
      return _processingErrors;
    // ignore: implicit_dynamic_type
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
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
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

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageReducerStateImplCopyWith<_$ImageReducerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcessedImageCopyWith<ProcessedImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcessedImageCopyWith<$Res> {
  factory $ProcessedImageCopyWith(
          ProcessedImage value, $Res Function(ProcessedImage) then) =
      _$ProcessedImageCopyWithImpl<$Res, ProcessedImage>;
  @useResult
  $Res call(
      {String fileName,
      Uint8List originalData,
      Uint8List? processedData,
      ImageReductionResult? result,
      ProcessingStatus status,
      String error,
      int estimatedSize,
      ConvertibleFormat? detectedFormat,
      ImageMetadata? metadata});

  $ImageMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$ProcessedImageCopyWithImpl<$Res, $Val extends ProcessedImage>
    implements $ProcessedImageCopyWith<$Res> {
  _$ProcessedImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? originalData = null,
    Object? processedData = freezed,
    Object? result = freezed,
    Object? status = null,
    Object? error = null,
    Object? estimatedSize = null,
    Object? detectedFormat = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      originalData: null == originalData
          ? _value.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      processedData: freezed == processedData
          ? _value.processedData
          : processedData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageReductionResult?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProcessingStatus,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedSize: null == estimatedSize
          ? _value.estimatedSize
          : estimatedSize // ignore: cast_nullable_to_non_nullable
              as int,
      detectedFormat: freezed == detectedFormat
          ? _value.detectedFormat
          : detectedFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ImageMetadata?,
    ) as $Val);
  }

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageMetadataCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $ImageMetadataCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProcessedImageImplCopyWith<$Res>
    implements $ProcessedImageCopyWith<$Res> {
  factory _$$ProcessedImageImplCopyWith(_$ProcessedImageImpl value,
          $Res Function(_$ProcessedImageImpl) then) =
      __$$ProcessedImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fileName,
      Uint8List originalData,
      Uint8List? processedData,
      ImageReductionResult? result,
      ProcessingStatus status,
      String error,
      int estimatedSize,
      ConvertibleFormat? detectedFormat,
      ImageMetadata? metadata});

  @override
  $ImageMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class __$$ProcessedImageImplCopyWithImpl<$Res>
    extends _$ProcessedImageCopyWithImpl<$Res, _$ProcessedImageImpl>
    implements _$$ProcessedImageImplCopyWith<$Res> {
  __$$ProcessedImageImplCopyWithImpl(
      _$ProcessedImageImpl _value, $Res Function(_$ProcessedImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? originalData = null,
    Object? processedData = freezed,
    Object? result = freezed,
    Object? status = null,
    Object? error = null,
    Object? estimatedSize = null,
    Object? detectedFormat = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ProcessedImageImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      originalData: null == originalData
          ? _value.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      processedData: freezed == processedData
          ? _value.processedData
          : processedData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageReductionResult?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProcessingStatus,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedSize: null == estimatedSize
          ? _value.estimatedSize
          : estimatedSize // ignore: cast_nullable_to_non_nullable
              as int,
      detectedFormat: freezed == detectedFormat
          ? _value.detectedFormat
          : detectedFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ImageMetadata?,
    ));
  }
}

/// @nodoc

class _$ProcessedImageImpl extends _ProcessedImage {
  const _$ProcessedImageImpl(
      {required this.fileName,
      required this.originalData,
      this.processedData,
      this.result,
      this.status = ProcessingStatus.pending,
      this.error = '',
      this.estimatedSize = 0,
      this.detectedFormat,
      this.metadata})
      : super._();

  @override
  final String fileName;
  @override
  final Uint8List originalData;
  @override
  final Uint8List? processedData;
  @override
  final ImageReductionResult? result;
  @override
  @JsonKey()
  final ProcessingStatus status;
  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final int estimatedSize;
  @override
  final ConvertibleFormat? detectedFormat;
  @override
  final ImageMetadata? metadata;

  @override
  String toString() {
    return 'ProcessedImage(fileName: $fileName, originalData: $originalData, processedData: $processedData, result: $result, status: $status, error: $error, estimatedSize: $estimatedSize, detectedFormat: $detectedFormat, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcessedImageImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality()
                .equals(other.originalData, originalData) &&
            const DeepCollectionEquality()
                .equals(other.processedData, processedData) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.estimatedSize, estimatedSize) ||
                other.estimatedSize == estimatedSize) &&
            (identical(other.detectedFormat, detectedFormat) ||
                other.detectedFormat == detectedFormat) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      fileName,
      const DeepCollectionEquality().hash(originalData),
      const DeepCollectionEquality().hash(processedData),
      result,
      status,
      error,
      estimatedSize,
      detectedFormat,
      metadata);

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcessedImageImplCopyWith<_$ProcessedImageImpl> get copyWith =>
      __$$ProcessedImageImplCopyWithImpl<_$ProcessedImageImpl>(
          this, _$identity);
}

abstract class _ProcessedImage extends ProcessedImage {
  const factory _ProcessedImage(
      {required final String fileName,
      required final Uint8List originalData,
      final Uint8List? processedData,
      final ImageReductionResult? result,
      final ProcessingStatus status,
      final String error,
      final int estimatedSize,
      final ConvertibleFormat? detectedFormat,
      final ImageMetadata? metadata}) = _$ProcessedImageImpl;
  const _ProcessedImage._() : super._();

  @override
  String get fileName;
  @override
  Uint8List get originalData;
  @override
  Uint8List? get processedData;
  @override
  ImageReductionResult? get result;
  @override
  ProcessingStatus get status;
  @override
  String get error;
  @override
  int get estimatedSize;
  @override
  ConvertibleFormat? get detectedFormat;
  @override
  ImageMetadata? get metadata;

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcessedImageImplCopyWith<_$ProcessedImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ImageMetadata {
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  bool get hasAlpha => throw _privateConstructorUsedError;
  int get colorChannels => throw _privateConstructorUsedError;
  bool get hasMetadata => throw _privateConstructorUsedError;
  bool get hasGpsData => throw _privateConstructorUsedError;
  List<String> get metadataTypes => throw _privateConstructorUsedError;

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageMetadataCopyWith<ImageMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageMetadataCopyWith<$Res> {
  factory $ImageMetadataCopyWith(
          ImageMetadata value, $Res Function(ImageMetadata) then) =
      _$ImageMetadataCopyWithImpl<$Res, ImageMetadata>;
  @useResult
  $Res call(
      {int width,
      int height,
      String format,
      bool hasAlpha,
      int colorChannels,
      bool hasMetadata,
      bool hasGpsData,
      List<String> metadataTypes});
}

/// @nodoc
class _$ImageMetadataCopyWithImpl<$Res, $Val extends ImageMetadata>
    implements $ImageMetadataCopyWith<$Res> {
  _$ImageMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? format = null,
    Object? hasAlpha = null,
    Object? colorChannels = null,
    Object? hasMetadata = null,
    Object? hasGpsData = null,
    Object? metadataTypes = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      hasAlpha: null == hasAlpha
          ? _value.hasAlpha
          : hasAlpha // ignore: cast_nullable_to_non_nullable
              as bool,
      colorChannels: null == colorChannels
          ? _value.colorChannels
          : colorChannels // ignore: cast_nullable_to_non_nullable
              as int,
      hasMetadata: null == hasMetadata
          ? _value.hasMetadata
          : hasMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGpsData: null == hasGpsData
          ? _value.hasGpsData
          : hasGpsData // ignore: cast_nullable_to_non_nullable
              as bool,
      metadataTypes: null == metadataTypes
          ? _value.metadataTypes
          : metadataTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageMetadataImplCopyWith<$Res>
    implements $ImageMetadataCopyWith<$Res> {
  factory _$$ImageMetadataImplCopyWith(
          _$ImageMetadataImpl value, $Res Function(_$ImageMetadataImpl) then) =
      __$$ImageMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int width,
      int height,
      String format,
      bool hasAlpha,
      int colorChannels,
      bool hasMetadata,
      bool hasGpsData,
      List<String> metadataTypes});
}

/// @nodoc
class __$$ImageMetadataImplCopyWithImpl<$Res>
    extends _$ImageMetadataCopyWithImpl<$Res, _$ImageMetadataImpl>
    implements _$$ImageMetadataImplCopyWith<$Res> {
  __$$ImageMetadataImplCopyWithImpl(
      _$ImageMetadataImpl _value, $Res Function(_$ImageMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? format = null,
    Object? hasAlpha = null,
    Object? colorChannels = null,
    Object? hasMetadata = null,
    Object? hasGpsData = null,
    Object? metadataTypes = null,
  }) {
    return _then(_$ImageMetadataImpl(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      hasAlpha: null == hasAlpha
          ? _value.hasAlpha
          : hasAlpha // ignore: cast_nullable_to_non_nullable
              as bool,
      colorChannels: null == colorChannels
          ? _value.colorChannels
          : colorChannels // ignore: cast_nullable_to_non_nullable
              as int,
      hasMetadata: null == hasMetadata
          ? _value.hasMetadata
          : hasMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGpsData: null == hasGpsData
          ? _value.hasGpsData
          : hasGpsData // ignore: cast_nullable_to_non_nullable
              as bool,
      metadataTypes: null == metadataTypes
          ? _value._metadataTypes
          : metadataTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ImageMetadataImpl extends _ImageMetadata {
  const _$ImageMetadataImpl(
      {required this.width,
      required this.height,
      required this.format,
      this.hasAlpha = false,
      this.colorChannels = 0,
      this.hasMetadata = false,
      this.hasGpsData = false,
      final List<String> metadataTypes = const <String>[]})
      : _metadataTypes = metadataTypes,
        super._();

  @override
  final int width;
  @override
  final int height;
  @override
  final String format;
  @override
  @JsonKey()
  final bool hasAlpha;
  @override
  @JsonKey()
  final int colorChannels;
  @override
  @JsonKey()
  final bool hasMetadata;
  @override
  @JsonKey()
  final bool hasGpsData;
  final List<String> _metadataTypes;
  @override
  @JsonKey()
  List<String> get metadataTypes {
    if (_metadataTypes is EqualUnmodifiableListView) return _metadataTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metadataTypes);
  }

  @override
  String toString() {
    return 'ImageMetadata(width: $width, height: $height, format: $format, hasAlpha: $hasAlpha, colorChannels: $colorChannels, hasMetadata: $hasMetadata, hasGpsData: $hasGpsData, metadataTypes: $metadataTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageMetadataImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.hasAlpha, hasAlpha) ||
                other.hasAlpha == hasAlpha) &&
            (identical(other.colorChannels, colorChannels) ||
                other.colorChannels == colorChannels) &&
            (identical(other.hasMetadata, hasMetadata) ||
                other.hasMetadata == hasMetadata) &&
            (identical(other.hasGpsData, hasGpsData) ||
                other.hasGpsData == hasGpsData) &&
            const DeepCollectionEquality()
                .equals(other._metadataTypes, _metadataTypes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      width,
      height,
      format,
      hasAlpha,
      colorChannels,
      hasMetadata,
      hasGpsData,
      const DeepCollectionEquality().hash(_metadataTypes));

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageMetadataImplCopyWith<_$ImageMetadataImpl> get copyWith =>
      __$$ImageMetadataImplCopyWithImpl<_$ImageMetadataImpl>(this, _$identity);
}

abstract class _ImageMetadata extends ImageMetadata {
  const factory _ImageMetadata(
      {required final int width,
      required final int height,
      required final String format,
      final bool hasAlpha,
      final int colorChannels,
      final bool hasMetadata,
      final bool hasGpsData,
      final List<String> metadataTypes}) = _$ImageMetadataImpl;
  const _ImageMetadata._() : super._();

  @override
  int get width;
  @override
  int get height;
  @override
  String get format;
  @override
  bool get hasAlpha;
  @override
  int get colorChannels;
  @override
  bool get hasMetadata;
  @override
  bool get hasGpsData;
  @override
  List<String> get metadataTypes;

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageMetadataImplCopyWith<_$ImageMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
