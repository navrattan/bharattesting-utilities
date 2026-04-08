// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'json_converter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JsonConverterState {
  String get inputText;
  String get outputText;
  bool get isProcessing;
  bool get autoRepairEnabled;
  bool get prettifyOutput;
  InputFormat get detectedFormat;
  double get formatConfidence;
  List<RepairRule> get appliedRepairs;
  List<String> get errors;
  List<String> get warnings;
  int? get errorLineNumber;
  int? get errorColumnNumber;
  String? get errorMessage;
  Map<String, dynamic>? get metadata;

  /// Create a copy of JsonConverterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $JsonConverterStateCopyWith<JsonConverterState> get copyWith =>
      _$JsonConverterStateCopyWithImpl<JsonConverterState>(
          this as JsonConverterState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JsonConverterState &&
            (identical(other.inputText, inputText) ||
                other.inputText == inputText) &&
            (identical(other.outputText, outputText) ||
                other.outputText == outputText) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.autoRepairEnabled, autoRepairEnabled) ||
                other.autoRepairEnabled == autoRepairEnabled) &&
            (identical(other.prettifyOutput, prettifyOutput) ||
                other.prettifyOutput == prettifyOutput) &&
            (identical(other.detectedFormat, detectedFormat) ||
                other.detectedFormat == detectedFormat) &&
            (identical(other.formatConfidence, formatConfidence) ||
                other.formatConfidence == formatConfidence) &&
            const DeepCollectionEquality()
                .equals(other.appliedRepairs, appliedRepairs) &&
            const DeepCollectionEquality().equals(other.errors, errors) &&
            const DeepCollectionEquality().equals(other.warnings, warnings) &&
            (identical(other.errorLineNumber, errorLineNumber) ||
                other.errorLineNumber == errorLineNumber) &&
            (identical(other.errorColumnNumber, errorColumnNumber) ||
                other.errorColumnNumber == errorColumnNumber) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other.metadata, metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      inputText,
      outputText,
      isProcessing,
      autoRepairEnabled,
      prettifyOutput,
      detectedFormat,
      formatConfidence,
      const DeepCollectionEquality().hash(appliedRepairs),
      const DeepCollectionEquality().hash(errors),
      const DeepCollectionEquality().hash(warnings),
      errorLineNumber,
      errorColumnNumber,
      errorMessage,
      const DeepCollectionEquality().hash(metadata));

  @override
  String toString() {
    return 'JsonConverterState(inputText: $inputText, outputText: $outputText, isProcessing: $isProcessing, autoRepairEnabled: $autoRepairEnabled, prettifyOutput: $prettifyOutput, detectedFormat: $detectedFormat, formatConfidence: $formatConfidence, appliedRepairs: $appliedRepairs, errors: $errors, warnings: $warnings, errorLineNumber: $errorLineNumber, errorColumnNumber: $errorColumnNumber, errorMessage: $errorMessage, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $JsonConverterStateCopyWith<$Res> {
  factory $JsonConverterStateCopyWith(
          JsonConverterState value, $Res Function(JsonConverterState) _then) =
      _$JsonConverterStateCopyWithImpl;
  @useResult
  $Res call(
      {String inputText,
      String outputText,
      bool isProcessing,
      bool autoRepairEnabled,
      bool prettifyOutput,
      InputFormat detectedFormat,
      double formatConfidence,
      List<RepairRule> appliedRepairs,
      List<String> errors,
      List<String> warnings,
      int? errorLineNumber,
      int? errorColumnNumber,
      String? errorMessage,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$JsonConverterStateCopyWithImpl<$Res>
    implements $JsonConverterStateCopyWith<$Res> {
  _$JsonConverterStateCopyWithImpl(this._self, this._then);

  final JsonConverterState _self;
  final $Res Function(JsonConverterState) _then;

  /// Create a copy of JsonConverterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inputText = null,
    Object? outputText = null,
    Object? isProcessing = null,
    Object? autoRepairEnabled = null,
    Object? prettifyOutput = null,
    Object? detectedFormat = null,
    Object? formatConfidence = null,
    Object? appliedRepairs = null,
    Object? errors = null,
    Object? warnings = null,
    Object? errorLineNumber = freezed,
    Object? errorColumnNumber = freezed,
    Object? errorMessage = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_self.copyWith(
      inputText: null == inputText
          ? _self.inputText
          : inputText // ignore: cast_nullable_to_non_nullable
              as String,
      outputText: null == outputText
          ? _self.outputText
          : outputText // ignore: cast_nullable_to_non_nullable
              as String,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      autoRepairEnabled: null == autoRepairEnabled
          ? _self.autoRepairEnabled
          : autoRepairEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      prettifyOutput: null == prettifyOutput
          ? _self.prettifyOutput
          : prettifyOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedFormat: null == detectedFormat
          ? _self.detectedFormat
          : detectedFormat // ignore: cast_nullable_to_non_nullable
              as InputFormat,
      formatConfidence: null == formatConfidence
          ? _self.formatConfidence
          : formatConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      appliedRepairs: null == appliedRepairs
          ? _self.appliedRepairs
          : appliedRepairs // ignore: cast_nullable_to_non_nullable
              as List<RepairRule>,
      errors: null == errors
          ? _self.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _self.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorLineNumber: freezed == errorLineNumber
          ? _self.errorLineNumber
          : errorLineNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      errorColumnNumber: freezed == errorColumnNumber
          ? _self.errorColumnNumber
          : errorColumnNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [JsonConverterState].
extension JsonConverterStatePatterns on JsonConverterState {
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
    TResult Function(_JsonConverterState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JsonConverterState() when $default != null:
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
    TResult Function(_JsonConverterState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JsonConverterState():
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
    TResult? Function(_JsonConverterState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JsonConverterState() when $default != null:
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
            String inputText,
            String outputText,
            bool isProcessing,
            bool autoRepairEnabled,
            bool prettifyOutput,
            InputFormat detectedFormat,
            double formatConfidence,
            List<RepairRule> appliedRepairs,
            List<String> errors,
            List<String> warnings,
            int? errorLineNumber,
            int? errorColumnNumber,
            String? errorMessage,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _JsonConverterState() when $default != null:
        return $default(
            _that.inputText,
            _that.outputText,
            _that.isProcessing,
            _that.autoRepairEnabled,
            _that.prettifyOutput,
            _that.detectedFormat,
            _that.formatConfidence,
            _that.appliedRepairs,
            _that.errors,
            _that.warnings,
            _that.errorLineNumber,
            _that.errorColumnNumber,
            _that.errorMessage,
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
            String inputText,
            String outputText,
            bool isProcessing,
            bool autoRepairEnabled,
            bool prettifyOutput,
            InputFormat detectedFormat,
            double formatConfidence,
            List<RepairRule> appliedRepairs,
            List<String> errors,
            List<String> warnings,
            int? errorLineNumber,
            int? errorColumnNumber,
            String? errorMessage,
            Map<String, dynamic>? metadata)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JsonConverterState():
        return $default(
            _that.inputText,
            _that.outputText,
            _that.isProcessing,
            _that.autoRepairEnabled,
            _that.prettifyOutput,
            _that.detectedFormat,
            _that.formatConfidence,
            _that.appliedRepairs,
            _that.errors,
            _that.warnings,
            _that.errorLineNumber,
            _that.errorColumnNumber,
            _that.errorMessage,
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
            String inputText,
            String outputText,
            bool isProcessing,
            bool autoRepairEnabled,
            bool prettifyOutput,
            InputFormat detectedFormat,
            double formatConfidence,
            List<RepairRule> appliedRepairs,
            List<String> errors,
            List<String> warnings,
            int? errorLineNumber,
            int? errorColumnNumber,
            String? errorMessage,
            Map<String, dynamic>? metadata)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _JsonConverterState() when $default != null:
        return $default(
            _that.inputText,
            _that.outputText,
            _that.isProcessing,
            _that.autoRepairEnabled,
            _that.prettifyOutput,
            _that.detectedFormat,
            _that.formatConfidence,
            _that.appliedRepairs,
            _that.errors,
            _that.warnings,
            _that.errorLineNumber,
            _that.errorColumnNumber,
            _that.errorMessage,
            _that.metadata);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _JsonConverterState extends JsonConverterState {
  const _JsonConverterState(
      {this.inputText = '',
      this.outputText = '',
      this.isProcessing = false,
      this.autoRepairEnabled = false,
      this.prettifyOutput = false,
      this.detectedFormat = InputFormat.unknown,
      this.formatConfidence = 0.0,
      final List<RepairRule> appliedRepairs = const <RepairRule>[],
      final List<String> errors = const <String>[],
      final List<String> warnings = const <String>[],
      this.errorLineNumber,
      this.errorColumnNumber,
      this.errorMessage,
      final Map<String, dynamic>? metadata})
      : _appliedRepairs = appliedRepairs,
        _errors = errors,
        _warnings = warnings,
        _metadata = metadata,
        super._();

  @override
  @JsonKey()
  final String inputText;
  @override
  @JsonKey()
  final String outputText;
  @override
  @JsonKey()
  final bool isProcessing;
  @override
  @JsonKey()
  final bool autoRepairEnabled;
  @override
  @JsonKey()
  final bool prettifyOutput;
  @override
  @JsonKey()
  final InputFormat detectedFormat;
  @override
  @JsonKey()
  final double formatConfidence;
  final List<RepairRule> _appliedRepairs;
  @override
  @JsonKey()
  List<RepairRule> get appliedRepairs {
    if (_appliedRepairs is EqualUnmodifiableListView) return _appliedRepairs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliedRepairs);
  }

  final List<String> _errors;
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  final List<String> _warnings;
  @override
  @JsonKey()
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  final int? errorLineNumber;
  @override
  final int? errorColumnNumber;
  @override
  final String? errorMessage;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of JsonConverterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$JsonConverterStateCopyWith<_JsonConverterState> get copyWith =>
      __$JsonConverterStateCopyWithImpl<_JsonConverterState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _JsonConverterState &&
            (identical(other.inputText, inputText) ||
                other.inputText == inputText) &&
            (identical(other.outputText, outputText) ||
                other.outputText == outputText) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.autoRepairEnabled, autoRepairEnabled) ||
                other.autoRepairEnabled == autoRepairEnabled) &&
            (identical(other.prettifyOutput, prettifyOutput) ||
                other.prettifyOutput == prettifyOutput) &&
            (identical(other.detectedFormat, detectedFormat) ||
                other.detectedFormat == detectedFormat) &&
            (identical(other.formatConfidence, formatConfidence) ||
                other.formatConfidence == formatConfidence) &&
            const DeepCollectionEquality()
                .equals(other._appliedRepairs, _appliedRepairs) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(other.errorLineNumber, errorLineNumber) ||
                other.errorLineNumber == errorLineNumber) &&
            (identical(other.errorColumnNumber, errorColumnNumber) ||
                other.errorColumnNumber == errorColumnNumber) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      inputText,
      outputText,
      isProcessing,
      autoRepairEnabled,
      prettifyOutput,
      detectedFormat,
      formatConfidence,
      const DeepCollectionEquality().hash(_appliedRepairs),
      const DeepCollectionEquality().hash(_errors),
      const DeepCollectionEquality().hash(_warnings),
      errorLineNumber,
      errorColumnNumber,
      errorMessage,
      const DeepCollectionEquality().hash(_metadata));

  @override
  String toString() {
    return 'JsonConverterState(inputText: $inputText, outputText: $outputText, isProcessing: $isProcessing, autoRepairEnabled: $autoRepairEnabled, prettifyOutput: $prettifyOutput, detectedFormat: $detectedFormat, formatConfidence: $formatConfidence, appliedRepairs: $appliedRepairs, errors: $errors, warnings: $warnings, errorLineNumber: $errorLineNumber, errorColumnNumber: $errorColumnNumber, errorMessage: $errorMessage, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$JsonConverterStateCopyWith<$Res>
    implements $JsonConverterStateCopyWith<$Res> {
  factory _$JsonConverterStateCopyWith(
          _JsonConverterState value, $Res Function(_JsonConverterState) _then) =
      __$JsonConverterStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String inputText,
      String outputText,
      bool isProcessing,
      bool autoRepairEnabled,
      bool prettifyOutput,
      InputFormat detectedFormat,
      double formatConfidence,
      List<RepairRule> appliedRepairs,
      List<String> errors,
      List<String> warnings,
      int? errorLineNumber,
      int? errorColumnNumber,
      String? errorMessage,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$JsonConverterStateCopyWithImpl<$Res>
    implements _$JsonConverterStateCopyWith<$Res> {
  __$JsonConverterStateCopyWithImpl(this._self, this._then);

  final _JsonConverterState _self;
  final $Res Function(_JsonConverterState) _then;

  /// Create a copy of JsonConverterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? inputText = null,
    Object? outputText = null,
    Object? isProcessing = null,
    Object? autoRepairEnabled = null,
    Object? prettifyOutput = null,
    Object? detectedFormat = null,
    Object? formatConfidence = null,
    Object? appliedRepairs = null,
    Object? errors = null,
    Object? warnings = null,
    Object? errorLineNumber = freezed,
    Object? errorColumnNumber = freezed,
    Object? errorMessage = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_JsonConverterState(
      inputText: null == inputText
          ? _self.inputText
          : inputText // ignore: cast_nullable_to_non_nullable
              as String,
      outputText: null == outputText
          ? _self.outputText
          : outputText // ignore: cast_nullable_to_non_nullable
              as String,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      autoRepairEnabled: null == autoRepairEnabled
          ? _self.autoRepairEnabled
          : autoRepairEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      prettifyOutput: null == prettifyOutput
          ? _self.prettifyOutput
          : prettifyOutput // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedFormat: null == detectedFormat
          ? _self.detectedFormat
          : detectedFormat // ignore: cast_nullable_to_non_nullable
              as InputFormat,
      formatConfidence: null == formatConfidence
          ? _self.formatConfidence
          : formatConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      appliedRepairs: null == appliedRepairs
          ? _self._appliedRepairs
          : appliedRepairs // ignore: cast_nullable_to_non_nullable
              as List<RepairRule>,
      errors: null == errors
          ? _self._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _self._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorLineNumber: freezed == errorLineNumber
          ? _self.errorLineNumber
          : errorLineNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      errorColumnNumber: freezed == errorColumnNumber
          ? _self.errorColumnNumber
          : errorColumnNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
