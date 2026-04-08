// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pdf_merger_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PdfMergerState {
  List<PdfDocument> get documents;
  List<PdfPageThumbnail> get pages;
  bool get isProcessing;
  int get processingProgress;
  List<String> get processingErrors;
  PdfDocument? get selectedDocument;
  PdfPageThumbnail? get selectedPage;
  bool get showPasswordDialog;
  bool get showAdvancedSettings;
  bool get enableEncryption;
  String get encryptionPassword;
  PdfPermissions get permissions;
  PdfMergeOptions get mergeOptions;
  Uint8List? get mergedPdfData;
  String get outputFileName;

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PdfMergerStateCopyWith<PdfMergerState> get copyWith =>
      _$PdfMergerStateCopyWithImpl<PdfMergerState>(
          this as PdfMergerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PdfMergerState &&
            const DeepCollectionEquality().equals(other.documents, documents) &&
            const DeepCollectionEquality().equals(other.pages, pages) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.processingProgress, processingProgress) ||
                other.processingProgress == processingProgress) &&
            const DeepCollectionEquality()
                .equals(other.processingErrors, processingErrors) &&
            (identical(other.selectedDocument, selectedDocument) ||
                other.selectedDocument == selectedDocument) &&
            (identical(other.selectedPage, selectedPage) ||
                other.selectedPage == selectedPage) &&
            (identical(other.showPasswordDialog, showPasswordDialog) ||
                other.showPasswordDialog == showPasswordDialog) &&
            (identical(other.showAdvancedSettings, showAdvancedSettings) ||
                other.showAdvancedSettings == showAdvancedSettings) &&
            (identical(other.enableEncryption, enableEncryption) ||
                other.enableEncryption == enableEncryption) &&
            (identical(other.encryptionPassword, encryptionPassword) ||
                other.encryptionPassword == encryptionPassword) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            (identical(other.mergeOptions, mergeOptions) ||
                other.mergeOptions == mergeOptions) &&
            const DeepCollectionEquality()
                .equals(other.mergedPdfData, mergedPdfData) &&
            (identical(other.outputFileName, outputFileName) ||
                other.outputFileName == outputFileName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(documents),
      const DeepCollectionEquality().hash(pages),
      isProcessing,
      processingProgress,
      const DeepCollectionEquality().hash(processingErrors),
      selectedDocument,
      selectedPage,
      showPasswordDialog,
      showAdvancedSettings,
      enableEncryption,
      encryptionPassword,
      permissions,
      mergeOptions,
      const DeepCollectionEquality().hash(mergedPdfData),
      outputFileName);

  @override
  String toString() {
    return 'PdfMergerState(documents: $documents, pages: $pages, isProcessing: $isProcessing, processingProgress: $processingProgress, processingErrors: $processingErrors, selectedDocument: $selectedDocument, selectedPage: $selectedPage, showPasswordDialog: $showPasswordDialog, showAdvancedSettings: $showAdvancedSettings, enableEncryption: $enableEncryption, encryptionPassword: $encryptionPassword, permissions: $permissions, mergeOptions: $mergeOptions, mergedPdfData: $mergedPdfData, outputFileName: $outputFileName)';
  }
}

/// @nodoc
abstract mixin class $PdfMergerStateCopyWith<$Res> {
  factory $PdfMergerStateCopyWith(
          PdfMergerState value, $Res Function(PdfMergerState) _then) =
      _$PdfMergerStateCopyWithImpl;
  @useResult
  $Res call(
      {List<PdfDocument> documents,
      List<PdfPageThumbnail> pages,
      bool isProcessing,
      int processingProgress,
      List<String> processingErrors,
      PdfDocument? selectedDocument,
      PdfPageThumbnail? selectedPage,
      bool showPasswordDialog,
      bool showAdvancedSettings,
      bool enableEncryption,
      String encryptionPassword,
      PdfPermissions permissions,
      PdfMergeOptions mergeOptions,
      Uint8List? mergedPdfData,
      String outputFileName});

  $PdfDocumentCopyWith<$Res>? get selectedDocument;
  $PdfPageThumbnailCopyWith<$Res>? get selectedPage;
}

/// @nodoc
class _$PdfMergerStateCopyWithImpl<$Res>
    implements $PdfMergerStateCopyWith<$Res> {
  _$PdfMergerStateCopyWithImpl(this._self, this._then);

  final PdfMergerState _self;
  final $Res Function(PdfMergerState) _then;

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documents = null,
    Object? pages = null,
    Object? isProcessing = null,
    Object? processingProgress = null,
    Object? processingErrors = null,
    Object? selectedDocument = freezed,
    Object? selectedPage = freezed,
    Object? showPasswordDialog = null,
    Object? showAdvancedSettings = null,
    Object? enableEncryption = null,
    Object? encryptionPassword = null,
    Object? permissions = null,
    Object? mergeOptions = null,
    Object? mergedPdfData = freezed,
    Object? outputFileName = null,
  }) {
    return _then(_self.copyWith(
      documents: null == documents
          ? _self.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<PdfDocument>,
      pages: null == pages
          ? _self.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PdfPageThumbnail>,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _self.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _self.processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedDocument: freezed == selectedDocument
          ? _self.selectedDocument
          : selectedDocument // ignore: cast_nullable_to_non_nullable
              as PdfDocument?,
      selectedPage: freezed == selectedPage
          ? _self.selectedPage
          : selectedPage // ignore: cast_nullable_to_non_nullable
              as PdfPageThumbnail?,
      showPasswordDialog: null == showPasswordDialog
          ? _self.showPasswordDialog
          : showPasswordDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      showAdvancedSettings: null == showAdvancedSettings
          ? _self.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      enableEncryption: null == enableEncryption
          ? _self.enableEncryption
          : enableEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptionPassword: null == encryptionPassword
          ? _self.encryptionPassword
          : encryptionPassword // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as PdfPermissions,
      mergeOptions: null == mergeOptions
          ? _self.mergeOptions
          : mergeOptions // ignore: cast_nullable_to_non_nullable
              as PdfMergeOptions,
      mergedPdfData: freezed == mergedPdfData
          ? _self.mergedPdfData
          : mergedPdfData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      outputFileName: null == outputFileName
          ? _self.outputFileName
          : outputFileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PdfDocumentCopyWith<$Res>? get selectedDocument {
    if (_self.selectedDocument == null) {
      return null;
    }

    return $PdfDocumentCopyWith<$Res>(_self.selectedDocument!, (value) {
      return _then(_self.copyWith(selectedDocument: value));
    });
  }

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PdfPageThumbnailCopyWith<$Res>? get selectedPage {
    if (_self.selectedPage == null) {
      return null;
    }

    return $PdfPageThumbnailCopyWith<$Res>(_self.selectedPage!, (value) {
      return _then(_self.copyWith(selectedPage: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PdfMergerState].
extension PdfMergerStatePatterns on PdfMergerState {
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
    TResult Function(_PdfMergerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfMergerState() when $default != null:
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
    TResult Function(_PdfMergerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerState():
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
    TResult? Function(_PdfMergerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerState() when $default != null:
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
            List<PdfDocument> documents,
            List<PdfPageThumbnail> pages,
            bool isProcessing,
            int processingProgress,
            List<String> processingErrors,
            PdfDocument? selectedDocument,
            PdfPageThumbnail? selectedPage,
            bool showPasswordDialog,
            bool showAdvancedSettings,
            bool enableEncryption,
            String encryptionPassword,
            PdfPermissions permissions,
            PdfMergeOptions mergeOptions,
            Uint8List? mergedPdfData,
            String outputFileName)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfMergerState() when $default != null:
        return $default(
            _that.documents,
            _that.pages,
            _that.isProcessing,
            _that.processingProgress,
            _that.processingErrors,
            _that.selectedDocument,
            _that.selectedPage,
            _that.showPasswordDialog,
            _that.showAdvancedSettings,
            _that.enableEncryption,
            _that.encryptionPassword,
            _that.permissions,
            _that.mergeOptions,
            _that.mergedPdfData,
            _that.outputFileName);
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
            List<PdfDocument> documents,
            List<PdfPageThumbnail> pages,
            bool isProcessing,
            int processingProgress,
            List<String> processingErrors,
            PdfDocument? selectedDocument,
            PdfPageThumbnail? selectedPage,
            bool showPasswordDialog,
            bool showAdvancedSettings,
            bool enableEncryption,
            String encryptionPassword,
            PdfPermissions permissions,
            PdfMergeOptions mergeOptions,
            Uint8List? mergedPdfData,
            String outputFileName)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerState():
        return $default(
            _that.documents,
            _that.pages,
            _that.isProcessing,
            _that.processingProgress,
            _that.processingErrors,
            _that.selectedDocument,
            _that.selectedPage,
            _that.showPasswordDialog,
            _that.showAdvancedSettings,
            _that.enableEncryption,
            _that.encryptionPassword,
            _that.permissions,
            _that.mergeOptions,
            _that.mergedPdfData,
            _that.outputFileName);
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
            List<PdfDocument> documents,
            List<PdfPageThumbnail> pages,
            bool isProcessing,
            int processingProgress,
            List<String> processingErrors,
            PdfDocument? selectedDocument,
            PdfPageThumbnail? selectedPage,
            bool showPasswordDialog,
            bool showAdvancedSettings,
            bool enableEncryption,
            String encryptionPassword,
            PdfPermissions permissions,
            PdfMergeOptions mergeOptions,
            Uint8List? mergedPdfData,
            String outputFileName)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerState() when $default != null:
        return $default(
            _that.documents,
            _that.pages,
            _that.isProcessing,
            _that.processingProgress,
            _that.processingErrors,
            _that.selectedDocument,
            _that.selectedPage,
            _that.showPasswordDialog,
            _that.showAdvancedSettings,
            _that.enableEncryption,
            _that.encryptionPassword,
            _that.permissions,
            _that.mergeOptions,
            _that.mergedPdfData,
            _that.outputFileName);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PdfMergerState implements PdfMergerState {
  const _PdfMergerState(
      {final List<PdfDocument> documents = const [],
      final List<PdfPageThumbnail> pages = const [],
      this.isProcessing = false,
      this.processingProgress = 0,
      final List<String> processingErrors = const [],
      this.selectedDocument,
      this.selectedPage,
      this.showPasswordDialog = false,
      this.showAdvancedSettings = false,
      this.enableEncryption = false,
      this.encryptionPassword = '',
      this.permissions = const PdfPermissions(),
      this.mergeOptions = const PdfMergeOptions(),
      this.mergedPdfData,
      this.outputFileName = 'merged_document.pdf'})
      : _documents = documents,
        _pages = pages,
        _processingErrors = processingErrors;

  final List<PdfDocument> _documents;
  @override
  @JsonKey()
  List<PdfDocument> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  final List<PdfPageThumbnail> _pages;
  @override
  @JsonKey()
  List<PdfPageThumbnail> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  @override
  @JsonKey()
  final bool isProcessing;
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
  final PdfDocument? selectedDocument;
  @override
  final PdfPageThumbnail? selectedPage;
  @override
  @JsonKey()
  final bool showPasswordDialog;
  @override
  @JsonKey()
  final bool showAdvancedSettings;
  @override
  @JsonKey()
  final bool enableEncryption;
  @override
  @JsonKey()
  final String encryptionPassword;
  @override
  @JsonKey()
  final PdfPermissions permissions;
  @override
  @JsonKey()
  final PdfMergeOptions mergeOptions;
  @override
  final Uint8List? mergedPdfData;
  @override
  @JsonKey()
  final String outputFileName;

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PdfMergerStateCopyWith<_PdfMergerState> get copyWith =>
      __$PdfMergerStateCopyWithImpl<_PdfMergerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PdfMergerState &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.processingProgress, processingProgress) ||
                other.processingProgress == processingProgress) &&
            const DeepCollectionEquality()
                .equals(other._processingErrors, _processingErrors) &&
            (identical(other.selectedDocument, selectedDocument) ||
                other.selectedDocument == selectedDocument) &&
            (identical(other.selectedPage, selectedPage) ||
                other.selectedPage == selectedPage) &&
            (identical(other.showPasswordDialog, showPasswordDialog) ||
                other.showPasswordDialog == showPasswordDialog) &&
            (identical(other.showAdvancedSettings, showAdvancedSettings) ||
                other.showAdvancedSettings == showAdvancedSettings) &&
            (identical(other.enableEncryption, enableEncryption) ||
                other.enableEncryption == enableEncryption) &&
            (identical(other.encryptionPassword, encryptionPassword) ||
                other.encryptionPassword == encryptionPassword) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            (identical(other.mergeOptions, mergeOptions) ||
                other.mergeOptions == mergeOptions) &&
            const DeepCollectionEquality()
                .equals(other.mergedPdfData, mergedPdfData) &&
            (identical(other.outputFileName, outputFileName) ||
                other.outputFileName == outputFileName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_documents),
      const DeepCollectionEquality().hash(_pages),
      isProcessing,
      processingProgress,
      const DeepCollectionEquality().hash(_processingErrors),
      selectedDocument,
      selectedPage,
      showPasswordDialog,
      showAdvancedSettings,
      enableEncryption,
      encryptionPassword,
      permissions,
      mergeOptions,
      const DeepCollectionEquality().hash(mergedPdfData),
      outputFileName);

  @override
  String toString() {
    return 'PdfMergerState(documents: $documents, pages: $pages, isProcessing: $isProcessing, processingProgress: $processingProgress, processingErrors: $processingErrors, selectedDocument: $selectedDocument, selectedPage: $selectedPage, showPasswordDialog: $showPasswordDialog, showAdvancedSettings: $showAdvancedSettings, enableEncryption: $enableEncryption, encryptionPassword: $encryptionPassword, permissions: $permissions, mergeOptions: $mergeOptions, mergedPdfData: $mergedPdfData, outputFileName: $outputFileName)';
  }
}

/// @nodoc
abstract mixin class _$PdfMergerStateCopyWith<$Res>
    implements $PdfMergerStateCopyWith<$Res> {
  factory _$PdfMergerStateCopyWith(
          _PdfMergerState value, $Res Function(_PdfMergerState) _then) =
      __$PdfMergerStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<PdfDocument> documents,
      List<PdfPageThumbnail> pages,
      bool isProcessing,
      int processingProgress,
      List<String> processingErrors,
      PdfDocument? selectedDocument,
      PdfPageThumbnail? selectedPage,
      bool showPasswordDialog,
      bool showAdvancedSettings,
      bool enableEncryption,
      String encryptionPassword,
      PdfPermissions permissions,
      PdfMergeOptions mergeOptions,
      Uint8List? mergedPdfData,
      String outputFileName});

  @override
  $PdfDocumentCopyWith<$Res>? get selectedDocument;
  @override
  $PdfPageThumbnailCopyWith<$Res>? get selectedPage;
}

/// @nodoc
class __$PdfMergerStateCopyWithImpl<$Res>
    implements _$PdfMergerStateCopyWith<$Res> {
  __$PdfMergerStateCopyWithImpl(this._self, this._then);

  final _PdfMergerState _self;
  final $Res Function(_PdfMergerState) _then;

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? documents = null,
    Object? pages = null,
    Object? isProcessing = null,
    Object? processingProgress = null,
    Object? processingErrors = null,
    Object? selectedDocument = freezed,
    Object? selectedPage = freezed,
    Object? showPasswordDialog = null,
    Object? showAdvancedSettings = null,
    Object? enableEncryption = null,
    Object? encryptionPassword = null,
    Object? permissions = null,
    Object? mergeOptions = null,
    Object? mergedPdfData = freezed,
    Object? outputFileName = null,
  }) {
    return _then(_PdfMergerState(
      documents: null == documents
          ? _self._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<PdfDocument>,
      pages: null == pages
          ? _self._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PdfPageThumbnail>,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _self.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _self._processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedDocument: freezed == selectedDocument
          ? _self.selectedDocument
          : selectedDocument // ignore: cast_nullable_to_non_nullable
              as PdfDocument?,
      selectedPage: freezed == selectedPage
          ? _self.selectedPage
          : selectedPage // ignore: cast_nullable_to_non_nullable
              as PdfPageThumbnail?,
      showPasswordDialog: null == showPasswordDialog
          ? _self.showPasswordDialog
          : showPasswordDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      showAdvancedSettings: null == showAdvancedSettings
          ? _self.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      enableEncryption: null == enableEncryption
          ? _self.enableEncryption
          : enableEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptionPassword: null == encryptionPassword
          ? _self.encryptionPassword
          : encryptionPassword // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as PdfPermissions,
      mergeOptions: null == mergeOptions
          ? _self.mergeOptions
          : mergeOptions // ignore: cast_nullable_to_non_nullable
              as PdfMergeOptions,
      mergedPdfData: freezed == mergedPdfData
          ? _self.mergedPdfData
          : mergedPdfData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      outputFileName: null == outputFileName
          ? _self.outputFileName
          : outputFileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PdfDocumentCopyWith<$Res>? get selectedDocument {
    if (_self.selectedDocument == null) {
      return null;
    }

    return $PdfDocumentCopyWith<$Res>(_self.selectedDocument!, (value) {
      return _then(_self.copyWith(selectedDocument: value));
    });
  }

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PdfPageThumbnailCopyWith<$Res>? get selectedPage {
    if (_self.selectedPage == null) {
      return null;
    }

    return $PdfPageThumbnailCopyWith<$Res>(_self.selectedPage!, (value) {
      return _then(_self.copyWith(selectedPage: value));
    });
  }
}

/// @nodoc
mixin _$PdfDocument {
  String get id;
  String get fileName;
  Uint8List get data;
  int get fileSize;
  int get pageCount;
  DocumentStatus get status;
  String? get error;

  /// Create a copy of PdfDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PdfDocumentCopyWith<PdfDocument> get copyWith =>
      _$PdfDocumentCopyWithImpl<PdfDocument>(this as PdfDocument, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PdfDocument &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fileName,
      const DeepCollectionEquality().hash(data),
      fileSize,
      pageCount,
      status,
      error);

  @override
  String toString() {
    return 'PdfDocument(id: $id, fileName: $fileName, data: $data, fileSize: $fileSize, pageCount: $pageCount, status: $status, error: $error)';
  }
}

/// @nodoc
abstract mixin class $PdfDocumentCopyWith<$Res> {
  factory $PdfDocumentCopyWith(
          PdfDocument value, $Res Function(PdfDocument) _then) =
      _$PdfDocumentCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String fileName,
      Uint8List data,
      int fileSize,
      int pageCount,
      DocumentStatus status,
      String? error});
}

/// @nodoc
class _$PdfDocumentCopyWithImpl<$Res> implements $PdfDocumentCopyWith<$Res> {
  _$PdfDocumentCopyWithImpl(this._self, this._then);

  final PdfDocument _self;
  final $Res Function(PdfDocument) _then;

  /// Create a copy of PdfDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? data = null,
    Object? fileSize = null,
    Object? pageCount = null,
    Object? status = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      fileSize: null == fileSize
          ? _self.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      pageCount: null == pageCount
          ? _self.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DocumentStatus,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PdfDocument].
extension PdfDocumentPatterns on PdfDocument {
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
    TResult Function(_PdfDocument value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfDocument() when $default != null:
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
    TResult Function(_PdfDocument value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfDocument():
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
    TResult? Function(_PdfDocument value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfDocument() when $default != null:
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
    TResult Function(String id, String fileName, Uint8List data, int fileSize,
            int pageCount, DocumentStatus status, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfDocument() when $default != null:
        return $default(_that.id, _that.fileName, _that.data, _that.fileSize,
            _that.pageCount, _that.status, _that.error);
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
    TResult Function(String id, String fileName, Uint8List data, int fileSize,
            int pageCount, DocumentStatus status, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfDocument():
        return $default(_that.id, _that.fileName, _that.data, _that.fileSize,
            _that.pageCount, _that.status, _that.error);
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
    TResult? Function(String id, String fileName, Uint8List data, int fileSize,
            int pageCount, DocumentStatus status, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfDocument() when $default != null:
        return $default(_that.id, _that.fileName, _that.data, _that.fileSize,
            _that.pageCount, _that.status, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PdfDocument extends PdfDocument {
  const _PdfDocument(
      {required this.id,
      required this.fileName,
      required this.data,
      required this.fileSize,
      required this.pageCount,
      this.status = DocumentStatus.ready,
      this.error})
      : super._();

  @override
  final String id;
  @override
  final String fileName;
  @override
  final Uint8List data;
  @override
  final int fileSize;
  @override
  final int pageCount;
  @override
  @JsonKey()
  final DocumentStatus status;
  @override
  final String? error;

  /// Create a copy of PdfDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PdfDocumentCopyWith<_PdfDocument> get copyWith =>
      __$PdfDocumentCopyWithImpl<_PdfDocument>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PdfDocument &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fileName,
      const DeepCollectionEquality().hash(data),
      fileSize,
      pageCount,
      status,
      error);

  @override
  String toString() {
    return 'PdfDocument(id: $id, fileName: $fileName, data: $data, fileSize: $fileSize, pageCount: $pageCount, status: $status, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$PdfDocumentCopyWith<$Res>
    implements $PdfDocumentCopyWith<$Res> {
  factory _$PdfDocumentCopyWith(
          _PdfDocument value, $Res Function(_PdfDocument) _then) =
      __$PdfDocumentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String fileName,
      Uint8List data,
      int fileSize,
      int pageCount,
      DocumentStatus status,
      String? error});
}

/// @nodoc
class __$PdfDocumentCopyWithImpl<$Res> implements _$PdfDocumentCopyWith<$Res> {
  __$PdfDocumentCopyWithImpl(this._self, this._then);

  final _PdfDocument _self;
  final $Res Function(_PdfDocument) _then;

  /// Create a copy of PdfDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? data = null,
    Object? fileSize = null,
    Object? pageCount = null,
    Object? status = null,
    Object? error = freezed,
  }) {
    return _then(_PdfDocument(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      fileSize: null == fileSize
          ? _self.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      pageCount: null == pageCount
          ? _self.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DocumentStatus,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$PdfPageThumbnail {
  String get id;
  String get documentId;
  int get pageNumber;
  int get globalIndex;
  PageDimensions get dimensions;
  PageRotation get rotation;
  Uint8List? get thumbnailData;
  bool get isSelected;
  bool get isDuplicate;
  bool get isBlank;
  ThumbnailStatus get status;

  /// Create a copy of PdfPageThumbnail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PdfPageThumbnailCopyWith<PdfPageThumbnail> get copyWith =>
      _$PdfPageThumbnailCopyWithImpl<PdfPageThumbnail>(
          this as PdfPageThumbnail, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PdfPageThumbnail &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.globalIndex, globalIndex) ||
                other.globalIndex == globalIndex) &&
            (identical(other.dimensions, dimensions) ||
                other.dimensions == dimensions) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            const DeepCollectionEquality()
                .equals(other.thumbnailData, thumbnailData) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isDuplicate, isDuplicate) ||
                other.isDuplicate == isDuplicate) &&
            (identical(other.isBlank, isBlank) || other.isBlank == isBlank) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      documentId,
      pageNumber,
      globalIndex,
      dimensions,
      rotation,
      const DeepCollectionEquality().hash(thumbnailData),
      isSelected,
      isDuplicate,
      isBlank,
      status);

  @override
  String toString() {
    return 'PdfPageThumbnail(id: $id, documentId: $documentId, pageNumber: $pageNumber, globalIndex: $globalIndex, dimensions: $dimensions, rotation: $rotation, thumbnailData: $thumbnailData, isSelected: $isSelected, isDuplicate: $isDuplicate, isBlank: $isBlank, status: $status)';
  }
}

/// @nodoc
abstract mixin class $PdfPageThumbnailCopyWith<$Res> {
  factory $PdfPageThumbnailCopyWith(
          PdfPageThumbnail value, $Res Function(PdfPageThumbnail) _then) =
      _$PdfPageThumbnailCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String documentId,
      int pageNumber,
      int globalIndex,
      PageDimensions dimensions,
      PageRotation rotation,
      Uint8List? thumbnailData,
      bool isSelected,
      bool isDuplicate,
      bool isBlank,
      ThumbnailStatus status});
}

/// @nodoc
class _$PdfPageThumbnailCopyWithImpl<$Res>
    implements $PdfPageThumbnailCopyWith<$Res> {
  _$PdfPageThumbnailCopyWithImpl(this._self, this._then);

  final PdfPageThumbnail _self;
  final $Res Function(PdfPageThumbnail) _then;

  /// Create a copy of PdfPageThumbnail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? pageNumber = null,
    Object? globalIndex = null,
    Object? dimensions = null,
    Object? rotation = null,
    Object? thumbnailData = freezed,
    Object? isSelected = null,
    Object? isDuplicate = null,
    Object? isBlank = null,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _self.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: null == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      globalIndex: null == globalIndex
          ? _self.globalIndex
          : globalIndex // ignore: cast_nullable_to_non_nullable
              as int,
      dimensions: null == dimensions
          ? _self.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as PageDimensions,
      rotation: null == rotation
          ? _self.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as PageRotation,
      thumbnailData: freezed == thumbnailData
          ? _self.thumbnailData
          : thumbnailData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDuplicate: null == isDuplicate
          ? _self.isDuplicate
          : isDuplicate // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlank: null == isBlank
          ? _self.isBlank
          : isBlank // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ThumbnailStatus,
    ));
  }
}

/// Adds pattern-matching-related methods to [PdfPageThumbnail].
extension PdfPageThumbnailPatterns on PdfPageThumbnail {
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
    TResult Function(_PdfPageThumbnail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfPageThumbnail() when $default != null:
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
    TResult Function(_PdfPageThumbnail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfPageThumbnail():
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
    TResult? Function(_PdfPageThumbnail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfPageThumbnail() when $default != null:
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
            String id,
            String documentId,
            int pageNumber,
            int globalIndex,
            PageDimensions dimensions,
            PageRotation rotation,
            Uint8List? thumbnailData,
            bool isSelected,
            bool isDuplicate,
            bool isBlank,
            ThumbnailStatus status)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfPageThumbnail() when $default != null:
        return $default(
            _that.id,
            _that.documentId,
            _that.pageNumber,
            _that.globalIndex,
            _that.dimensions,
            _that.rotation,
            _that.thumbnailData,
            _that.isSelected,
            _that.isDuplicate,
            _that.isBlank,
            _that.status);
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
            String id,
            String documentId,
            int pageNumber,
            int globalIndex,
            PageDimensions dimensions,
            PageRotation rotation,
            Uint8List? thumbnailData,
            bool isSelected,
            bool isDuplicate,
            bool isBlank,
            ThumbnailStatus status)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfPageThumbnail():
        return $default(
            _that.id,
            _that.documentId,
            _that.pageNumber,
            _that.globalIndex,
            _that.dimensions,
            _that.rotation,
            _that.thumbnailData,
            _that.isSelected,
            _that.isDuplicate,
            _that.isBlank,
            _that.status);
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
            String id,
            String documentId,
            int pageNumber,
            int globalIndex,
            PageDimensions dimensions,
            PageRotation rotation,
            Uint8List? thumbnailData,
            bool isSelected,
            bool isDuplicate,
            bool isBlank,
            ThumbnailStatus status)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfPageThumbnail() when $default != null:
        return $default(
            _that.id,
            _that.documentId,
            _that.pageNumber,
            _that.globalIndex,
            _that.dimensions,
            _that.rotation,
            _that.thumbnailData,
            _that.isSelected,
            _that.isDuplicate,
            _that.isBlank,
            _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PdfPageThumbnail extends PdfPageThumbnail {
  const _PdfPageThumbnail(
      {required this.id,
      required this.documentId,
      required this.pageNumber,
      required this.globalIndex,
      required this.dimensions,
      this.rotation = PageRotation.none,
      this.thumbnailData,
      this.isSelected = false,
      this.isDuplicate = false,
      this.isBlank = false,
      this.status = ThumbnailStatus.loading})
      : super._();

  @override
  final String id;
  @override
  final String documentId;
  @override
  final int pageNumber;
  @override
  final int globalIndex;
  @override
  final PageDimensions dimensions;
  @override
  @JsonKey()
  final PageRotation rotation;
  @override
  final Uint8List? thumbnailData;
  @override
  @JsonKey()
  final bool isSelected;
  @override
  @JsonKey()
  final bool isDuplicate;
  @override
  @JsonKey()
  final bool isBlank;
  @override
  @JsonKey()
  final ThumbnailStatus status;

  /// Create a copy of PdfPageThumbnail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PdfPageThumbnailCopyWith<_PdfPageThumbnail> get copyWith =>
      __$PdfPageThumbnailCopyWithImpl<_PdfPageThumbnail>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PdfPageThumbnail &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.globalIndex, globalIndex) ||
                other.globalIndex == globalIndex) &&
            (identical(other.dimensions, dimensions) ||
                other.dimensions == dimensions) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            const DeepCollectionEquality()
                .equals(other.thumbnailData, thumbnailData) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isDuplicate, isDuplicate) ||
                other.isDuplicate == isDuplicate) &&
            (identical(other.isBlank, isBlank) || other.isBlank == isBlank) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      documentId,
      pageNumber,
      globalIndex,
      dimensions,
      rotation,
      const DeepCollectionEquality().hash(thumbnailData),
      isSelected,
      isDuplicate,
      isBlank,
      status);

  @override
  String toString() {
    return 'PdfPageThumbnail(id: $id, documentId: $documentId, pageNumber: $pageNumber, globalIndex: $globalIndex, dimensions: $dimensions, rotation: $rotation, thumbnailData: $thumbnailData, isSelected: $isSelected, isDuplicate: $isDuplicate, isBlank: $isBlank, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$PdfPageThumbnailCopyWith<$Res>
    implements $PdfPageThumbnailCopyWith<$Res> {
  factory _$PdfPageThumbnailCopyWith(
          _PdfPageThumbnail value, $Res Function(_PdfPageThumbnail) _then) =
      __$PdfPageThumbnailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String documentId,
      int pageNumber,
      int globalIndex,
      PageDimensions dimensions,
      PageRotation rotation,
      Uint8List? thumbnailData,
      bool isSelected,
      bool isDuplicate,
      bool isBlank,
      ThumbnailStatus status});
}

/// @nodoc
class __$PdfPageThumbnailCopyWithImpl<$Res>
    implements _$PdfPageThumbnailCopyWith<$Res> {
  __$PdfPageThumbnailCopyWithImpl(this._self, this._then);

  final _PdfPageThumbnail _self;
  final $Res Function(_PdfPageThumbnail) _then;

  /// Create a copy of PdfPageThumbnail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? pageNumber = null,
    Object? globalIndex = null,
    Object? dimensions = null,
    Object? rotation = null,
    Object? thumbnailData = freezed,
    Object? isSelected = null,
    Object? isDuplicate = null,
    Object? isBlank = null,
    Object? status = null,
  }) {
    return _then(_PdfPageThumbnail(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _self.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: null == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      globalIndex: null == globalIndex
          ? _self.globalIndex
          : globalIndex // ignore: cast_nullable_to_non_nullable
              as int,
      dimensions: null == dimensions
          ? _self.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as PageDimensions,
      rotation: null == rotation
          ? _self.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as PageRotation,
      thumbnailData: freezed == thumbnailData
          ? _self.thumbnailData
          : thumbnailData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDuplicate: null == isDuplicate
          ? _self.isDuplicate
          : isDuplicate // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlank: null == isBlank
          ? _self.isBlank
          : isBlank // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ThumbnailStatus,
    ));
  }
}

/// @nodoc
mixin _$PdfMergerOperation {
  String get id;
  String get message;
  DateTime get startTime;
  DateTime? get endTime;
  double get progress;
  bool get isCompleted;
  String? get error;

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PdfMergerOperationCopyWith<PdfMergerOperation> get copyWith =>
      _$PdfMergerOperationCopyWithImpl<PdfMergerOperation>(
          this as PdfMergerOperation, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PdfMergerOperation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, message, startTime, endTime,
      progress, isCompleted, error);

  @override
  String toString() {
    return 'PdfMergerOperation(id: $id, message: $message, startTime: $startTime, endTime: $endTime, progress: $progress, isCompleted: $isCompleted, error: $error)';
  }
}

/// @nodoc
abstract mixin class $PdfMergerOperationCopyWith<$Res> {
  factory $PdfMergerOperationCopyWith(
          PdfMergerOperation value, $Res Function(PdfMergerOperation) _then) =
      _$PdfMergerOperationCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String message,
      DateTime startTime,
      DateTime? endTime,
      double progress,
      bool isCompleted,
      String? error});
}

/// @nodoc
class _$PdfMergerOperationCopyWithImpl<$Res>
    implements $PdfMergerOperationCopyWith<$Res> {
  _$PdfMergerOperationCopyWithImpl(this._self, this._then);

  final PdfMergerOperation _self;
  final $Res Function(PdfMergerOperation) _then;

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? progress = null,
    Object? isCompleted = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PdfMergerOperation].
extension PdfMergerOperationPatterns on PdfMergerOperation {
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
    TResult Function(_PdfMergerOperation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfMergerOperation() when $default != null:
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
    TResult Function(_PdfMergerOperation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerOperation():
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
    TResult? Function(_PdfMergerOperation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerOperation() when $default != null:
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
            String id,
            String message,
            DateTime startTime,
            DateTime? endTime,
            double progress,
            bool isCompleted,
            String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PdfMergerOperation() when $default != null:
        return $default(_that.id, _that.message, _that.startTime, _that.endTime,
            _that.progress, _that.isCompleted, _that.error);
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
    TResult Function(String id, String message, DateTime startTime,
            DateTime? endTime, double progress, bool isCompleted, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerOperation():
        return $default(_that.id, _that.message, _that.startTime, _that.endTime,
            _that.progress, _that.isCompleted, _that.error);
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
            String id,
            String message,
            DateTime startTime,
            DateTime? endTime,
            double progress,
            bool isCompleted,
            String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PdfMergerOperation() when $default != null:
        return $default(_that.id, _that.message, _that.startTime, _that.endTime,
            _that.progress, _that.isCompleted, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PdfMergerOperation implements PdfMergerOperation {
  const _PdfMergerOperation(
      {required this.id,
      required this.message,
      required this.startTime,
      this.endTime,
      this.progress = 0.0,
      this.isCompleted = false,
      this.error});

  @override
  final String id;
  @override
  final String message;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final String? error;

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PdfMergerOperationCopyWith<_PdfMergerOperation> get copyWith =>
      __$PdfMergerOperationCopyWithImpl<_PdfMergerOperation>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PdfMergerOperation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, message, startTime, endTime,
      progress, isCompleted, error);

  @override
  String toString() {
    return 'PdfMergerOperation(id: $id, message: $message, startTime: $startTime, endTime: $endTime, progress: $progress, isCompleted: $isCompleted, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$PdfMergerOperationCopyWith<$Res>
    implements $PdfMergerOperationCopyWith<$Res> {
  factory _$PdfMergerOperationCopyWith(
          _PdfMergerOperation value, $Res Function(_PdfMergerOperation) _then) =
      __$PdfMergerOperationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String message,
      DateTime startTime,
      DateTime? endTime,
      double progress,
      bool isCompleted,
      String? error});
}

/// @nodoc
class __$PdfMergerOperationCopyWithImpl<$Res>
    implements _$PdfMergerOperationCopyWith<$Res> {
  __$PdfMergerOperationCopyWithImpl(this._self, this._then);

  final _PdfMergerOperation _self;
  final $Res Function(_PdfMergerOperation) _then;

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? progress = null,
    Object? isCompleted = null,
    Object? error = freezed,
  }) {
    return _then(_PdfMergerOperation(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$MergeStatistics {
  int get totalDocuments;
  int get totalPages;
  int get totalSize;
  int get estimatedOutputSize;
  double get compressionRatio;
  Duration get estimatedTime;
  Map<String, int> get orientationCounts;
  int get duplicateCount;

  /// Create a copy of MergeStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MergeStatisticsCopyWith<MergeStatistics> get copyWith =>
      _$MergeStatisticsCopyWithImpl<MergeStatistics>(
          this as MergeStatistics, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MergeStatistics &&
            (identical(other.totalDocuments, totalDocuments) ||
                other.totalDocuments == totalDocuments) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize) &&
            (identical(other.estimatedOutputSize, estimatedOutputSize) ||
                other.estimatedOutputSize == estimatedOutputSize) &&
            (identical(other.compressionRatio, compressionRatio) ||
                other.compressionRatio == compressionRatio) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            const DeepCollectionEquality()
                .equals(other.orientationCounts, orientationCounts) &&
            (identical(other.duplicateCount, duplicateCount) ||
                other.duplicateCount == duplicateCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalDocuments,
      totalPages,
      totalSize,
      estimatedOutputSize,
      compressionRatio,
      estimatedTime,
      const DeepCollectionEquality().hash(orientationCounts),
      duplicateCount);

  @override
  String toString() {
    return 'MergeStatistics(totalDocuments: $totalDocuments, totalPages: $totalPages, totalSize: $totalSize, estimatedOutputSize: $estimatedOutputSize, compressionRatio: $compressionRatio, estimatedTime: $estimatedTime, orientationCounts: $orientationCounts, duplicateCount: $duplicateCount)';
  }
}

/// @nodoc
abstract mixin class $MergeStatisticsCopyWith<$Res> {
  factory $MergeStatisticsCopyWith(
          MergeStatistics value, $Res Function(MergeStatistics) _then) =
      _$MergeStatisticsCopyWithImpl;
  @useResult
  $Res call(
      {int totalDocuments,
      int totalPages,
      int totalSize,
      int estimatedOutputSize,
      double compressionRatio,
      Duration estimatedTime,
      Map<String, int> orientationCounts,
      int duplicateCount});
}

/// @nodoc
class _$MergeStatisticsCopyWithImpl<$Res>
    implements $MergeStatisticsCopyWith<$Res> {
  _$MergeStatisticsCopyWithImpl(this._self, this._then);

  final MergeStatistics _self;
  final $Res Function(MergeStatistics) _then;

  /// Create a copy of MergeStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDocuments = null,
    Object? totalPages = null,
    Object? totalSize = null,
    Object? estimatedOutputSize = null,
    Object? compressionRatio = null,
    Object? estimatedTime = null,
    Object? orientationCounts = null,
    Object? duplicateCount = null,
  }) {
    return _then(_self.copyWith(
      totalDocuments: null == totalDocuments
          ? _self.totalDocuments
          : totalDocuments // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalSize: null == totalSize
          ? _self.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedOutputSize: null == estimatedOutputSize
          ? _self.estimatedOutputSize
          : estimatedOutputSize // ignore: cast_nullable_to_non_nullable
              as int,
      compressionRatio: null == compressionRatio
          ? _self.compressionRatio
          : compressionRatio // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTime: null == estimatedTime
          ? _self.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      orientationCounts: null == orientationCounts
          ? _self.orientationCounts
          : orientationCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      duplicateCount: null == duplicateCount
          ? _self.duplicateCount
          : duplicateCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MergeStatistics].
extension MergeStatisticsPatterns on MergeStatistics {
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
    TResult Function(_MergeStatistics value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MergeStatistics() when $default != null:
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
    TResult Function(_MergeStatistics value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MergeStatistics():
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
    TResult? Function(_MergeStatistics value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MergeStatistics() when $default != null:
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
            int totalDocuments,
            int totalPages,
            int totalSize,
            int estimatedOutputSize,
            double compressionRatio,
            Duration estimatedTime,
            Map<String, int> orientationCounts,
            int duplicateCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MergeStatistics() when $default != null:
        return $default(
            _that.totalDocuments,
            _that.totalPages,
            _that.totalSize,
            _that.estimatedOutputSize,
            _that.compressionRatio,
            _that.estimatedTime,
            _that.orientationCounts,
            _that.duplicateCount);
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
            int totalDocuments,
            int totalPages,
            int totalSize,
            int estimatedOutputSize,
            double compressionRatio,
            Duration estimatedTime,
            Map<String, int> orientationCounts,
            int duplicateCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MergeStatistics():
        return $default(
            _that.totalDocuments,
            _that.totalPages,
            _that.totalSize,
            _that.estimatedOutputSize,
            _that.compressionRatio,
            _that.estimatedTime,
            _that.orientationCounts,
            _that.duplicateCount);
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
            int totalDocuments,
            int totalPages,
            int totalSize,
            int estimatedOutputSize,
            double compressionRatio,
            Duration estimatedTime,
            Map<String, int> orientationCounts,
            int duplicateCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MergeStatistics() when $default != null:
        return $default(
            _that.totalDocuments,
            _that.totalPages,
            _that.totalSize,
            _that.estimatedOutputSize,
            _that.compressionRatio,
            _that.estimatedTime,
            _that.orientationCounts,
            _that.duplicateCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MergeStatistics extends MergeStatistics {
  const _MergeStatistics(
      {required this.totalDocuments,
      required this.totalPages,
      required this.totalSize,
      required this.estimatedOutputSize,
      this.compressionRatio = 0.0,
      this.estimatedTime = Duration.zero,
      final Map<String, int> orientationCounts = const {},
      this.duplicateCount = 0})
      : _orientationCounts = orientationCounts,
        super._();

  @override
  final int totalDocuments;
  @override
  final int totalPages;
  @override
  final int totalSize;
  @override
  final int estimatedOutputSize;
  @override
  @JsonKey()
  final double compressionRatio;
  @override
  @JsonKey()
  final Duration estimatedTime;
  final Map<String, int> _orientationCounts;
  @override
  @JsonKey()
  Map<String, int> get orientationCounts {
    if (_orientationCounts is EqualUnmodifiableMapView)
      return _orientationCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_orientationCounts);
  }

  @override
  @JsonKey()
  final int duplicateCount;

  /// Create a copy of MergeStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MergeStatisticsCopyWith<_MergeStatistics> get copyWith =>
      __$MergeStatisticsCopyWithImpl<_MergeStatistics>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MergeStatistics &&
            (identical(other.totalDocuments, totalDocuments) ||
                other.totalDocuments == totalDocuments) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize) &&
            (identical(other.estimatedOutputSize, estimatedOutputSize) ||
                other.estimatedOutputSize == estimatedOutputSize) &&
            (identical(other.compressionRatio, compressionRatio) ||
                other.compressionRatio == compressionRatio) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            const DeepCollectionEquality()
                .equals(other._orientationCounts, _orientationCounts) &&
            (identical(other.duplicateCount, duplicateCount) ||
                other.duplicateCount == duplicateCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalDocuments,
      totalPages,
      totalSize,
      estimatedOutputSize,
      compressionRatio,
      estimatedTime,
      const DeepCollectionEquality().hash(_orientationCounts),
      duplicateCount);

  @override
  String toString() {
    return 'MergeStatistics(totalDocuments: $totalDocuments, totalPages: $totalPages, totalSize: $totalSize, estimatedOutputSize: $estimatedOutputSize, compressionRatio: $compressionRatio, estimatedTime: $estimatedTime, orientationCounts: $orientationCounts, duplicateCount: $duplicateCount)';
  }
}

/// @nodoc
abstract mixin class _$MergeStatisticsCopyWith<$Res>
    implements $MergeStatisticsCopyWith<$Res> {
  factory _$MergeStatisticsCopyWith(
          _MergeStatistics value, $Res Function(_MergeStatistics) _then) =
      __$MergeStatisticsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalDocuments,
      int totalPages,
      int totalSize,
      int estimatedOutputSize,
      double compressionRatio,
      Duration estimatedTime,
      Map<String, int> orientationCounts,
      int duplicateCount});
}

/// @nodoc
class __$MergeStatisticsCopyWithImpl<$Res>
    implements _$MergeStatisticsCopyWith<$Res> {
  __$MergeStatisticsCopyWithImpl(this._self, this._then);

  final _MergeStatistics _self;
  final $Res Function(_MergeStatistics) _then;

  /// Create a copy of MergeStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalDocuments = null,
    Object? totalPages = null,
    Object? totalSize = null,
    Object? estimatedOutputSize = null,
    Object? compressionRatio = null,
    Object? estimatedTime = null,
    Object? orientationCounts = null,
    Object? duplicateCount = null,
  }) {
    return _then(_MergeStatistics(
      totalDocuments: null == totalDocuments
          ? _self.totalDocuments
          : totalDocuments // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalSize: null == totalSize
          ? _self.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedOutputSize: null == estimatedOutputSize
          ? _self.estimatedOutputSize
          : estimatedOutputSize // ignore: cast_nullable_to_non_nullable
              as int,
      compressionRatio: null == compressionRatio
          ? _self.compressionRatio
          : compressionRatio // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTime: null == estimatedTime
          ? _self.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      orientationCounts: null == orientationCounts
          ? _self._orientationCounts
          : orientationCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      duplicateCount: null == duplicateCount
          ? _self.duplicateCount
          : duplicateCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$PageReorderOperation {
  String get pageId;
  int get fromIndex;
  int get toIndex;
  bool get isValid;
  bool get isActive;

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PageReorderOperationCopyWith<PageReorderOperation> get copyWith =>
      _$PageReorderOperationCopyWithImpl<PageReorderOperation>(
          this as PageReorderOperation, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PageReorderOperation &&
            (identical(other.pageId, pageId) || other.pageId == pageId) &&
            (identical(other.fromIndex, fromIndex) ||
                other.fromIndex == fromIndex) &&
            (identical(other.toIndex, toIndex) || other.toIndex == toIndex) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pageId, fromIndex, toIndex, isValid, isActive);

  @override
  String toString() {
    return 'PageReorderOperation(pageId: $pageId, fromIndex: $fromIndex, toIndex: $toIndex, isValid: $isValid, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $PageReorderOperationCopyWith<$Res> {
  factory $PageReorderOperationCopyWith(PageReorderOperation value,
          $Res Function(PageReorderOperation) _then) =
      _$PageReorderOperationCopyWithImpl;
  @useResult
  $Res call(
      {String pageId, int fromIndex, int toIndex, bool isValid, bool isActive});
}

/// @nodoc
class _$PageReorderOperationCopyWithImpl<$Res>
    implements $PageReorderOperationCopyWith<$Res> {
  _$PageReorderOperationCopyWithImpl(this._self, this._then);

  final PageReorderOperation _self;
  final $Res Function(PageReorderOperation) _then;

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = null,
    Object? fromIndex = null,
    Object? toIndex = null,
    Object? isValid = null,
    Object? isActive = null,
  }) {
    return _then(_self.copyWith(
      pageId: null == pageId
          ? _self.pageId
          : pageId // ignore: cast_nullable_to_non_nullable
              as String,
      fromIndex: null == fromIndex
          ? _self.fromIndex
          : fromIndex // ignore: cast_nullable_to_non_nullable
              as int,
      toIndex: null == toIndex
          ? _self.toIndex
          : toIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isValid: null == isValid
          ? _self.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [PageReorderOperation].
extension PageReorderOperationPatterns on PageReorderOperation {
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
    TResult Function(_PageReorderOperation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PageReorderOperation() when $default != null:
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
    TResult Function(_PageReorderOperation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageReorderOperation():
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
    TResult? Function(_PageReorderOperation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageReorderOperation() when $default != null:
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
    TResult Function(String pageId, int fromIndex, int toIndex, bool isValid,
            bool isActive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PageReorderOperation() when $default != null:
        return $default(_that.pageId, _that.fromIndex, _that.toIndex,
            _that.isValid, _that.isActive);
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
    TResult Function(String pageId, int fromIndex, int toIndex, bool isValid,
            bool isActive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageReorderOperation():
        return $default(_that.pageId, _that.fromIndex, _that.toIndex,
            _that.isValid, _that.isActive);
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
    TResult? Function(String pageId, int fromIndex, int toIndex, bool isValid,
            bool isActive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PageReorderOperation() when $default != null:
        return $default(_that.pageId, _that.fromIndex, _that.toIndex,
            _that.isValid, _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PageReorderOperation implements PageReorderOperation {
  const _PageReorderOperation(
      {required this.pageId,
      required this.fromIndex,
      required this.toIndex,
      this.isValid = true,
      this.isActive = false});

  @override
  final String pageId;
  @override
  final int fromIndex;
  @override
  final int toIndex;
  @override
  @JsonKey()
  final bool isValid;
  @override
  @JsonKey()
  final bool isActive;

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PageReorderOperationCopyWith<_PageReorderOperation> get copyWith =>
      __$PageReorderOperationCopyWithImpl<_PageReorderOperation>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PageReorderOperation &&
            (identical(other.pageId, pageId) || other.pageId == pageId) &&
            (identical(other.fromIndex, fromIndex) ||
                other.fromIndex == fromIndex) &&
            (identical(other.toIndex, toIndex) || other.toIndex == toIndex) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pageId, fromIndex, toIndex, isValid, isActive);

  @override
  String toString() {
    return 'PageReorderOperation(pageId: $pageId, fromIndex: $fromIndex, toIndex: $toIndex, isValid: $isValid, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$PageReorderOperationCopyWith<$Res>
    implements $PageReorderOperationCopyWith<$Res> {
  factory _$PageReorderOperationCopyWith(_PageReorderOperation value,
          $Res Function(_PageReorderOperation) _then) =
      __$PageReorderOperationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String pageId, int fromIndex, int toIndex, bool isValid, bool isActive});
}

/// @nodoc
class __$PageReorderOperationCopyWithImpl<$Res>
    implements _$PageReorderOperationCopyWith<$Res> {
  __$PageReorderOperationCopyWithImpl(this._self, this._then);

  final _PageReorderOperation _self;
  final $Res Function(_PageReorderOperation) _then;

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pageId = null,
    Object? fromIndex = null,
    Object? toIndex = null,
    Object? isValid = null,
    Object? isActive = null,
  }) {
    return _then(_PageReorderOperation(
      pageId: null == pageId
          ? _self.pageId
          : pageId // ignore: cast_nullable_to_non_nullable
              as String,
      fromIndex: null == fromIndex
          ? _self.fromIndex
          : fromIndex // ignore: cast_nullable_to_non_nullable
              as int,
      toIndex: null == toIndex
          ? _self.toIndex
          : toIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isValid: null == isValid
          ? _self.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$BatchPageOperation {
  List<String> get pageIds;
  String get operationType;
  Map<String, dynamic> get parameters;
  double get progress;
  bool get isProcessing;

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BatchPageOperationCopyWith<BatchPageOperation> get copyWith =>
      _$BatchPageOperationCopyWithImpl<BatchPageOperation>(
          this as BatchPageOperation, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BatchPageOperation &&
            const DeepCollectionEquality().equals(other.pageIds, pageIds) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(pageIds),
      operationType,
      const DeepCollectionEquality().hash(parameters),
      progress,
      isProcessing);

  @override
  String toString() {
    return 'BatchPageOperation(pageIds: $pageIds, operationType: $operationType, parameters: $parameters, progress: $progress, isProcessing: $isProcessing)';
  }
}

/// @nodoc
abstract mixin class $BatchPageOperationCopyWith<$Res> {
  factory $BatchPageOperationCopyWith(
          BatchPageOperation value, $Res Function(BatchPageOperation) _then) =
      _$BatchPageOperationCopyWithImpl;
  @useResult
  $Res call(
      {List<String> pageIds,
      String operationType,
      Map<String, dynamic> parameters,
      double progress,
      bool isProcessing});
}

/// @nodoc
class _$BatchPageOperationCopyWithImpl<$Res>
    implements $BatchPageOperationCopyWith<$Res> {
  _$BatchPageOperationCopyWithImpl(this._self, this._then);

  final BatchPageOperation _self;
  final $Res Function(BatchPageOperation) _then;

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageIds = null,
    Object? operationType = null,
    Object? parameters = null,
    Object? progress = null,
    Object? isProcessing = null,
  }) {
    return _then(_self.copyWith(
      pageIds: null == pageIds
          ? _self.pageIds
          : pageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      operationType: null == operationType
          ? _self.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _self.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [BatchPageOperation].
extension BatchPageOperationPatterns on BatchPageOperation {
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
    TResult Function(_BatchPageOperation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BatchPageOperation() when $default != null:
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
    TResult Function(_BatchPageOperation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BatchPageOperation():
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
    TResult? Function(_BatchPageOperation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BatchPageOperation() when $default != null:
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
            List<String> pageIds,
            String operationType,
            Map<String, dynamic> parameters,
            double progress,
            bool isProcessing)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BatchPageOperation() when $default != null:
        return $default(_that.pageIds, _that.operationType, _that.parameters,
            _that.progress, _that.isProcessing);
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
    TResult Function(List<String> pageIds, String operationType,
            Map<String, dynamic> parameters, double progress, bool isProcessing)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BatchPageOperation():
        return $default(_that.pageIds, _that.operationType, _that.parameters,
            _that.progress, _that.isProcessing);
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
            List<String> pageIds,
            String operationType,
            Map<String, dynamic> parameters,
            double progress,
            bool isProcessing)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BatchPageOperation() when $default != null:
        return $default(_that.pageIds, _that.operationType, _that.parameters,
            _that.progress, _that.isProcessing);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BatchPageOperation implements BatchPageOperation {
  const _BatchPageOperation(
      {required final List<String> pageIds,
      required this.operationType,
      final Map<String, dynamic> parameters = const {},
      this.progress = 0.0,
      this.isProcessing = false})
      : _pageIds = pageIds,
        _parameters = parameters;

  final List<String> _pageIds;
  @override
  List<String> get pageIds {
    if (_pageIds is EqualUnmodifiableListView) return _pageIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pageIds);
  }

  @override
  final String operationType;
  final Map<String, dynamic> _parameters;
  @override
  @JsonKey()
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final bool isProcessing;

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BatchPageOperationCopyWith<_BatchPageOperation> get copyWith =>
      __$BatchPageOperationCopyWithImpl<_BatchPageOperation>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BatchPageOperation &&
            const DeepCollectionEquality().equals(other._pageIds, _pageIds) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pageIds),
      operationType,
      const DeepCollectionEquality().hash(_parameters),
      progress,
      isProcessing);

  @override
  String toString() {
    return 'BatchPageOperation(pageIds: $pageIds, operationType: $operationType, parameters: $parameters, progress: $progress, isProcessing: $isProcessing)';
  }
}

/// @nodoc
abstract mixin class _$BatchPageOperationCopyWith<$Res>
    implements $BatchPageOperationCopyWith<$Res> {
  factory _$BatchPageOperationCopyWith(
          _BatchPageOperation value, $Res Function(_BatchPageOperation) _then) =
      __$BatchPageOperationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<String> pageIds,
      String operationType,
      Map<String, dynamic> parameters,
      double progress,
      bool isProcessing});
}

/// @nodoc
class __$BatchPageOperationCopyWithImpl<$Res>
    implements _$BatchPageOperationCopyWith<$Res> {
  __$BatchPageOperationCopyWithImpl(this._self, this._then);

  final _BatchPageOperation _self;
  final $Res Function(_BatchPageOperation) _then;

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pageIds = null,
    Object? operationType = null,
    Object? parameters = null,
    Object? progress = null,
    Object? isProcessing = null,
  }) {
    return _then(_BatchPageOperation(
      pageIds: null == pageIds
          ? _self._pageIds
          : pageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      operationType: null == operationType
          ? _self.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _self._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
