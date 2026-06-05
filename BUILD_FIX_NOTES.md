# BUILD_FIX — How the Android build was repaired

**Problem:** Flutter 3.41 (modern) removed the legacy Android embedding-v1 API
(`PluginRegistry.Registrar`). Supabase v1 (`supabase_flutter ^1.10`) dragged in
old plugins that still reference it, so Gradle failed with `cannot find symbol`.

**Fix (all committed):**
1. Upgraded `supabase_flutter` 1.10 → 2.5.6 (Dart code was already v2-compatible).
2. Pinned Groovy-based, embedding-v2 plugin versions via `dependency_overrides`:
   - shared_preferences_android 2.4.10
   - url_launcher_android 6.3.14
   - path_provider_android 2.2.15
   (Newer .kts versions of these need AGP 8.13/Kotlin 2.3 — too new.)
3. Bumped Android toolchain to match: AGP 8.6.0, Kotlin 2.1.0, Gradle 8.9, NDK 26.1.10909125.
4. Removed orphaned `lib/screens/login_screen.dart` (replaced by org picker flow).

**Result:** `flutter run` builds and launches cleanly on emulator.
If you hit build issues: `flutter clean && flutter pub get && flutter run`.
