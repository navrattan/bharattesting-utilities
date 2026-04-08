// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_reducer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageReducerState {
  List<ProcessedImage> get images;
  bool get isProcessing;
  int get quality;
  ResizePreset get selectedPreset;
  ConvertibleFormat get targetFormat;
  ConversionStrategy get strategy;
  PrivacyLevel get privacyLevel;
  bool get stripMetadata;
  bool get enableResize;
  bool get enableFormatConversion;
  int get processingProgress;
  List<String> get processingErrors;
  ProcessedImage? get selectedImage;
  bool get showAdvancedSettings;
  bool get showBatchMode;

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageReducerStateCopyWith<ImageReducerState> get copyWith =>
      _$ImageReducerStateCopyWithImpl<ImageReducerState>(
          this as ImageReducerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageReducerState &&
            const DeepCollectionEquality().equals(other.images, images) &&
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
                .equals(other.processingErrors, processingErrors) &&
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
      const DeepCollectionEquality().hash(images),
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
      const DeepCollectionEquality().hash(processingErrors),
      selectedImage,
      showAdvancedSettings,
      showBatchMode);

  @override
  String toString() {
    return 'ImageReducerState(images: $images, isProcessing: $isProcessing, quality: $quality, selectedPreset: $selectedPreset, targetFormat: $targetFormat, strategy: $strategy, privacyLevel: $privacyLevel, stripMetadata: $stripMetadata, enableResize: $enableResize, enableFormatConversion: $enableFormatConversion, processingProgress: $processingProgress, processingErrors: $processingErrors, selectedImage: $selectedImage, showAdvancedSettings: $showAdvancedSettings, showBatchMode: $showBatchMode)';
  }
}

/// @nodoc
abstract mixin class $ImageReducerStateCopyWith<$Res> {
  factory $ImageReducerStateCopyWith(
          ImageReducerState value, $Res Function(ImageReducerState) _then) =
      _$ImageReducerStateCopyWithImpl;
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
class _$ImageReducerStateCopyWithImpl<$Res>
    implements $ImageReducerStateCopyWith<$Res> {
  _$ImageReducerStateCopyWithImpl(this._self, this._then);

  final ImageReducerState _self;
  final $Res Function(ImageReducerState) _then;

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
    return _then(_self.copyWith(
      images: null == images
          ? _self.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProcessedImage>,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      selectedPreset: null == selectedPreset
          ? _self.selectedPreset
          : selectedPreset // ignore: cast_nullable_to_non_nullable
              as ResizePreset,
      targetFormat: null == targetFormat
          ? _self.targetFormat
          : targetFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat,
      strategy: null == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as ConversionStrategy,
      privacyLevel: null == privacyLevel
          ? _self.privacyLevel
          : privacyLevel // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      stripMetadata: null == stripMetadata
          ? _self.stripMetadata
          : stripMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      enableResize: null == enableResize
          ? _self.enableResize
          : enableResize // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFormatConversion: null == enableFormatConversion
          ? _self.enableFormatConversion
          : enableFormatConversion // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _self.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _self.processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedImage: freezed == selectedImage
          ? _self.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as ProcessedImage?,
      showAdvancedSettings: null == showAdvancedSettings
          ? _self.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      showBatchMode: null == showBatchMode
          ? _self.showBatchMode
          : showBatchMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProcessedImageCopyWith<$Res>? get selectedImage {
    if (_self.selectedImage == null) {
      return null;
    }

    return $ProcessedImageCopyWith<$Res>(_self.selectedImage!, (value) {
      return _then(_self.copyWith(selectedImage: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ImageReducerState].
extension ImageReducerStatePatterns on ImageReducerState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ImageReducerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageReducerState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ImageReducerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageReducerState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ImageReducerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageReducerState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<ProcessedImage> images,
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
            bool showBatchMode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageReducerState() when $default != null:
        return $default(
            _that.images,
            _that.isProcessing,
            _that.quality,
            _that.selectedPreset,
            _that.targetFormat,
            _that.strategy,
            _that.privacyLevel,
            _that.stripMetadata,
            _that.enableResize,
            _that.enableFormatConversion,
            _that.processingProgress,
            _that.processingErrors,
            _that.selectedImage,
            _that.showAdvancedSettings,
            _that.showBatchMode);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<ProcessedImage> images,
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
            bool showBatchMode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageReducerState():
        return $default(
            _that.images,
            _that.isProcessing,
            _that.quality,
            _that.selectedPreset,
            _that.targetFormat,
            _that.strategy,
            _that.privacyLevel,
            _that.stripMetadata,
            _that.enableResize,
            _that.enableFormatConversion,
            _that.processingProgress,
            _that.processingErrors,
            _that.selectedImage,
            _that.showAdvancedSettings,
            _that.showBatchMode);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<ProcessedImage> images,
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
            bool showBatchMode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageReducerState() when $default != null:
        return $default(
            _that.images,
            _that.isProcessing,
            _that.quality,
            _that.selectedPreset,
            _that.targetFormat,
            _that.strategy,
            _that.privacyLevel,
            _that.stripMetadata,
            _that.enableResize,
            _that.enableFormatConversion,
            _that.processingProgress,
            _that.processingErrors,
            _that.selectedImage,
            _that.showAdvancedSettings,
            _that.showBatchMode);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ImageReducerState extends ImageReducerState {
  const _ImageReducerState(
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

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ImageReducerStateCopyWith<_ImageReducerState> get copyWith =>
      __$ImageReducerStateCopyWithImpl<_ImageReducerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImageReducerState &&
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

  @override
  String toString() {
    return 'ImageReducerState(images: $images, isProcessing: $isProcessing, quality: $quality, selectedPreset: $selectedPreset, targetFormat: $targetFormat, strategy: $strategy, privacyLevel: $privacyLevel, stripMetadata: $stripMetadata, enableResize: $enableResize, enableFormatConversion: $enableFormatConversion, processingProgress: $processingProgress, processingErrors: $processingErrors, selectedImage: $selectedImage, showAdvancedSettings: $showAdvancedSettings, showBatchMode: $showBatchMode)';
  }
}

/// @nodoc
abstract mixin class _$ImageReducerStateCopyWith<$Res>
    implements $ImageReducerStateCopyWith<$Res> {
  factory _$ImageReducerStateCopyWith(
          _ImageReducerState value, $Res Function(_ImageReducerState) _then) =
      __$ImageReducerStateCopyWithImpl;
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
class __$ImageReducerStateCopyWithImpl<$Res>
    implements _$ImageReducerStateCopyWith<$Res> {
  __$ImageReducerStateCopyWithImpl(this._self, this._then);

  final _ImageReducerState _self;
  final $Res Function(_ImageReducerState) _then;

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_ImageReducerState(
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProcessedImage>,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      quality: null == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      selectedPreset: null == selectedPreset
          ? _self.selectedPreset
          : selectedPreset // ignore: cast_nullable_to_non_nullable
              as ResizePreset,
      targetFormat: null == targetFormat
          ? _self.targetFormat
          : targetFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat,
      strategy: null == strategy
          ? _self.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as ConversionStrategy,
      privacyLevel: null == privacyLevel
          ? _self.privacyLevel
          : privacyLevel // ignore: cast_nullable_to_non_nullable
              as PrivacyLevel,
      stripMetadata: null == stripMetadata
          ? _self.stripMetadata
          : stripMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      enableResize: null == enableResize
          ? _self.enableResize
          : enableResize // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFormatConversion: null == enableFormatConversion
          ? _self.enableFormatConversion
          : enableFormatConversion // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _self.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _self._processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedImage: freezed == selectedImage
          ? _self.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as ProcessedImage?,
      showAdvancedSettings: null == showAdvancedSettings
          ? _self.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      showBatchMode: null == showBatchMode
          ? _self.showBatchMode
          : showBatchMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ImageReducerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProcessedImageCopyWith<$Res>? get selectedImage {
    if (_self.selectedImage == null) {
      return null;
    }

    return $ProcessedImageCopyWith<$Res>(_self.selectedImage!, (value) {
      return _then(_self.copyWith(selectedImage: value));
    });
  }
}

/// @nodoc
mixin _$ProcessedImage {
  String get fileName;
  Uint8List get originalData;
  Uint8List? get processedData;
  ImageReductionResult? get result;
  ProcessingStatus get status;
  String get error;
  int get estimatedSize;
  ConvertibleFormat? get detectedFormat;
  ImageMetadata? get metadata;

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProcessedImageCopyWith<ProcessedImage> get copyWith =>
      _$ProcessedImageCopyWithImpl<ProcessedImage>(
          this as ProcessedImage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProcessedImage &&
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

  @override
  String toString() {
    return 'ProcessedImage(fileName: $fileName, originalData: $originalData, processedData: $processedData, result: $result, status: $status, error: $error, estimatedSize: $estimatedSize, detectedFormat: $detectedFormat, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $ProcessedImageCopyWith<$Res> {
  factory $ProcessedImageCopyWith(
          ProcessedImage value, $Res Function(ProcessedImage) _then) =
      _$ProcessedImageCopyWithImpl;
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
class _$ProcessedImageCopyWithImpl<$Res>
    implements $ProcessedImageCopyWith<$Res> {
  _$ProcessedImageCopyWithImpl(this._self, this._then);

  final ProcessedImage _self;
  final $Res Function(ProcessedImage) _then;

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
    return _then(_self.copyWith(
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      originalData: null == originalData
          ? _self.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      processedData: freezed == processedData
          ? _self.processedData
          : processedData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageReductionResult?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProcessingStatus,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedSize: null == estimatedSize
          ? _self.estimatedSize
          : estimatedSize // ignore: cast_nullable_to_non_nullable
              as int,
      detectedFormat: freezed == detectedFormat
          ? _self.detectedFormat
          : detectedFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat?,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ImageMetadata?,
    ));
  }

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
      return null;
    }

    return $ImageMetadataCopyWith<$Res>(_self.metadata!, (value) {
      return _then(_self.copyWith(metadata: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ProcessedImage].
extension ProcessedImagePatterns on ProcessedImage {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProcessedImage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProcessedImage() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProcessedImage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessedImage():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProcessedImage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessedImage() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String fileName,
            Uint8List originalData,
            Uint8List? processedData,
            ImageReductionResult? result,
            ProcessingStatus status,
            String error,
            int estimatedSize,
            ConvertibleFormat? detectedFormat,
            ImageMetadata? metadata)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProcessedImage() when $default != null:
        return $default(
            _that.fileName,
            _that.originalData,
            _that.processedData,
            _that.result,
            _that.status,
            _that.error,
            _that.estimatedSize,
            _that.detectedFormat,
            _that.metadata);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String fileName,
            Uint8List originalData,
            Uint8List? processedData,
            ImageReductionResult? result,
            ProcessingStatus status,
            String error,
            int estimatedSize,
            ConvertibleFormat? detectedFormat,
            ImageMetadata? metadata)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessedImage():
        return $default(
            _that.fileName,
            _that.originalData,
            _that.processedData,
            _that.result,
            _that.status,
            _that.error,
            _that.estimatedSize,
            _that.detectedFormat,
            _that.metadata);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String fileName,
            Uint8List originalData,
            Uint8List? processedData,
            ImageReductionResult? result,
            ProcessingStatus status,
            String error,
            int estimatedSize,
            ConvertibleFormat? detectedFormat,
            ImageMetadata? metadata)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessedImage() when $default != null:
        return $default(
            _that.fileName,
            _that.originalData,
            _that.processedData,
            _that.result,
            _that.status,
            _that.error,
            _that.estimatedSize,
            _that.detectedFormat,
            _that.metadata);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ProcessedImage extends ProcessedImage {
  const _ProcessedImage(
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

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProcessedImageCopyWith<_ProcessedImage> get copyWith =>
      __$ProcessedImageCopyWithImpl<_ProcessedImage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProcessedImage &&
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

  @override
  String toString() {
    return 'ProcessedImage(fileName: $fileName, originalData: $originalData, processedData: $processedData, result: $result, status: $status, error: $error, estimatedSize: $estimatedSize, detectedFormat: $detectedFormat, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$ProcessedImageCopyWith<$Res>
    implements $ProcessedImageCopyWith<$Res> {
  factory _$ProcessedImageCopyWith(
          _ProcessedImage value, $Res Function(_ProcessedImage) _then) =
      __$ProcessedImageCopyWithImpl;
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
class __$ProcessedImageCopyWithImpl<$Res>
    implements _$ProcessedImageCopyWith<$Res> {
  __$ProcessedImageCopyWithImpl(this._self, this._then);

  final _ProcessedImage _self;
  final $Res Function(_ProcessedImage) _then;

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_ProcessedImage(
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      originalData: null == originalData
          ? _self.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      processedData: freezed == processedData
          ? _self.processedData
          : processedData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageReductionResult?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProcessingStatus,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedSize: null == estimatedSize
          ? _self.estimatedSize
          : estimatedSize // ignore: cast_nullable_to_non_nullable
              as int,
      detectedFormat: freezed == detectedFormat
          ? _self.detectedFormat
          : detectedFormat // ignore: cast_nullable_to_non_nullable
              as ConvertibleFormat?,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ImageMetadata?,
    ));
  }

  /// Create a copy of ProcessedImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
      return null;
    }

    return $ImageMetadataCopyWith<$Res>(_self.metadata!, (value) {
      return _then(_self.copyWith(metadata: value));
    });
  }
}

/// @nodoc
mixin _$ImageMetadata {
  int get width;
  int get height;
  String get format;
  bool get hasAlpha;
  int get colorChannels;
  bool get hasMetadata;
  bool get hasGpsData;
  List<String> get metadataTypes;

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageMetadataCopyWith<ImageMetadata> get copyWith =>
      _$ImageMetadataCopyWithImpl<ImageMetadata>(
          this as ImageMetadata, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageMetadata &&
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
                .equals(other.metadataTypes, metadataTypes));
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
      const DeepCollectionEquality().hash(metadataTypes));

  @override
  String toString() {
    return 'ImageMetadata(width: $width, height: $height, format: $format, hasAlpha: $hasAlpha, colorChannels: $colorChannels, hasMetadata: $hasMetadata, hasGpsData: $hasGpsData, metadataTypes: $metadataTypes)';
  }
}

/// @nodoc
abstract mixin class $ImageMetadataCopyWith<$Res> {
  factory $ImageMetadataCopyWith(
          ImageMetadata value, $Res Function(ImageMetadata) _then) =
      _$ImageMetadataCopyWithImpl;
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
class _$ImageMetadataCopyWithImpl<$Res>
    implements $ImageMetadataCopyWith<$Res> {
  _$ImageMetadataCopyWithImpl(this._self, this._then);

  final ImageMetadata _self;
  final $Res Function(ImageMetadata) _then;

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
    return _then(_self.copyWith(
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      format: null == format
          ? _self.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      hasAlpha: null == hasAlpha
          ? _self.hasAlpha
          : hasAlpha // ignore: cast_nullable_to_non_nullable
              as bool,
      colorChannels: null == colorChannels
          ? _self.colorChannels
          : colorChannels // ignore: cast_nullable_to_non_nullable
              as int,
      hasMetadata: null == hasMetadata
          ? _self.hasMetadata
          : hasMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGpsData: null == hasGpsData
          ? _self.hasGpsData
          : hasGpsData // ignore: cast_nullable_to_non_nullable
              as bool,
      metadataTypes: null == metadataTypes
          ? _self.metadataTypes
          : metadataTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ImageMetadata].
extension ImageMetadataPatterns on ImageMetadata {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ImageMetadata value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageMetadata() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ImageMetadata value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMetadata():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ImageMetadata value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMetadata() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int width,
            int height,
            String format,
            bool hasAlpha,
            int colorChannels,
            bool hasMetadata,
            bool hasGpsData,
            List<String> metadataTypes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageMetadata() when $default != null:
        return $default(
            _that.width,
            _that.height,
            _that.format,
            _that.hasAlpha,
            _that.colorChannels,
            _that.hasMetadata,
            _that.hasGpsData,
            _that.metadataTypes);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int width,
            int height,
            String format,
            bool hasAlpha,
            int colorChannels,
            bool hasMetadata,
            bool hasGpsData,
            List<String> metadataTypes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMetadata():
        return $default(
            _that.width,
            _that.height,
            _that.format,
            _that.hasAlpha,
            _that.colorChannels,
            _that.hasMetadata,
            _that.hasGpsData,
            _that.metadataTypes);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int width,
            int height,
            String format,
            bool hasAlpha,
            int colorChannels,
            bool hasMetadata,
            bool hasGpsData,
            List<String> metadataTypes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMetadata() when $default != null:
        return $default(
            _that.width,
            _that.height,
            _that.format,
            _that.hasAlpha,
            _that.colorChannels,
            _that.hasMetadata,
            _that.hasGpsData,
            _that.metadataTypes);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ImageMetadata extends ImageMetadata {
  const _ImageMetadata(
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

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ImageMetadataCopyWith<_ImageMetadata> get copyWith =>
      __$ImageMetadataCopyWithImpl<_ImageMetadata>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImageMetadata &&
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

  @override
  String toString() {
    return 'ImageMetadata(width: $width, height: $height, format: $format, hasAlpha: $hasAlpha, colorChannels: $colorChannels, hasMetadata: $hasMetadata, hasGpsData: $hasGpsData, metadataTypes: $metadataTypes)';
  }
}

/// @nodoc
abstract mixin class _$ImageMetadataCopyWith<$Res>
    implements $ImageMetadataCopyWith<$Res> {
  factory _$ImageMetadataCopyWith(
          _ImageMetadata value, $Res Function(_ImageMetadata) _then) =
      __$ImageMetadataCopyWithImpl;
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
class __$ImageMetadataCopyWithImpl<$Res>
    implements _$ImageMetadataCopyWith<$Res> {
  __$ImageMetadataCopyWithImpl(this._self, this._then);

  final _ImageMetadata _self;
  final $Res Function(_ImageMetadata) _then;

  /// Create a copy of ImageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_ImageMetadata(
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      format: null == format
          ? _self.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      hasAlpha: null == hasAlpha
          ? _self.hasAlpha
          : hasAlpha // ignore: cast_nullable_to_non_nullable
              as bool,
      colorChannels: null == colorChannels
          ? _self.colorChannels
          : colorChannels // ignore: cast_nullable_to_non_nullable
              as int,
      hasMetadata: null == hasMetadata
          ? _self.hasMetadata
          : hasMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGpsData: null == hasGpsData
          ? _self.hasGpsData
          : hasGpsData // ignore: cast_nullable_to_non_nullable
              as bool,
      metadataTypes: null == metadataTypes
          ? _self._metadataTypes
          : metadataTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
