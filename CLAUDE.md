# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

A Flutter mobile app (package name `pringles_fine_wine`) that is a white-label storefront client for a WooCommerce store. It is branded as "Pringles Fine Wine" (Android `applicationId`/`namespace` and iOS bundle id: `com.pringlesfinewine.app`; display name set in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`). The app was originally built from a template previously branded "Zilly"/"Liquorly" — that rebrand (package name, app label, icons, Dart package name, WooCommerce credentials) has been completed. When rebranding again for a future client, package name, app label, icons (`assets/images/`, `flutter_launcher_icons` config in `pubspec.yaml`), and the WooCommerce credentials in `lib/utils/app_strings.dart` all need to move together.

The backing WooCommerce store domain lives in a single constant, `AppStrings.website` in `lib/utils/app_strings.dart` — `AppStrings.baseUrl` and the login endpoint are derived from it, so migrating to a new store domain only requires changing that one constant. The WooCommerce REST API consumer key/secret are also hardcoded constants in the same file (`AppStrings.key`/`secret`) — necessary since the app talks directly to WooCommerce's REST API with no backend proxy, but it means that key ships inside the compiled app and should be scoped to least-privilege in WooCommerce's REST API settings. There is no `.env`/dotenv setup and no payment gateway integration (Cash on Delivery only) — all endpoint/credential config is compiled into the app.

## Commands

This is a standard Flutter project — use the Flutter CLI, no custom build scripts.

- `flutter pub get` — install dependencies after cloning or changing `pubspec.yaml`
- `flutter run` — run on a connected device/emulator
- `flutter analyze` — static analysis (lint rules from `flutter_lints`, configured in `analysis_options.yaml`)
- `flutter test` — run all tests (single test file lives at `test/widget_test.dart`)
- `flutter test test/widget_test.dart` — run a single test file
- `flutter build apk` / `flutter build appbundle --build-name=X.Y.Z --build-number=N` — Android release build (see commented instructions at the top of `pubspec.yaml`)
- `flutter build ios` — iOS release build

Release signing for Android requires `android/key.properties` (gitignored). Copy `android/key.properties.example`, fill in keystore alias/passwords, and point `storeFile` at a keystore generated via the `keytool` command documented in that file. Without it, release builds fall back to debug signing (see `android/app/build.gradle`).

## Architecture

Layered structure: **Screens (View) → Controllers (GetX state) → Repositories → DioClient → WooCommerce REST API**, wired together at startup via `lib/di_container.dart`.

- **`lib/di_container.dart`**: single composition root. Registers `DioClient` and all `*Repo` classes as lazy singletons on `GetIt` (`sl`), and all `*Controller` classes on `GetX`'s `Get.lazyPut` (with `fenix: true`, so controllers are recreated automatically if disposed). Any new repo/controller must be registered here or it won't be injectable.
- **`lib/main.dart`**: app entry point. Initializes `StorageService` (GetStorage-backed key/value store for locale) and `TextDirectionController` (RTL/LTR) before `di.init()` runs, then boots `GetMaterialApp` with `AppTranslations` for i18n and locale/text-direction driven off those two services.
- **`lib/data/repository/*_repo.dart`**: one repo per API domain (auth, product, product category, product search, order, profile, general settings). Each method builds WooCommerce Basic Auth from `AppStrings.key`/`secret` inline, calls `DioClient`, and wraps the result in `ApiResponse.withSuccess`/`withError` — repos never throw, controllers check `apiResponse.response` vs `apiResponse.error`.
- **`lib/data/datasource/remote/dio/dio_client.dart`**: thin wrapper around a shared `Dio` instance (base URL, timeouts, default headers, `LoggingInterceptor`). `updateHeader(token, countryCode)` is how the bearer token gets refreshed after login.
- **`lib/data/datasource/remote/exception/api_error_handler.dart`**: maps `DioException` types/status codes to user-facing error strings; this is what populates `ApiResponse.error`.
- **`lib/controller/*_controller.dart`**: `GetxController`s holding UI state as plain fields (not `.obs` in most controllers — they call `update()` and views use `GetBuilder`, though `CartController` does use `Rx`/`.obs` with `GetX`/`Obx`). Pagination pattern (`currentPage`, `isMoreDataAvailable`) recurs across list-fetching controllers (e.g. `ProductController.getProductData`).
- **`lib/screen/*.dart`**: one file per app screen/route, navigated via GetX (`Get.to`, etc.) rather than named `MaterialApp` routes.
- **`lib/localization/`**: `AppTranslations` (GetX `Translations`) aggregates per-language maps from `language/{arabic,bengali,english}.dart`; `StorageService` (a `GetxService`) persists the chosen language/country code via `get_storage`; `rtl_controller.dart` (`TextDirectionController`) derives LTR/RTL from the stored locale and must be loaded before `GetMaterialApp` builds (see `main.dart`).
- **`lib/utils/`**: cross-cutting constants and widgets — `app_strings.dart` (API/base URLs, all secrets), `app_colors.dart` (theme colors), plus shared widgets like `local_widget.dart`, `photo_view_widget.dart`, and product-listing helpers (`featured_products.dart`, `on_sale.dart`, `top_rated.dart`).

Supported platforms: Android, iOS, web, Linux, macOS, Windows (all have generated platform folders), but the app is developed/tested primarily as a mobile app.
