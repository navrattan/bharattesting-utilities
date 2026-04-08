// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FakerState {
// Template selection
  TemplateType get selectedTemplate; // Generation options
  BulkSize get bulkSize;
  bool get useRandomSeed;
  int? get customSeed;
  String? get preferredState; // Identifier toggles (for custom selection)
  bool get includeAllIdentifiers;
  Set<String> get selectedIdentifiers; // Generated data
  List<Map<String, dynamic>> get generatedRecords;
  DateTime? get lastGeneratedAt; // Export options
  ExportFormat get selectedExportFormat;
  bool get includeMetadata;
  bool get prettifyOutput; // UI state
  bool get isGenerating;
  bool get isExporting;
  String? get lastExportPath;
  String? get errorMessage; // Performance metrics
  int? get lastGenerationTimeMs;
  int? get lastExportTimeMs;

  /// Create a copy of FakerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FakerStateCopyWith<FakerState> get copyWith =>
      _$FakerStateCopyWithImpl<FakerState>(this as FakerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FakerState &&
            (identical(other.selectedTemplate, selectedTemplate) ||
                other.selectedTemplate == selectedTemplate) &&
            (identical(other.bulkSize, bulkSize) ||
                other.bulkSize == bulkSize) &&
            (identical(other.useRandomSeed, useRandomSeed) ||
                other.useRandomSeed == useRandomSeed) &&
            (identical(other.customSeed, customSeed) ||
                other.customSeed == customSeed) &&
            (identical(other.preferredState, preferredState) ||
                other.preferredState == preferredState) &&
            (identical(other.includeAllIdentifiers, includeAllIdentifiers) ||
                other.includeAllIdentifiers == includeAllIdentifiers) &&
            const DeepCollectionEquality()
                .equals(other.selectedIdentifiers, selectedIdentifiers) &&
            const DeepCollectionEquality()
                .equals(other.generatedRecords, generatedRecords) &&
            (identical(other.lastGeneratedAt, lastGeneratedAt) ||
                other.lastGeneratedAt == lastGeneratedAt) &&
            (identical(other.selectedExportFormat, selectedExportFormat) ||
                other.selectedExportFormat == selectedExportFormat) &&
            (identical(other.includeMetadata, includeMetadata) ||
                other.includeMetadata == includeMetadata) &&
            (identical(other.prettifyOutput, prettifyOutput) ||
                other.prettifyOutput == prettifyOutput) &&
            (identical(other.isGenerating, isGenerating) ||
                other.isGenerating == isGenerating) &&
            (identical(other.isExporting, isExporting) ||
                other.isExporting == isExporting) &&
            (identical(other.lastExportPath, lastExportPath) ||
                other.lastExportPath == lastExportPath) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.lastGenerationTimeMs, lastGenerationTimeMs) ||
                other.lastGenerationTimeMs == lastGenerationTimeMs) &&
            (identical(other.lastExportTimeMs, lastExportTimeMs) ||
                other.lastExportTimeMs == lastExportTimeMs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedTemplate,
      bulkSize,
      useRandomSeed,
      customSeed,
      preferredState,
      includeAllIdentifiers,
      const DeepCollectionEquality().hash(selectedIdentifiers),
      const DeepCollectionEquality().hash(generatedRecords),
      lastGeneratedAt,
      selectedExportFormat,
      includeMetadata,
      prettifyOutput,
      isGenerating,
      isExporting,
      lastExportPath,
      errorMessage,
      lastGenerationTimeMs,
      lastExportTimeMs);

  @override
  String toString() {
    return 'FakerState(selectedTemplate: $selectedTemplate, bulkSize: $bulkSize, useRandomSeed: $useRandomSeed, customSeed: $customSeed, preferredState: $preferredState, includeAllIdentifiers: $includeAllIdentifiers, selectedIdentifiers: $selectedIdentifiers, generatedRecords: $generatedRecords, lastGeneratedAt: $lastGeneratedAt, selectedExportFormat: $selectedExportFormat, includeMetadata: $includeMetadata, prettifyOutput: $prettifyOutput, isGenerating: $isGenerating, isExporting: $isExporting, lastExportPath: $lastExportPath, errorMessage: $errorMessage, lastGenerationTimeMs: $lastGenerationTimeMs, lastExportTimeMs: $lastExportTimeMs)';
  }
}

/// @nodoc
abstract mixin class $FakerStateCopyWith<$Res> {
  factory $FakerStateCopyWith(
          FakerState value, $Res Function(FakerState) _then) =
      _$FakerStateCopyWithImpl;
  @useResult
  $Res call(
      {TemplateType selectedTemplate,
      BulkSize bulkSize,
      bool useRandomSeed,
      int? customSeed,
      String? preferredState,
      bool includeAllIdentifiers,
      Set<String> selectedIdentifiers,
      List<Map<String, dynamic>> generatedRecords,
      DateTime? lastGeneratedAt,
      ExportFormat selectedExportFormat,
      bool includeMetadata,
      bool prettifyOutput,
      bool isGenerating,
      bool isExporting,
      String? lastExportPath,
      String? errorMessage,
      int? lastGenerationTimeMs,
      int? lastExportTimeMs});
}

/// @nodoc
class _$FakerStateCopyWithImpl<$Res> implements $FakerStateCopyWith<$Res> {
  _$FakerStateCopyWithImpl(this._self, this._then);

  final FakerState _self;
  final $Res Function(FakerState) _then;

  /// Create a copy of FakerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTemplate = null,
    Object? bulkSize = null,
    Object? useRandomSeed = null,
    Object? customSeed = freezed,
    Object? preferredState = freezed,
    Object? includeAllIdentifiers = null,
    Object? selectedIdentifiers = null,
    Object? generatedRecords = null,
    Object? lastGeneratedAt = freezed,
    Object? selectedExportFormat = null,
    Object? includeMetadata = null,
    Object? prettifyOutput = null,
    Object? isGenerating = null,
    Object? isExporting = null,
    Object? lastExportPath = freezed,
    Object? errorMessage = freezed,
    Object? lastGenerationTimeMs = freezed,
    Object? lastExportTimeMs = freezed,
  }) {
    return _then(_self.copyWith(
      selectedTemplate: null == selectedTemplate
          ? _self.selectedTemplate
          : selectedTemplate // ignore: cast_nullable_to_non_nullable
              as TemplateType,
      bulkSize: null == bulkSize
          ? _self.bulkSize
          : bulkSize // ignore: cast_nullable_to_non_nullable
              as BulkSize,
      useRandomSeed: null == useRandomSeed
          ? _self.useRandomSeed
          : useRandomSeed // ignore: cast_nullable_to_non_nullable
              as bool,
      customSeed: freezed == customSeed
          ? _self.customSeed
          : customSeed // ignore: cast_nullable_to_non_nullable
              as int?,
      preferredState: freezed == preferredState
          ? _self.preferredState
          : preferredState // ignore: cast_nullable_to_non_nullable
              as String?,
      includeAllIdentifiers: null == includeAllIdentifiers
          ? _self.includeAllIdentifiers
          : includeAllIdentifiers // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedIdentifiers: null == selectedIdentifiers
          ? _self.selectedIdentifiers
          : selectedIdentifiers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      generatedRecords: null == generatedRecords
          ? _self.generatedRecords
          : generatedRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      lastGeneratedAt: freezed == lastGeneratedAt
          ? _self.lastGeneratedAt
          : lastGeneratedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedExportFormat: null == selectedExportFormat
          ? _self.selectedExportFormat
          : selectedExportFormat // ignore: cast_nullable_to_non_nullable
              as ExportFormat,
      includeMetadata: null == includeMetadata
          ? _self.includeMetadata
          : includeMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      prettifyOutput: null == prettifyOutput
          ? _self.prettifyOutput
          : prettifyOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      isGenerating: null == isGenerating
          ? _self.isGenerating
          : isGenerating // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _self.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      lastExportPath: freezed == lastExportPath
          ? _self.lastExportPath
          : lastExportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastGenerationTimeMs: freezed == lastGenerationTimeMs
          ? _self.lastGenerationTimeMs
          : lastGenerationTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      lastExportTimeMs: freezed == lastExportTimeMs
          ? _self.lastExportTimeMs
          : lastExportTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FakerState].
extension FakerStatePatterns on FakerState {
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
    TResult Function(_FakerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FakerState() when $default != null:
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
    TResult Function(_FakerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FakerState():
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
    TResult? Function(_FakerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FakerState() when $default != null:
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
            TemplateType selectedTemplate,
            BulkSize bulkSize,
            bool useRandomSeed,
            int? customSeed,
            String? preferredState,
            bool includeAllIdentifiers,
            Set<String> selectedIdentifiers,
            List<Map<String, dynamic>> generatedRecords,
            DateTime? lastGeneratedAt,
            ExportFormat selectedExportFormat,
            bool includeMetadata,
            bool prettifyOutput,
            bool isGenerating,
            bool isExporting,
            String? lastExportPath,
            String? errorMessage,
            int? lastGenerationTimeMs,
            int? lastExportTimeMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FakerState() when $default != null:
        return $default(
            _that.selectedTemplate,
            _that.bulkSize,
            _that.useRandomSeed,
            _that.customSeed,
            _that.preferredState,
            _that.includeAllIdentifiers,
            _that.selectedIdentifiers,
            _that.generatedRecords,
            _that.lastGeneratedAt,
            _that.selectedExportFormat,
            _that.includeMetadata,
            _that.prettifyOutput,
            _that.isGenerating,
            _that.isExporting,
            _that.lastExportPath,
            _that.errorMessage,
            _that.lastGenerationTimeMs,
            _that.lastExportTimeMs);
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
            TemplateType selectedTemplate,
            BulkSize bulkSize,
            bool useRandomSeed,
            int? customSeed,
            String? preferredState,
            bool includeAllIdentifiers,
            Set<String> selectedIdentifiers,
            List<Map<String, dynamic>> generatedRecords,
            DateTime? lastGeneratedAt,
            ExportFormat selectedExportFormat,
            bool includeMetadata,
            bool prettifyOutput,
            bool isGenerating,
            bool isExporting,
            String? lastExportPath,
            String? errorMessage,
            int? lastGenerationTimeMs,
            int? lastExportTimeMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FakerState():
        return $default(
            _that.selectedTemplate,
            _that.bulkSize,
            _that.useRandomSeed,
            _that.customSeed,
            _that.preferredState,
            _that.includeAllIdentifiers,
            _that.selectedIdentifiers,
            _that.generatedRecords,
            _that.lastGeneratedAt,
            _that.selectedExportFormat,
            _that.includeMetadata,
            _that.prettifyOutput,
            _that.isGenerating,
            _that.isExporting,
            _that.lastExportPath,
            _that.errorMessage,
            _that.lastGenerationTimeMs,
            _that.lastExportTimeMs);
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
            TemplateType selectedTemplate,
            BulkSize bulkSize,
            bool useRandomSeed,
            int? customSeed,
            String? preferredState,
            bool includeAllIdentifiers,
            Set<String> selectedIdentifiers,
            List<Map<String, dynamic>> generatedRecords,
            DateTime? lastGeneratedAt,
            ExportFormat selectedExportFormat,
            bool includeMetadata,
            bool prettifyOutput,
            bool isGenerating,
            bool isExporting,
            String? lastExportPath,
            String? errorMessage,
            int? lastGenerationTimeMs,
            int? lastExportTimeMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FakerState() when $default != null:
        return $default(
            _that.selectedTemplate,
            _that.bulkSize,
            _that.useRandomSeed,
            _that.customSeed,
            _that.preferredState,
            _that.includeAllIdentifiers,
            _that.selectedIdentifiers,
            _that.generatedRecords,
            _that.lastGeneratedAt,
            _that.selectedExportFormat,
            _that.includeMetadata,
            _that.prettifyOutput,
            _that.isGenerating,
            _that.isExporting,
            _that.lastExportPath,
            _that.errorMessage,
            _that.lastGenerationTimeMs,
            _that.lastExportTimeMs);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FakerState implements FakerState {
  const _FakerState(
      {this.selectedTemplate = TemplateType.individual,
      this.bulkSize = BulkSize.single,
      this.useRandomSeed = true,
      this.customSeed = null,
      this.preferredState = null,
      this.includeAllIdentifiers = true,
      final Set<String> selectedIdentifiers = const {},
      final List<Map<String, dynamic>> generatedRecords = const [],
      this.lastGeneratedAt = null,
      this.selectedExportFormat = ExportFormat.json,
      this.includeMetadata = true,
      this.prettifyOutput = true,
      this.isGenerating = false,
      this.isExporting = false,
      this.lastExportPath = null,
      this.errorMessage = null,
      this.lastGenerationTimeMs = null,
      this.lastExportTimeMs = null})
      : _selectedIdentifiers = selectedIdentifiers,
        _generatedRecords = generatedRecords;

// Template selection
  @override
  @JsonKey()
  final TemplateType selectedTemplate;
// Generation options
  @override
  @JsonKey()
  final BulkSize bulkSize;
  @override
  @JsonKey()
  final bool useRandomSeed;
  @override
  @JsonKey()
  final int? customSeed;
  @override
  @JsonKey()
  final String? preferredState;
// Identifier toggles (for custom selection)
  @override
  @JsonKey()
  final bool includeAllIdentifiers;
  final Set<String> _selectedIdentifiers;
  @override
  @JsonKey()
  Set<String> get selectedIdentifiers {
    if (_selectedIdentifiers is EqualUnmodifiableSetView)
      return _selectedIdentifiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedIdentifiers);
  }

// Generated data
  final List<Map<String, dynamic>> _generatedRecords;
// Generated data
  @override
  @JsonKey()
  List<Map<String, dynamic>> get generatedRecords {
    if (_generatedRecords is EqualUnmodifiableListView)
      return _generatedRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_generatedRecords);
  }

  @override
  @JsonKey()
  final DateTime? lastGeneratedAt;
// Export options
  @override
  @JsonKey()
  final ExportFormat selectedExportFormat;
  @override
  @JsonKey()
  final bool includeMetadata;
  @override
  @JsonKey()
  final bool prettifyOutput;
// UI state
  @override
  @JsonKey()
  final bool isGenerating;
  @override
  @JsonKey()
  final bool isExporting;
  @override
  @JsonKey()
  final String? lastExportPath;
  @override
  @JsonKey()
  final String? errorMessage;
// Performance metrics
  @override
  @JsonKey()
  final int? lastGenerationTimeMs;
  @override
  @JsonKey()
  final int? lastExportTimeMs;

  /// Create a copy of FakerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FakerStateCopyWith<_FakerState> get copyWith =>
      __$FakerStateCopyWithImpl<_FakerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FakerState &&
            (identical(other.selectedTemplate, selectedTemplate) ||
                other.selectedTemplate == selectedTemplate) &&
            (identical(other.bulkSize, bulkSize) ||
                other.bulkSize == bulkSize) &&
            (identical(other.useRandomSeed, useRandomSeed) ||
                other.useRandomSeed == useRandomSeed) &&
            (identical(other.customSeed, customSeed) ||
                other.customSeed == customSeed) &&
            (identical(other.preferredState, preferredState) ||
                other.preferredState == preferredState) &&
            (identical(other.includeAllIdentifiers, includeAllIdentifiers) ||
                other.includeAllIdentifiers == includeAllIdentifiers) &&
            const DeepCollectionEquality()
                .equals(other._selectedIdentifiers, _selectedIdentifiers) &&
            const DeepCollectionEquality()
                .equals(other._generatedRecords, _generatedRecords) &&
            (identical(other.lastGeneratedAt, lastGeneratedAt) ||
                other.lastGeneratedAt == lastGeneratedAt) &&
            (identical(other.selectedExportFormat, selectedExportFormat) ||
                other.selectedExportFormat == selectedExportFormat) &&
            (identical(other.includeMetadata, includeMetadata) ||
                other.includeMetadata == includeMetadata) &&
            (identical(other.prettifyOutput, prettifyOutput) ||
                other.prettifyOutput == prettifyOutput) &&
            (identical(other.isGenerating, isGenerating) ||
                other.isGenerating == isGenerating) &&
            (identical(other.isExporting, isExporting) ||
                other.isExporting == isExporting) &&
            (identical(other.lastExportPath, lastExportPath) ||
                other.lastExportPath == lastExportPath) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.lastGenerationTimeMs, lastGenerationTimeMs) ||
                other.lastGenerationTimeMs == lastGenerationTimeMs) &&
            (identical(other.lastExportTimeMs, lastExportTimeMs) ||
                other.lastExportTimeMs == lastExportTimeMs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedTemplate,
      bulkSize,
      useRandomSeed,
      customSeed,
      preferredState,
      includeAllIdentifiers,
      const DeepCollectionEquality().hash(_selectedIdentifiers),
      const DeepCollectionEquality().hash(_generatedRecords),
      lastGeneratedAt,
      selectedExportFormat,
      includeMetadata,
      prettifyOutput,
      isGenerating,
      isExporting,
      lastExportPath,
      errorMessage,
      lastGenerationTimeMs,
      lastExportTimeMs);

  @override
  String toString() {
    return 'FakerState(selectedTemplate: $selectedTemplate, bulkSize: $bulkSize, useRandomSeed: $useRandomSeed, customSeed: $customSeed, preferredState: $preferredState, includeAllIdentifiers: $includeAllIdentifiers, selectedIdentifiers: $selectedIdentifiers, generatedRecords: $generatedRecords, lastGeneratedAt: $lastGeneratedAt, selectedExportFormat: $selectedExportFormat, includeMetadata: $includeMetadata, prettifyOutput: $prettifyOutput, isGenerating: $isGenerating, isExporting: $isExporting, lastExportPath: $lastExportPath, errorMessage: $errorMessage, lastGenerationTimeMs: $lastGenerationTimeMs, lastExportTimeMs: $lastExportTimeMs)';
  }
}

/// @nodoc
abstract mixin class _$FakerStateCopyWith<$Res>
    implements $FakerStateCopyWith<$Res> {
  factory _$FakerStateCopyWith(
          _FakerState value, $Res Function(_FakerState) _then) =
      __$FakerStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TemplateType selectedTemplate,
      BulkSize bulkSize,
      bool useRandomSeed,
      int? customSeed,
      String? preferredState,
      bool includeAllIdentifiers,
      Set<String> selectedIdentifiers,
      List<Map<String, dynamic>> generatedRecords,
      DateTime? lastGeneratedAt,
      ExportFormat selectedExportFormat,
      bool includeMetadata,
      bool prettifyOutput,
      bool isGenerating,
      bool isExporting,
      String? lastExportPath,
      String? errorMessage,
      int? lastGenerationTimeMs,
      int? lastExportTimeMs});
}

/// @nodoc
class __$FakerStateCopyWithImpl<$Res> implements _$FakerStateCopyWith<$Res> {
  __$FakerStateCopyWithImpl(this._self, this._then);

  final _FakerState _self;
  final $Res Function(_FakerState) _then;

  /// Create a copy of FakerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedTemplate = null,
    Object? bulkSize = null,
    Object? useRandomSeed = null,
    Object? customSeed = freezed,
    Object? preferredState = freezed,
    Object? includeAllIdentifiers = null,
    Object? selectedIdentifiers = null,
    Object? generatedRecords = null,
    Object? lastGeneratedAt = freezed,
    Object? selectedExportFormat = null,
    Object? includeMetadata = null,
    Object? prettifyOutput = null,
    Object? isGenerating = null,
    Object? isExporting = null,
    Object? lastExportPath = freezed,
    Object? errorMessage = freezed,
    Object? lastGenerationTimeMs = freezed,
    Object? lastExportTimeMs = freezed,
  }) {
    return _then(_FakerState(
      selectedTemplate: null == selectedTemplate
          ? _self.selectedTemplate
          : selectedTemplate // ignore: cast_nullable_to_non_nullable
              as TemplateType,
      bulkSize: null == bulkSize
          ? _self.bulkSize
          : bulkSize // ignore: cast_nullable_to_non_nullable
              as BulkSize,
      useRandomSeed: null == useRandomSeed
          ? _self.useRandomSeed
          : useRandomSeed // ignore: cast_nullable_to_non_nullable
              as bool,
      customSeed: freezed == customSeed
          ? _self.customSeed
          : customSeed // ignore: cast_nullable_to_non_nullable
              as int?,
      preferredState: freezed == preferredState
          ? _self.preferredState
          : preferredState // ignore: cast_nullable_to_non_nullable
              as String?,
      includeAllIdentifiers: null == includeAllIdentifiers
          ? _self.includeAllIdentifiers
          : includeAllIdentifiers // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedIdentifiers: null == selectedIdentifiers
          ? _self._selectedIdentifiers
          : selectedIdentifiers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      generatedRecords: null == generatedRecords
          ? _self._generatedRecords
          : generatedRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      lastGeneratedAt: freezed == lastGeneratedAt
          ? _self.lastGeneratedAt
          : lastGeneratedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedExportFormat: null == selectedExportFormat
          ? _self.selectedExportFormat
          : selectedExportFormat // ignore: cast_nullable_to_non_nullable
              as ExportFormat,
      includeMetadata: null == includeMetadata
          ? _self.includeMetadata
          : includeMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      prettifyOutput: null == prettifyOutput
          ? _self.prettifyOutput
          : prettifyOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      isGenerating: null == isGenerating
          ? _self.isGenerating
          : isGenerating // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _self.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      lastExportPath: freezed == lastExportPath
          ? _self.lastExportPath
          : lastExportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastGenerationTimeMs: freezed == lastGenerationTimeMs
          ? _self.lastGenerationTimeMs
          : lastGenerationTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      lastExportTimeMs: freezed == lastExportTimeMs
          ? _self.lastExportTimeMs
          : lastExportTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
