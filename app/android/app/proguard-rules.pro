# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Dart FFI rules
-keep class dart.ffi.** { *; }

# OpenCV dart native library rules
-keep class org.opencv.** { *; }
-keepclassmembers class * {
    native <methods>;
}

# ML Kit rules
-keep class com.google.android.gms.** { *; }
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.android.gms.**

# Camera rules
-keep class androidx.camera.** { *; }
-dontwarn androidx.camera.**

# Image processing rules
-keep class androidx.exifinterface.** { *; }

# JSON serialization rules
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }

# Retrofit/HTTP rules (not used but future-proofing)
-dontwarn okio.**
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }

# Riverpod state management
-keep class com.riverpod.** { *; }

# General Android rules
-keepclassmembers class * extends android.app.Activity {
    public void *(android.view.View);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# PDF processing rules
-keep class com.tom_roush.pdfbox.** { *; }
-dontwarn com.tom_roush.pdfbox.**

# ZIP/Archive rules
-keep class java.util.zip.** { *; }

# Reflection rules for Dart/Flutter plugins
-keepattributes *Annotation*
-keep class kotlin.reflect.** { *; }
-dontwarn kotlin.reflect.**

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Remove debug logs in release
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}