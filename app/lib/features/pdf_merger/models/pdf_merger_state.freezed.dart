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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease use the `default` constructor instead.');

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

  @JsonKey(ignore: true)
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
  $PdfPermissionsCopyWith<$Res> get permissions;
  $PdfMergeOptionsCopyWith<$Res> get mergeOptions;
}

/// @nodoc
class _$PdfMergerStateCopyWithImpl<$Res, $Val extends PdfMergerState>
    implements $PdfMergerStateCopyWith<$Res> {
  _$PdfMergerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
}

/// @nodoc
abstract class _$$PdfMergerStateImplCopyWith<$Res>
    implements $PdfMergerStateCopyWith<$Res> {
  factory _$$PdfMergerStateImplCopyWith(_$PdfMergerStateImpl value,
          $Res Function(_$PdfMergerStateImpl) then) =
      __$$PdfMergerStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PdfMergerStateImplCopyWithImpl<$Res>
    extends _$PdfMergerStateCopyWithImpl<$Res, _$PdfMergerStateImpl>
    implements _$$PdfMergerStateImplCopyWith<$Res> {
  __$$PdfMergerStateImplCopyWithImpl(
      _$PdfMergerStateImpl _value, $Res Function(_$PdfMergerStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PdfMergerStateImpl implements _PdfMergerState {
  const _$PdfMergerStateImpl(
      {this.documents = const [],
      this.pages = const [],
      this.isProcessing = false,
      this.processingProgress = 0,
      this.processingErrors = const [],
      this.selectedDocument,
      this.selectedPage,
      this.showPasswordDialog = false,
      this.showAdvancedSettings = false,
      this.enableEncryption = false,
      this.encryptionPassword = '',
      this.permissions = const PdfPermissions(),
      this.mergeOptions = const PdfMergeOptions(),
      this.mergedPdfData,
      this.outputFileName = ''});

  final List<PdfDocument> _documents;
  @override
  @JsonKey()
  List<PdfDocument> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    return EqualUnmodifiableListView(_documents);
  }

  final List<PdfPageThumbnail> _pages;
  @override
  @JsonKey()
  List<PdfPageThumbnail> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
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

  @JsonKey(ignore: true)
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
  @override
  @JsonKey(ignore: true)
  _$$PdfMergerStateImplCopyWith<_$PdfMergerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// Simplified implementations for the other classes
typedef $PdfDocumentCopyWith<$Res> = Function(PdfDocument);
typedef $PdfPageThumbnailCopyWith<$Res> = Function(PdfPageThumbnail);
typedef $PdfPermissionsCopyWith<$Res> = Function(PdfPermissions);
typedef $PdfMergeOptionsCopyWith<$Res> = Function(PdfMergeOptions);