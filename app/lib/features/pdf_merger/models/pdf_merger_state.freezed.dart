// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pdf_merger_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PdfMergerState {
  List<PdfDocument> get documents => throw _privateConstructorUsedError;
  List<PdfPageThumbnail> get pages => throw _privateConstructorUsedError;
  bool get isProcessing => throw _privateConstructorUsedError;
  int get processingProgress => throw _privateConstructorUsedError;
  List<String> get processingErrors => throw _privateConstructorUsedError;
  PdfDocument? get selectedDocument => throw _privateConstructorUsedError;
  PdfPageThumbnail? get selectedPage => throw _privateConstructorUsedError;
  bool get showPasswordDialog => throw _privateConstructorUsedError;
  bool get showAdvancedSettings => throw _privateConstructorUsedError;
  bool get enableEncryption => throw _privateConstructorUsedError;
  String get encryptionPassword => throw _privateConstructorUsedError;
  PdfPermissions get permissions => throw _privateConstructorUsedError;
  PdfMergeOptions get mergeOptions => throw _privateConstructorUsedError;
  Uint8List? get mergedPdfData => throw _privateConstructorUsedError;
  String get outputFileName => throw _privateConstructorUsedError;

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PdfMergerStateCopyWith<PdfMergerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PdfMergerStateCopyWith<$Res> {
  factory $PdfMergerStateCopyWith(
          PdfMergerState value, $Res Function(PdfMergerState) then) =
      _$PdfMergerStateCopyWithImpl<$Res, PdfMergerState>;
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
class _$PdfMergerStateCopyWithImpl<$Res, $Val extends PdfMergerState>
    implements $PdfMergerStateCopyWith<$Res> {
  _$PdfMergerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<PdfDocument>,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PdfPageThumbnail>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _value.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _value.processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedDocument: freezed == selectedDocument
          ? _value.selectedDocument
          : selectedDocument // ignore: cast_nullable_to_non_nullable
              as PdfDocument?,
      selectedPage: freezed == selectedPage
          ? _value.selectedPage
          : selectedPage // ignore: cast_nullable_to_non_nullable
              as PdfPageThumbnail?,
      showPasswordDialog: null == showPasswordDialog
          ? _value.showPasswordDialog
          : showPasswordDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      showAdvancedSettings: null == showAdvancedSettings
          ? _value.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      enableEncryption: null == enableEncryption
          ? _value.enableEncryption
          : enableEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptionPassword: null == encryptionPassword
          ? _value.encryptionPassword
          : encryptionPassword // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as PdfPermissions,
      mergeOptions: null == mergeOptions
          ? _value.mergeOptions
          : mergeOptions // ignore: cast_nullable_to_non_nullable
              as PdfMergeOptions,
      mergedPdfData: freezed == mergedPdfData
          ? _value.mergedPdfData
          : mergedPdfData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      outputFileName: null == outputFileName
          ? _value.outputFileName
          : outputFileName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PdfDocumentCopyWith<$Res>? get selectedDocument {
    if (_value.selectedDocument == null) {
      return null;
    }

    return $PdfDocumentCopyWith<$Res>(_value.selectedDocument!, (value) {
      return _then(_value.copyWith(selectedDocument: value) as $Val);
    });
  }

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PdfPageThumbnailCopyWith<$Res>? get selectedPage {
    if (_value.selectedPage == null) {
      return null;
    }

    return $PdfPageThumbnailCopyWith<$Res>(_value.selectedPage!, (value) {
      return _then(_value.copyWith(selectedPage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PdfMergerStateImplCopyWith<$Res>
    implements $PdfMergerStateCopyWith<$Res> {
  factory _$$PdfMergerStateImplCopyWith(_$PdfMergerStateImpl value,
          $Res Function(_$PdfMergerStateImpl) then) =
      __$$PdfMergerStateImplCopyWithImpl<$Res>;
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
class __$$PdfMergerStateImplCopyWithImpl<$Res>
    extends _$PdfMergerStateCopyWithImpl<$Res, _$PdfMergerStateImpl>
    implements _$$PdfMergerStateImplCopyWith<$Res> {
  __$$PdfMergerStateImplCopyWithImpl(
      _$PdfMergerStateImpl _value, $Res Function(_$PdfMergerStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$PdfMergerStateImpl(
      documents: null == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<PdfDocument>,
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PdfPageThumbnail>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      processingProgress: null == processingProgress
          ? _value.processingProgress
          : processingProgress // ignore: cast_nullable_to_non_nullable
              as int,
      processingErrors: null == processingErrors
          ? _value._processingErrors
          : processingErrors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedDocument: freezed == selectedDocument
          ? _value.selectedDocument
          : selectedDocument // ignore: cast_nullable_to_non_nullable
              as PdfDocument?,
      selectedPage: freezed == selectedPage
          ? _value.selectedPage
          : selectedPage // ignore: cast_nullable_to_non_nullable
              as PdfPageThumbnail?,
      showPasswordDialog: null == showPasswordDialog
          ? _value.showPasswordDialog
          : showPasswordDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      showAdvancedSettings: null == showAdvancedSettings
          ? _value.showAdvancedSettings
          : showAdvancedSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      enableEncryption: null == enableEncryption
          ? _value.enableEncryption
          : enableEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      encryptionPassword: null == encryptionPassword
          ? _value.encryptionPassword
          : encryptionPassword // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as PdfPermissions,
      mergeOptions: null == mergeOptions
          ? _value.mergeOptions
          : mergeOptions // ignore: cast_nullable_to_non_nullable
              as PdfMergeOptions,
      mergedPdfData: freezed == mergedPdfData
          ? _value.mergedPdfData
          : mergedPdfData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      outputFileName: null == outputFileName
          ? _value.outputFileName
          : outputFileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PdfMergerStateImpl implements _PdfMergerState {
  const _$PdfMergerStateImpl(
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
      this.outputFileName = ''})
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

  @override
  String toString() {
    return 'PdfMergerState(documents: $documents, pages: $pages, isProcessing: $isProcessing, processingProgress: $processingProgress, processingErrors: $processingErrors, selectedDocument: $selectedDocument, selectedPage: $selectedPage, showPasswordDialog: $showPasswordDialog, showAdvancedSettings: $showAdvancedSettings, enableEncryption: $enableEncryption, encryptionPassword: $encryptionPassword, permissions: $permissions, mergeOptions: $mergeOptions, mergedPdfData: $mergedPdfData, outputFileName: $outputFileName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PdfMergerStateImpl &&
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

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PdfMergerStateImplCopyWith<_$PdfMergerStateImpl> get copyWith =>
      __$$PdfMergerStateImplCopyWithImpl<_$PdfMergerStateImpl>(
          this, _$identity);
}

abstract class _PdfMergerState implements PdfMergerState {
  const factory _PdfMergerState(
      {final List<PdfDocument> documents,
      final List<PdfPageThumbnail> pages,
      final bool isProcessing,
      final int processingProgress,
      final List<String> processingErrors,
      final PdfDocument? selectedDocument,
      final PdfPageThumbnail? selectedPage,
      final bool showPasswordDialog,
      final bool showAdvancedSettings,
      final bool enableEncryption,
      final String encryptionPassword,
      final PdfPermissions permissions,
      final PdfMergeOptions mergeOptions,
      final Uint8List? mergedPdfData,
      final String outputFileName}) = _$PdfMergerStateImpl;

  @override
  List<PdfDocument> get documents;
  @override
  List<PdfPageThumbnail> get pages;
  @override
  bool get isProcessing;
  @override
  int get processingProgress;
  @override
  List<String> get processingErrors;
  @override
  PdfDocument? get selectedDocument;
  @override
  PdfPageThumbnail? get selectedPage;
  @override
  bool get showPasswordDialog;
  @override
  bool get showAdvancedSettings;
  @override
  bool get enableEncryption;
  @override
  String get encryptionPassword;
  @override
  PdfPermissions get permissions;
  @override
  PdfMergeOptions get mergeOptions;
  @override
  Uint8List? get mergedPdfData;
  @override
  String get outputFileName;

  /// Create a copy of PdfMergerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PdfMergerStateImplCopyWith<_$PdfMergerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PdfDocument {
  String get id => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  Uint8List get data => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  int get pageCount => throw _privateConstructorUsedError;
  List<PdfPageThumbnail> get pages => throw _privateConstructorUsedError;
  DocumentStatus get status => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  bool get isEncrypted => throw _privateConstructorUsedError;
  DateTime? get lastModified => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of PdfDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PdfDocumentCopyWith<PdfDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PdfDocumentCopyWith<$Res> {
  factory $PdfDocumentCopyWith(
          PdfDocument value, $Res Function(PdfDocument) then) =
      _$PdfDocumentCopyWithImpl<$Res, PdfDocument>;
  @useResult
  $Res call(
      {String id,
      String fileName,
      Uint8List data,
      int fileSize,
      int pageCount,
      List<PdfPageThumbnail> pages,
      DocumentStatus status,
      String error,
      String? password,
      bool isEncrypted,
      DateTime? lastModified,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PdfDocumentCopyWithImpl<$Res, $Val extends PdfDocument>
    implements $PdfDocumentCopyWith<$Res> {
  _$PdfDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    Object? pages = null,
    Object? status = null,
    Object? error = null,
    Object? password = freezed,
    Object? isEncrypted = null,
    Object? lastModified = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      pageCount: null == pageCount
          ? _value.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PdfPageThumbnail>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DocumentStatus,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PdfDocumentImplCopyWith<$Res>
    implements $PdfDocumentCopyWith<$Res> {
  factory _$$PdfDocumentImplCopyWith(
          _$PdfDocumentImpl value, $Res Function(_$PdfDocumentImpl) then) =
      __$$PdfDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fileName,
      Uint8List data,
      int fileSize,
      int pageCount,
      List<PdfPageThumbnail> pages,
      DocumentStatus status,
      String error,
      String? password,
      bool isEncrypted,
      DateTime? lastModified,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PdfDocumentImplCopyWithImpl<$Res>
    extends _$PdfDocumentCopyWithImpl<$Res, _$PdfDocumentImpl>
    implements _$$PdfDocumentImplCopyWith<$Res> {
  __$$PdfDocumentImplCopyWithImpl(
      _$PdfDocumentImpl _value, $Res Function(_$PdfDocumentImpl) _then)
      : super(_value, _then);

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
    Object? pages = null,
    Object? status = null,
    Object? error = null,
    Object? password = freezed,
    Object? isEncrypted = null,
    Object? lastModified = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$PdfDocumentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      pageCount: null == pageCount
          ? _value.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int,
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PdfPageThumbnail>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DocumentStatus,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$PdfDocumentImpl extends _PdfDocument {
  const _$PdfDocumentImpl(
      {required this.id,
      required this.fileName,
      required this.data,
      required this.fileSize,
      required this.pageCount,
      final List<PdfPageThumbnail> pages = const [],
      this.status = DocumentStatus.loaded,
      this.error = '',
      this.password,
      this.isEncrypted = false,
      this.lastModified,
      final Map<String, dynamic>? metadata})
      : _pages = pages,
        _metadata = metadata,
        super._();

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
  final DocumentStatus status;
  @override
  @JsonKey()
  final String error;
  @override
  final String? password;
  @override
  @JsonKey()
  final bool isEncrypted;
  @override
  final DateTime? lastModified;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PdfDocument(id: $id, fileName: $fileName, data: $data, fileSize: $fileSize, pageCount: $pageCount, pages: $pages, status: $status, error: $error, password: $password, isEncrypted: $isEncrypted, lastModified: $lastModified, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PdfDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount) &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.isEncrypted, isEncrypted) ||
                other.isEncrypted == isEncrypted) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fileName,
      const DeepCollectionEquality().hash(data),
      fileSize,
      pageCount,
      const DeepCollectionEquality().hash(_pages),
      status,
      error,
      password,
      isEncrypted,
      lastModified,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PdfDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PdfDocumentImplCopyWith<_$PdfDocumentImpl> get copyWith =>
      __$$PdfDocumentImplCopyWithImpl<_$PdfDocumentImpl>(this, _$identity);
}

abstract class _PdfDocument extends PdfDocument {
  const factory _PdfDocument(
      {required final String id,
      required final String fileName,
      required final Uint8List data,
      required final int fileSize,
      required final int pageCount,
      final List<PdfPageThumbnail> pages,
      final DocumentStatus status,
      final String error,
      final String? password,
      final bool isEncrypted,
      final DateTime? lastModified,
      final Map<String, dynamic>? metadata}) = _$PdfDocumentImpl;
  const _PdfDocument._() : super._();

  @override
  String get id;
  @override
  String get fileName;
  @override
  Uint8List get data;
  @override
  int get fileSize;
  @override
  int get pageCount;
  @override
  List<PdfPageThumbnail> get pages;
  @override
  DocumentStatus get status;
  @override
  String get error;
  @override
  String? get password;
  @override
  bool get isEncrypted;
  @override
  DateTime? get lastModified;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PdfDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PdfDocumentImplCopyWith<_$PdfDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PdfPageThumbnail {
  String get id => throw _privateConstructorUsedError;
  String get documentId => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  int get globalIndex =>
      throw _privateConstructorUsedError; // Index in merged document
  PageDimensions get dimensions => throw _privateConstructorUsedError;
  PageRotation get rotation => throw _privateConstructorUsedError;
  Uint8List? get thumbnailData => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  bool get isDuplicate => throw _privateConstructorUsedError;
  bool get isBlank => throw _privateConstructorUsedError;
  ThumbnailStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of PdfPageThumbnail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PdfPageThumbnailCopyWith<PdfPageThumbnail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PdfPageThumbnailCopyWith<$Res> {
  factory $PdfPageThumbnailCopyWith(
          PdfPageThumbnail value, $Res Function(PdfPageThumbnail) then) =
      _$PdfPageThumbnailCopyWithImpl<$Res, PdfPageThumbnail>;
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
class _$PdfPageThumbnailCopyWithImpl<$Res, $Val extends PdfPageThumbnail>
    implements $PdfPageThumbnailCopyWith<$Res> {
  _$PdfPageThumbnailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      globalIndex: null == globalIndex
          ? _value.globalIndex
          : globalIndex // ignore: cast_nullable_to_non_nullable
              as int,
      dimensions: null == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as PageDimensions,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as PageRotation,
      thumbnailData: freezed == thumbnailData
          ? _value.thumbnailData
          : thumbnailData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDuplicate: null == isDuplicate
          ? _value.isDuplicate
          : isDuplicate // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlank: null == isBlank
          ? _value.isBlank
          : isBlank // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ThumbnailStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PdfPageThumbnailImplCopyWith<$Res>
    implements $PdfPageThumbnailCopyWith<$Res> {
  factory _$$PdfPageThumbnailImplCopyWith(_$PdfPageThumbnailImpl value,
          $Res Function(_$PdfPageThumbnailImpl) then) =
      __$$PdfPageThumbnailImplCopyWithImpl<$Res>;
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
class __$$PdfPageThumbnailImplCopyWithImpl<$Res>
    extends _$PdfPageThumbnailCopyWithImpl<$Res, _$PdfPageThumbnailImpl>
    implements _$$PdfPageThumbnailImplCopyWith<$Res> {
  __$$PdfPageThumbnailImplCopyWithImpl(_$PdfPageThumbnailImpl _value,
      $Res Function(_$PdfPageThumbnailImpl) _then)
      : super(_value, _then);

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
    return _then(_$PdfPageThumbnailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      globalIndex: null == globalIndex
          ? _value.globalIndex
          : globalIndex // ignore: cast_nullable_to_non_nullable
              as int,
      dimensions: null == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as PageDimensions,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as PageRotation,
      thumbnailData: freezed == thumbnailData
          ? _value.thumbnailData
          : thumbnailData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isDuplicate: null == isDuplicate
          ? _value.isDuplicate
          : isDuplicate // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlank: null == isBlank
          ? _value.isBlank
          : isBlank // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ThumbnailStatus,
    ));
  }
}

/// @nodoc

class _$PdfPageThumbnailImpl extends _PdfPageThumbnail {
  const _$PdfPageThumbnailImpl(
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
// Index in merged document
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

  @override
  String toString() {
    return 'PdfPageThumbnail(id: $id, documentId: $documentId, pageNumber: $pageNumber, globalIndex: $globalIndex, dimensions: $dimensions, rotation: $rotation, thumbnailData: $thumbnailData, isSelected: $isSelected, isDuplicate: $isDuplicate, isBlank: $isBlank, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PdfPageThumbnailImpl &&
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

  /// Create a copy of PdfPageThumbnail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PdfPageThumbnailImplCopyWith<_$PdfPageThumbnailImpl> get copyWith =>
      __$$PdfPageThumbnailImplCopyWithImpl<_$PdfPageThumbnailImpl>(
          this, _$identity);
}

abstract class _PdfPageThumbnail extends PdfPageThumbnail {
  const factory _PdfPageThumbnail(
      {required final String id,
      required final String documentId,
      required final int pageNumber,
      required final int globalIndex,
      required final PageDimensions dimensions,
      final PageRotation rotation,
      final Uint8List? thumbnailData,
      final bool isSelected,
      final bool isDuplicate,
      final bool isBlank,
      final ThumbnailStatus status}) = _$PdfPageThumbnailImpl;
  const _PdfPageThumbnail._() : super._();

  @override
  String get id;
  @override
  String get documentId;
  @override
  int get pageNumber;
  @override
  int get globalIndex; // Index in merged document
  @override
  PageDimensions get dimensions;
  @override
  PageRotation get rotation;
  @override
  Uint8List? get thumbnailData;
  @override
  bool get isSelected;
  @override
  bool get isDuplicate;
  @override
  bool get isBlank;
  @override
  ThumbnailStatus get status;

  /// Create a copy of PdfPageThumbnail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PdfPageThumbnailImplCopyWith<_$PdfPageThumbnailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PdfMergerOperation {
  String get id => throw _privateConstructorUsedError;
  OperationStatus get status => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PdfMergerOperationCopyWith<PdfMergerOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PdfMergerOperationCopyWith<$Res> {
  factory $PdfMergerOperationCopyWith(
          PdfMergerOperation value, $Res Function(PdfMergerOperation) then) =
      _$PdfMergerOperationCopyWithImpl<$Res, PdfMergerOperation>;
  @useResult
  $Res call(
      {String id,
      OperationStatus status,
      int progress,
      String message,
      String error,
      DateTime? startTime,
      DateTime? endTime,
      Map<String, dynamic>? result});
}

/// @nodoc
class _$PdfMergerOperationCopyWithImpl<$Res, $Val extends PdfMergerOperation>
    implements $PdfMergerOperationCopyWith<$Res> {
  _$PdfMergerOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? progress = null,
    Object? message = null,
    Object? error = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? result = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OperationStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PdfMergerOperationImplCopyWith<$Res>
    implements $PdfMergerOperationCopyWith<$Res> {
  factory _$$PdfMergerOperationImplCopyWith(_$PdfMergerOperationImpl value,
          $Res Function(_$PdfMergerOperationImpl) then) =
      __$$PdfMergerOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      OperationStatus status,
      int progress,
      String message,
      String error,
      DateTime? startTime,
      DateTime? endTime,
      Map<String, dynamic>? result});
}

/// @nodoc
class __$$PdfMergerOperationImplCopyWithImpl<$Res>
    extends _$PdfMergerOperationCopyWithImpl<$Res, _$PdfMergerOperationImpl>
    implements _$$PdfMergerOperationImplCopyWith<$Res> {
  __$$PdfMergerOperationImplCopyWithImpl(_$PdfMergerOperationImpl _value,
      $Res Function(_$PdfMergerOperationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? progress = null,
    Object? message = null,
    Object? error = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? result = freezed,
  }) {
    return _then(_$PdfMergerOperationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OperationStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      result: freezed == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$PdfMergerOperationImpl extends _PdfMergerOperation {
  const _$PdfMergerOperationImpl(
      {required this.id,
      this.status = OperationStatus.pending,
      this.progress = 0,
      this.message = '',
      this.error = '',
      this.startTime,
      this.endTime,
      final Map<String, dynamic>? result})
      : _result = result,
        super._();

  @override
  final String id;
  @override
  @JsonKey()
  final OperationStatus status;
  @override
  @JsonKey()
  final int progress;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String error;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PdfMergerOperation(id: $id, status: $status, progress: $progress, message: $message, error: $error, startTime: $startTime, endTime: $endTime, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PdfMergerOperationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, status, progress, message,
      error, startTime, endTime, const DeepCollectionEquality().hash(_result));

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PdfMergerOperationImplCopyWith<_$PdfMergerOperationImpl> get copyWith =>
      __$$PdfMergerOperationImplCopyWithImpl<_$PdfMergerOperationImpl>(
          this, _$identity);
}

abstract class _PdfMergerOperation extends PdfMergerOperation {
  const factory _PdfMergerOperation(
      {required final String id,
      final OperationStatus status,
      final int progress,
      final String message,
      final String error,
      final DateTime? startTime,
      final DateTime? endTime,
      final Map<String, dynamic>? result}) = _$PdfMergerOperationImpl;
  const _PdfMergerOperation._() : super._();

  @override
  String get id;
  @override
  OperationStatus get status;
  @override
  int get progress;
  @override
  String get message;
  @override
  String get error;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  Map<String, dynamic>? get result;

  /// Create a copy of PdfMergerOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PdfMergerOperationImplCopyWith<_$PdfMergerOperationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MergeStatistics {
  int get totalDocuments => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get totalSize => throw _privateConstructorUsedError;
  int get estimatedOutputSize => throw _privateConstructorUsedError;
  double get compressionRatio => throw _privateConstructorUsedError;
  Duration get estimatedTime => throw _privateConstructorUsedError;
  Map<String, int>? get pageSizeDistribution =>
      throw _privateConstructorUsedError;
  Map<PageOrientation, int>? get orientationCounts =>
      throw _privateConstructorUsedError;

  /// Create a copy of MergeStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MergeStatisticsCopyWith<MergeStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MergeStatisticsCopyWith<$Res> {
  factory $MergeStatisticsCopyWith(
          MergeStatistics value, $Res Function(MergeStatistics) then) =
      _$MergeStatisticsCopyWithImpl<$Res, MergeStatistics>;
  @useResult
  $Res call(
      {int totalDocuments,
      int totalPages,
      int totalSize,
      int estimatedOutputSize,
      double compressionRatio,
      Duration estimatedTime,
      Map<String, int>? pageSizeDistribution,
      Map<PageOrientation, int>? orientationCounts});
}

/// @nodoc
class _$MergeStatisticsCopyWithImpl<$Res, $Val extends MergeStatistics>
    implements $MergeStatisticsCopyWith<$Res> {
  _$MergeStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    Object? pageSizeDistribution = freezed,
    Object? orientationCounts = freezed,
  }) {
    return _then(_value.copyWith(
      totalDocuments: null == totalDocuments
          ? _value.totalDocuments
          : totalDocuments // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedOutputSize: null == estimatedOutputSize
          ? _value.estimatedOutputSize
          : estimatedOutputSize // ignore: cast_nullable_to_non_nullable
              as int,
      compressionRatio: null == compressionRatio
          ? _value.compressionRatio
          : compressionRatio // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      pageSizeDistribution: freezed == pageSizeDistribution
          ? _value.pageSizeDistribution
          : pageSizeDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      orientationCounts: freezed == orientationCounts
          ? _value.orientationCounts
          : orientationCounts // ignore: cast_nullable_to_non_nullable
              as Map<PageOrientation, int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MergeStatisticsImplCopyWith<$Res>
    implements $MergeStatisticsCopyWith<$Res> {
  factory _$$MergeStatisticsImplCopyWith(_$MergeStatisticsImpl value,
          $Res Function(_$MergeStatisticsImpl) then) =
      __$$MergeStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalDocuments,
      int totalPages,
      int totalSize,
      int estimatedOutputSize,
      double compressionRatio,
      Duration estimatedTime,
      Map<String, int>? pageSizeDistribution,
      Map<PageOrientation, int>? orientationCounts});
}

/// @nodoc
class __$$MergeStatisticsImplCopyWithImpl<$Res>
    extends _$MergeStatisticsCopyWithImpl<$Res, _$MergeStatisticsImpl>
    implements _$$MergeStatisticsImplCopyWith<$Res> {
  __$$MergeStatisticsImplCopyWithImpl(
      _$MergeStatisticsImpl _value, $Res Function(_$MergeStatisticsImpl) _then)
      : super(_value, _then);

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
    Object? pageSizeDistribution = freezed,
    Object? orientationCounts = freezed,
  }) {
    return _then(_$MergeStatisticsImpl(
      totalDocuments: null == totalDocuments
          ? _value.totalDocuments
          : totalDocuments // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedOutputSize: null == estimatedOutputSize
          ? _value.estimatedOutputSize
          : estimatedOutputSize // ignore: cast_nullable_to_non_nullable
              as int,
      compressionRatio: null == compressionRatio
          ? _value.compressionRatio
          : compressionRatio // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      pageSizeDistribution: freezed == pageSizeDistribution
          ? _value._pageSizeDistribution
          : pageSizeDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      orientationCounts: freezed == orientationCounts
          ? _value._orientationCounts
          : orientationCounts // ignore: cast_nullable_to_non_nullable
              as Map<PageOrientation, int>?,
    ));
  }
}

/// @nodoc

class _$MergeStatisticsImpl extends _MergeStatistics {
  const _$MergeStatisticsImpl(
      {this.totalDocuments = 0,
      this.totalPages = 0,
      this.totalSize = 0,
      this.estimatedOutputSize = 0,
      this.compressionRatio = 0.0,
      this.estimatedTime = const Duration(seconds: 0),
      final Map<String, int>? pageSizeDistribution,
      final Map<PageOrientation, int>? orientationCounts})
      : _pageSizeDistribution = pageSizeDistribution,
        _orientationCounts = orientationCounts,
        super._();

  @override
  @JsonKey()
  final int totalDocuments;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final int totalSize;
  @override
  @JsonKey()
  final int estimatedOutputSize;
  @override
  @JsonKey()
  final double compressionRatio;
  @override
  @JsonKey()
  final Duration estimatedTime;
  final Map<String, int>? _pageSizeDistribution;
  @override
  Map<String, int>? get pageSizeDistribution {
    final value = _pageSizeDistribution;
    if (value == null) return null;
    if (_pageSizeDistribution is EqualUnmodifiableMapView)
      return _pageSizeDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<PageOrientation, int>? _orientationCounts;
  @override
  Map<PageOrientation, int>? get orientationCounts {
    final value = _orientationCounts;
    if (value == null) return null;
    if (_orientationCounts is EqualUnmodifiableMapView)
      return _orientationCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MergeStatistics(totalDocuments: $totalDocuments, totalPages: $totalPages, totalSize: $totalSize, estimatedOutputSize: $estimatedOutputSize, compressionRatio: $compressionRatio, estimatedTime: $estimatedTime, pageSizeDistribution: $pageSizeDistribution, orientationCounts: $orientationCounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MergeStatisticsImpl &&
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
                .equals(other._pageSizeDistribution, _pageSizeDistribution) &&
            const DeepCollectionEquality()
                .equals(other._orientationCounts, _orientationCounts));
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
      const DeepCollectionEquality().hash(_pageSizeDistribution),
      const DeepCollectionEquality().hash(_orientationCounts));

  /// Create a copy of MergeStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MergeStatisticsImplCopyWith<_$MergeStatisticsImpl> get copyWith =>
      __$$MergeStatisticsImplCopyWithImpl<_$MergeStatisticsImpl>(
          this, _$identity);
}

abstract class _MergeStatistics extends MergeStatistics {
  const factory _MergeStatistics(
          {final int totalDocuments,
          final int totalPages,
          final int totalSize,
          final int estimatedOutputSize,
          final double compressionRatio,
          final Duration estimatedTime,
          final Map<String, int>? pageSizeDistribution,
          final Map<PageOrientation, int>? orientationCounts}) =
      _$MergeStatisticsImpl;
  const _MergeStatistics._() : super._();

  @override
  int get totalDocuments;
  @override
  int get totalPages;
  @override
  int get totalSize;
  @override
  int get estimatedOutputSize;
  @override
  double get compressionRatio;
  @override
  Duration get estimatedTime;
  @override
  Map<String, int>? get pageSizeDistribution;
  @override
  Map<PageOrientation, int>? get orientationCounts;

  /// Create a copy of MergeStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MergeStatisticsImplCopyWith<_$MergeStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PageReorderOperation {
  String get pageId => throw _privateConstructorUsedError;
  int get fromIndex => throw _privateConstructorUsedError;
  int get toIndex => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageReorderOperationCopyWith<PageReorderOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageReorderOperationCopyWith<$Res> {
  factory $PageReorderOperationCopyWith(PageReorderOperation value,
          $Res Function(PageReorderOperation) then) =
      _$PageReorderOperationCopyWithImpl<$Res, PageReorderOperation>;
  @useResult
  $Res call(
      {String pageId, int fromIndex, int toIndex, bool isActive, bool isValid});
}

/// @nodoc
class _$PageReorderOperationCopyWithImpl<$Res,
        $Val extends PageReorderOperation>
    implements $PageReorderOperationCopyWith<$Res> {
  _$PageReorderOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = null,
    Object? fromIndex = null,
    Object? toIndex = null,
    Object? isActive = null,
    Object? isValid = null,
  }) {
    return _then(_value.copyWith(
      pageId: null == pageId
          ? _value.pageId
          : pageId // ignore: cast_nullable_to_non_nullable
              as String,
      fromIndex: null == fromIndex
          ? _value.fromIndex
          : fromIndex // ignore: cast_nullable_to_non_nullable
              as int,
      toIndex: null == toIndex
          ? _value.toIndex
          : toIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageReorderOperationImplCopyWith<$Res>
    implements $PageReorderOperationCopyWith<$Res> {
  factory _$$PageReorderOperationImplCopyWith(_$PageReorderOperationImpl value,
          $Res Function(_$PageReorderOperationImpl) then) =
      __$$PageReorderOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String pageId, int fromIndex, int toIndex, bool isActive, bool isValid});
}

/// @nodoc
class __$$PageReorderOperationImplCopyWithImpl<$Res>
    extends _$PageReorderOperationCopyWithImpl<$Res, _$PageReorderOperationImpl>
    implements _$$PageReorderOperationImplCopyWith<$Res> {
  __$$PageReorderOperationImplCopyWithImpl(_$PageReorderOperationImpl _value,
      $Res Function(_$PageReorderOperationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = null,
    Object? fromIndex = null,
    Object? toIndex = null,
    Object? isActive = null,
    Object? isValid = null,
  }) {
    return _then(_$PageReorderOperationImpl(
      pageId: null == pageId
          ? _value.pageId
          : pageId // ignore: cast_nullable_to_non_nullable
              as String,
      fromIndex: null == fromIndex
          ? _value.fromIndex
          : fromIndex // ignore: cast_nullable_to_non_nullable
              as int,
      toIndex: null == toIndex
          ? _value.toIndex
          : toIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PageReorderOperationImpl implements _PageReorderOperation {
  const _$PageReorderOperationImpl(
      {required this.pageId,
      required this.fromIndex,
      required this.toIndex,
      this.isActive = false,
      this.isValid = false});

  @override
  final String pageId;
  @override
  final int fromIndex;
  @override
  final int toIndex;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isValid;

  @override
  String toString() {
    return 'PageReorderOperation(pageId: $pageId, fromIndex: $fromIndex, toIndex: $toIndex, isActive: $isActive, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageReorderOperationImpl &&
            (identical(other.pageId, pageId) || other.pageId == pageId) &&
            (identical(other.fromIndex, fromIndex) ||
                other.fromIndex == fromIndex) &&
            (identical(other.toIndex, toIndex) || other.toIndex == toIndex) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pageId, fromIndex, toIndex, isActive, isValid);

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageReorderOperationImplCopyWith<_$PageReorderOperationImpl>
      get copyWith =>
          __$$PageReorderOperationImplCopyWithImpl<_$PageReorderOperationImpl>(
              this, _$identity);
}

abstract class _PageReorderOperation implements PageReorderOperation {
  const factory _PageReorderOperation(
      {required final String pageId,
      required final int fromIndex,
      required final int toIndex,
      final bool isActive,
      final bool isValid}) = _$PageReorderOperationImpl;

  @override
  String get pageId;
  @override
  int get fromIndex;
  @override
  int get toIndex;
  @override
  bool get isActive;
  @override
  bool get isValid;

  /// Create a copy of PageReorderOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageReorderOperationImplCopyWith<_$PageReorderOperationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BatchPageOperation {
  BatchOperationType get type => throw _privateConstructorUsedError;
  List<String> get pageIds => throw _privateConstructorUsedError;
  bool get isProcessing => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;
  Map<String, dynamic>? get parameters => throw _privateConstructorUsedError;

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchPageOperationCopyWith<BatchPageOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchPageOperationCopyWith<$Res> {
  factory $BatchPageOperationCopyWith(
          BatchPageOperation value, $Res Function(BatchPageOperation) then) =
      _$BatchPageOperationCopyWithImpl<$Res, BatchPageOperation>;
  @useResult
  $Res call(
      {BatchOperationType type,
      List<String> pageIds,
      bool isProcessing,
      int progress,
      Map<String, dynamic>? parameters});
}

/// @nodoc
class _$BatchPageOperationCopyWithImpl<$Res, $Val extends BatchPageOperation>
    implements $BatchPageOperationCopyWith<$Res> {
  _$BatchPageOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? pageIds = null,
    Object? isProcessing = null,
    Object? progress = null,
    Object? parameters = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BatchOperationType,
      pageIds: null == pageIds
          ? _value.pageIds
          : pageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchPageOperationImplCopyWith<$Res>
    implements $BatchPageOperationCopyWith<$Res> {
  factory _$$BatchPageOperationImplCopyWith(_$BatchPageOperationImpl value,
          $Res Function(_$BatchPageOperationImpl) then) =
      __$$BatchPageOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BatchOperationType type,
      List<String> pageIds,
      bool isProcessing,
      int progress,
      Map<String, dynamic>? parameters});
}

/// @nodoc
class __$$BatchPageOperationImplCopyWithImpl<$Res>
    extends _$BatchPageOperationCopyWithImpl<$Res, _$BatchPageOperationImpl>
    implements _$$BatchPageOperationImplCopyWith<$Res> {
  __$$BatchPageOperationImplCopyWithImpl(_$BatchPageOperationImpl _value,
      $Res Function(_$BatchPageOperationImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? pageIds = null,
    Object? isProcessing = null,
    Object? progress = null,
    Object? parameters = freezed,
  }) {
    return _then(_$BatchPageOperationImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BatchOperationType,
      pageIds: null == pageIds
          ? _value._pageIds
          : pageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$BatchPageOperationImpl implements _BatchPageOperation {
  const _$BatchPageOperationImpl(
      {required this.type,
      required final List<String> pageIds,
      this.isProcessing = false,
      this.progress = 0,
      final Map<String, dynamic>? parameters})
      : _pageIds = pageIds,
        _parameters = parameters;

  @override
  final BatchOperationType type;
  final List<String> _pageIds;
  @override
  List<String> get pageIds {
    if (_pageIds is EqualUnmodifiableListView) return _pageIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pageIds);
  }

  @override
  @JsonKey()
  final bool isProcessing;
  @override
  @JsonKey()
  final int progress;
  final Map<String, dynamic>? _parameters;
  @override
  Map<String, dynamic>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'BatchPageOperation(type: $type, pageIds: $pageIds, isProcessing: $isProcessing, progress: $progress, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchPageOperationImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._pageIds, _pageIds) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      const DeepCollectionEquality().hash(_pageIds),
      isProcessing,
      progress,
      const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchPageOperationImplCopyWith<_$BatchPageOperationImpl> get copyWith =>
      __$$BatchPageOperationImplCopyWithImpl<_$BatchPageOperationImpl>(
          this, _$identity);
}

abstract class _BatchPageOperation implements BatchPageOperation {
  const factory _BatchPageOperation(
      {required final BatchOperationType type,
      required final List<String> pageIds,
      final bool isProcessing,
      final int progress,
      final Map<String, dynamic>? parameters}) = _$BatchPageOperationImpl;

  @override
  BatchOperationType get type;
  @override
  List<String> get pageIds;
  @override
  bool get isProcessing;
  @override
  int get progress;
  @override
  Map<String, dynamic>? get parameters;

  /// Create a copy of BatchPageOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchPageOperationImplCopyWith<_$BatchPageOperationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
