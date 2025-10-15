## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

## Supabase
-keep class io.supabase.** { *; }

## Google Generative AI
-keep class com.google.ai.** { *; }

## Dio (HTTP client)
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

## Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

## SQLite
-keep class io.flutter.plugins.** { *; }

## Prevent issues with reflection
-keepattributes InnerClasses
-keepattributes EnclosingMethod

## Keep Kotlin Metadata
-keep class kotlin.Metadata { *; }

## Google Play Services (App Update & Review)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

## Flutter deferred components (ignorar si no se usan)
-dontwarn io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication

