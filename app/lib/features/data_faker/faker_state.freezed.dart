// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FakerState {
// Template selection
  TemplateType get selectedTemplate =>
      throw _privateConstructorUsedError; // Generation options
  BulkSize get bulkSize => throw _privateConstructorUsedError;
  bool get useRandomSeed => throw _privateConstructorUsedError;
  int? get customSeed => throw _privateConstructorUsedError;
  String? get preferredState =>
      throw _privateConstructorUsedError; // Identifier toggles (for custom selection)
  bool get includeAllIdentifiers => throw _privateConstructorUsedError;
  Set<String> get selectedIdentifiers =>
      throw _privateConstructorUsedError; // Generated data
  List<Map<String, dynamic>> get generatedRecords =>
      throw _privateConstructorUsedError;
  DateTime? get lastGeneratedAt =>
      throw _privateConstructorUsedError; // Export options
  ExportFormat get selectedExportFormat => throw _privateConstructorUsedError;
  bool get includeMetadata => throw _privateConstructorUsedError;
  bool get prettifyOutput => throw _privateConstructorUsedError; // UI state
  bool get isGenerating => throw _privateConstructorUsedError;
  bool get isExporting => throw _privateConstructorUsedError;
  String? get lastExportPath => throw _privateConstructorUsedError;
  String? get errorMessage =>
      throw _privateConstructorUsedError; // Performance metrics
  int? get lastGenerationTimeMs => throw _privateConstructorUsedError;
  int? get lastExportTimeMs => throw _privateConstructorUsedError;

  /// Create a copy of FakerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FakerStateCopyWith<FakerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FakerStateCopyWith<$Res> {
  factory $FakerStateCopyWith(
          FakerState value, $Res Function(FakerState) then) =
      _$FakerStateCopyWithImpl<$Res, FakerState>;
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
class _$FakerStateCopyWithImpl<$Res, $Val extends FakerState>
    implements $FakerStateCopyWith<$Res> {
  _$FakerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      selectedTemplate: null == selectedTemplate
          ? _value.selectedTemplate
          : selectedTemplate // ignore: cast_nullable_to_non_nullable
              as TemplateType,
      bulkSize: null == bulkSize
          ? _value.bulkSize
          : bulkSize // ignore: cast_nullable_to_non_nullable
              as BulkSize,
      useRandomSeed: null == useRandomSeed
          ? _value.useRandomSeed
          : useRandomSeed // ignore: cast_nullable_to_non_nullable
              as bool,
      customSeed: freezed == customSeed
          ? _value.customSeed
          : customSeed // ignore: cast_nullable_to_non_nullable
              as int?,
      preferredState: freezed == preferredState
          ? _value.preferredState
          : preferredState // ignore: cast_nullable_to_non_nullable
              as String?,
      includeAllIdentifiers: null == includeAllIdentifiers
          ? _value.includeAllIdentifiers
          : includeAllIdentifiers // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedIdentifiers: null == selectedIdentifiers
          ? _value.selectedIdentifiers
          : selectedIdentifiers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      generatedRecords: null == generatedRecords
          ? _value.generatedRecords
          : generatedRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      lastGeneratedAt: freezed == lastGeneratedAt
          ? _value.lastGeneratedAt
          : lastGeneratedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedExportFormat: null == selectedExportFormat
          ? _value.selectedExportFormat
          : selectedExportFormat // ignore: cast_nullable_to_non_nullable
              as ExportFormat,
      includeMetadata: null == includeMetadata
          ? _value.includeMetadata
          : includeMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      prettifyOutput: null == prettifyOutput
          ? _value.prettifyOutput
          : prettifyOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      isGenerating: null == isGenerating
          ? _value.isGenerating
          : isGenerating // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _value.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      lastExportPath: freezed == lastExportPath
          ? _value.lastExportPath
          : lastExportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastGenerationTimeMs: freezed == lastGenerationTimeMs
          ? _value.lastGenerationTimeMs
          : lastGenerationTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      lastExportTimeMs: freezed == lastExportTimeMs
          ? _value.lastExportTimeMs
          : lastExportTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FakerStateImplCopyWith<$Res>
    implements $FakerStateCopyWith<$Res> {
  factory _$$FakerStateImplCopyWith(
          _$FakerStateImpl value, $Res Function(_$FakerStateImpl) then) =
      __$$FakerStateImplCopyWithImpl<$Res>;
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
class __$$FakerStateImplCopyWithImpl<$Res>
    extends _$FakerStateCopyWithImpl<$Res, _$FakerStateImpl>
    implements _$$FakerStateImplCopyWith<$Res> {
  __$$FakerStateImplCopyWithImpl(
      _$FakerStateImpl _value, $Res Function(_$FakerStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$FakerStateImpl(
      selectedTemplate: null == selectedTemplate
          ? _value.selectedTemplate
          : selectedTemplate // ignore: cast_nullable_to_non_nullable
              as TemplateType,
      bulkSize: null == bulkSize
          ? _value.bulkSize
          : bulkSize // ignore: cast_nullable_to_non_nullable
              as BulkSize,
      useRandomSeed: null == useRandomSeed
          ? _value.useRandomSeed
          : useRandomSeed // ignore: cast_nullable_to_non_nullable
              as bool,
      customSeed: freezed == customSeed
          ? _value.customSeed
          : customSeed // ignore: cast_nullable_to_non_nullable
              as int?,
      preferredState: freezed == preferredState
          ? _value.preferredState
          : preferredState // ignore: cast_nullable_to_non_nullable
              as String?,
      includeAllIdentifiers: null == includeAllIdentifiers
          ? _value.includeAllIdentifiers
          : includeAllIdentifiers // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedIdentifiers: null == selectedIdentifiers
          ? _value._selectedIdentifiers
          : selectedIdentifiers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      generatedRecords: null == generatedRecords
          ? _value._generatedRecords
          : generatedRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      lastGeneratedAt: freezed == lastGeneratedAt
          ? _value.lastGeneratedAt
          : lastGeneratedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedExportFormat: null == selectedExportFormat
          ? _value.selectedExportFormat
          : selectedExportFormat // ignore: cast_nullable_to_non_nullable
              as ExportFormat,
      includeMetadata: null == includeMetadata
          ? _value.includeMetadata
          : includeMetadata // ignore: cast_nullable_to_non_nullable
              as bool,
      prettifyOutput: null == prettifyOutput
          ? _value.prettifyOutput
          : prettifyOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      isGenerating: null == isGenerating
          ? _value.isGenerating
          : isGenerating // ignore: cast_nullable_to_non_nullable
              as bool,
      isExporting: null == isExporting
          ? _value.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      lastExportPath: freezed == lastExportPath
          ? _value.lastExportPath
          : lastExportPath // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastGenerationTimeMs: freezed == lastGenerationTimeMs
          ? _value.lastGenerationTimeMs
          : lastGenerationTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      lastExportTimeMs: freezed == lastExportTimeMs
          ? _value.lastExportTimeMs
          : lastExportTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$FakerStateImpl implements _FakerState {
  const _$FakerStateImpl(
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

  @override
  String toString() {
    return 'FakerState(selectedTemplate: $selectedTemplate, bulkSize: $bulkSize, useRandomSeed: $useRandomSeed, customSeed: $customSeed, preferredState: $preferredState, includeAllIdentifiers: $includeAllIdentifiers, selectedIdentifiers: $selectedIdentifiers, generatedRecords: $generatedRecords, lastGeneratedAt: $lastGeneratedAt, selectedExportFormat: $selectedExportFormat, includeMetadata: $includeMetadata, prettifyOutput: $prettifyOutput, isGenerating: $isGenerating, isExporting: $isExporting, lastExportPath: $lastExportPath, errorMessage: $errorMessage, lastGenerationTimeMs: $lastGenerationTimeMs, lastExportTimeMs: $lastExportTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FakerStateImpl &&
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

  /// Create a copy of FakerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FakerStateImplCopyWith<_$FakerStateImpl> get copyWith =>
      __$$FakerStateImplCopyWithImpl<_$FakerStateImpl>(this, _$identity);
}

abstract class _FakerState implements FakerState {
  const factory _FakerState(
      {final TemplateType selectedTemplate,
      final BulkSize bulkSize,
      final bool useRandomSeed,
      final int? customSeed,
      final String? preferredState,
      final bool includeAllIdentifiers,
      final Set<String> selectedIdentifiers,
      final List<Map<String, dynamic>> generatedRecords,
      final DateTime? lastGeneratedAt,
      final ExportFormat selectedExportFormat,
      final bool includeMetadata,
      final bool prettifyOutput,
      final bool isGenerating,
      final bool isExporting,
      final String? lastExportPath,
      final String? errorMessage,
      final int? lastGenerationTimeMs,
      final int? lastExportTimeMs}) = _$FakerStateImpl;

// Template selection
  @override
  TemplateType get selectedTemplate; // Generation options
  @override
  BulkSize get bulkSize;
  @override
  bool get useRandomSeed;
  @override
  int? get customSeed;
  @override
  String? get preferredState; // Identifier toggles (for custom selection)
  @override
  bool get includeAllIdentifiers;
  @override
  Set<String> get selectedIdentifiers; // Generated data
  @override
  List<Map<String, dynamic>> get generatedRecords;
  @override
  DateTime? get lastGeneratedAt; // Export options
  @override
  ExportFormat get selectedExportFormat;
  @override
  bool get includeMetadata;
  @override
  bool get prettifyOutput; // UI state
  @override
  bool get isGenerating;
  @override
  bool get isExporting;
  @override
  String? get lastExportPath;
  @override
  String? get errorMessage; // Performance metrics
  @override
  int? get lastGenerationTimeMs;
  @override
  int? get lastExportTimeMs;

  /// Create a copy of FakerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FakerStateImplCopyWith<_$FakerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
