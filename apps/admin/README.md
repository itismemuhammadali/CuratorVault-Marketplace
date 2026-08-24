# vintage_app

Flutter app for antique discovery, AI-assisted scanning, and marketplace/user flows.

## What this project currently is

- App type: multi-screen Flutter app using `go_router` with a shell layout for user flow pages.
- State approach: mostly local widget state + a shared `HeaderController` (`ValueNotifier`) for global app bar config.
- Styling approach: centralized constants in `AppColors`, `TextStyles`, `AppImages`, with `flutter_screenutil` sizing (`.w`, `.h`, `.sp`, `.r`) throughout.
- Platforms: Android, iOS, web, Windows, macOS, Linux (camera scanning is mobile-only in current implementation).

## Stack and key packages

From `pubspec.yaml`:

- Flutter / Dart (`sdk: ^3.10.7`)
- `go_router` for routing
- `flutter_screenutil` for responsive sizing
- `camera` for live scanner preview and capture
- `image_picker` for profile image selection
- `smooth_page_indicator`, `font_awesome_flutter`

## Project structure

```text
lib/
  main.dart
  core/
    routes.dart
    theme/
      app_colors.dart
      text_styles.dart
      images.dart
      buttons/custom_button.dart
    components/
      global_layout/main_layout.dart
      global_header/
      global_footer/
      includes/
      cards/
  features/
    intro/
    auth_screens/
    dealer_flow/
      home/
      my_finds/
      marketplace/
      profile/
      scan/
      events/
    messages/
```

## App bootstrap and runtime flow

1. `lib/main.dart`
   - Initializes `ScreenUtilInit(designSize: Size(440, 956))`.
   - Uses `MaterialApp.router(routerConfig: Routes.routes)`.
   - Wraps the app with `HeaderControllerProvider` so screens can update global header config.
   - Clamps text scaling via `MediaQuery.withClampedTextScaling(min: 1.0, max: 1.2)`.

2. `lib/core/routes.dart`
   - Defines all app routes via `GoRouter`.
   - Uses `ShellRoute` to wrap most user-flow routes in `GlobalLayout`.
   - Exception: `/user/scan` and `/user/scan/result` bypass shell and render full-screen scanner UI.
   - Uses a shared slide transition helper (`slidePage`) for routed pages.

3. `lib/core/components/global_layout/main_layout.dart`
   - Renders `Scaffold(appBar: SimpleHeader(...), body: child, bottomNavigationBar: GlobalFooter(...))`.
   - Header is dynamic and controlled by current screen via `HeaderController`.

## Routing details (current state)

Current major routes in `lib/core/routes.dart`:

- `/` -> Splash
- `/introSlider` -> Intro carousel
- `/login` -> Auth tabs screen
- `/forgotPassword`, `/checkEmail`, `/newPassword`
- Shell-wrapped user routes:
  - `/homeScreen`
  - `/user/my-finds`
  - `/user/market`
  - `/user/profile`
  - `/user/scan`
  - `/user/scan/result`
- Standalone:
  - `/market/product/:id`
  - `/user/editprofile`
  - `/events`
  - `/single_message`

Navigation patterns used in code:

- `context.go(...)` for replacing/primary navigation (intro/auth/footer tabs).
- `context.push(...)` for drill-down/detail flows (messages, product detail, edit profile, etc.).
- Query params example: `/checkEmail?email=...`.
- Path params example: `/market/product/:id`.
- `state.extra` example: scan result image path passed to `/user/scan/result`.

## Styling system

### Colors

- Centralized in `lib/core/theme/app_colors.dart` (`AppColors`).
- Core palette is reused consistently: gradient header colors, `redButton`, neutral text, and surface colors.

### Typography

- Centralized in `lib/core/theme/text_styles.dart` (`TextStyles`).
- Font family defaults to `Inter` for all predefined styles.
- Additional font (`Montserrat`) is registered in `pubspec.yaml` but not broadly used in current components.

### Assets

- Centralized path constants in `lib/core/theme/images.dart` (`AppImages`).
- Images/icons referenced via constants across screens and shared components.

### Sizing

- Uses `flutter_screenutil` globally.
- Spacing, radii, icon sizes, and font sizes are mostly responsive via `.w`, `.h`, `.r`, `.sp`.

## Layout and shared components

### Global header

- `SimpleHeader` (`lib/core/components/global_header/global_header.dart`) renders gradient app bar with optional back affordance and optional bottom widget area.
- Individual shell pages set header content at runtime by updating:
  - `HeaderControllerProvider.of(context).value = HeaderConfig(...)`
- Common pattern used in pages: set header once in `didChangeDependencies` guarded by `_headerSet` and `addPostFrameCallback`.

### Global footer

- `GlobalFooter` (`lib/core/components/global_footer/global_footer.dart`) builds nav based on `FooterFlowConfig`.
- User flow config exists and is active in `GlobalLayout` (`FooterFlow.user`).
- Seller/admin footer configs exist as data but corresponding routes are not fully implemented in current router.

### Reusable UI primitives

- `AppTextField`: configurable text field with optional label/prefix/suffix and style hooks.
- `CustomButton`: shared button wrapper used across auth/user screens.
- `AppItemCard`: flexible grid/list card with badges, confidence UI, and action controls.
- `HorizontalChipBar`: shared horizontal filter chips.

## Feature modules behavior

- `features/intro`: splash -> intro slider -> login flow.
- `features/auth_screens`: login/register tabs + forgot/check/new password screens under a dedicated auth layout.
- `features/dealer_flow/home`: sets personalized header, shows highlights/events/recent scans.
- `features/dealer_flow/my_finds`: toggles grid/list display using shared card component.
- `features/dealer_flow/marketplace`: filter chips + grid cards + product detail route.
- `features/dealer_flow/profile`: profile dashboard/settings; edit profile is standalone screen with its own header.
- `features/dealer_flow/scan`: full-screen camera preview and capture; routes to result with image path.
- `features/messages`: single chat-style conversation screen with custom bottom message bar.

## Commands

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

## Contributor guidelines for this codebase

When creating or modifying features, follow these patterns to stay consistent.

1. Routing
   - Add route in `lib/core/routes.dart`.
   - Decide whether route should be shell-wrapped (`GlobalLayout`) or full-screen standalone.
   - Use `context.go` for tab/root jumps, `context.push` for detail/subflows.

2. Header behavior
   - For shell pages, configure header with `HeaderControllerProvider` + `HeaderConfig`.
   - Keep header setup in lifecycle-safe place (`didChangeDependencies` + post-frame) if needed.

3. Styling
   - Reuse `AppColors`, `TextStyles`, `AppImages`; avoid hardcoded repeated values.
   - Continue using `ScreenUtil` dimensions for responsive behavior.

4. Shared components first
   - Prefer extending/reusing `AppItemCard`, `AppTextField`, `CustomButton`, `HorizontalChipBar` before introducing one-off widgets.

5. Footer compatibility
   - If adding a new user tab destination, ensure route path and footer config path stay aligned.

6. Platform-sensitive features
   - Scanner flow is currently Android/iOS-first. Keep graceful fallback/error messaging for unsupported targets.

## Known implementation notes

- `lib/core/theme/buttons.dart` and `lib/core/components/global_footer/presistent_navbar.dart` are currently empty placeholders.
- Some route naming is mixed (camelCase and kebab-case); preserve existing behavior unless doing a deliberate route normalization task.
- Several screens currently use static/mock data; wire to backend/state management as a separate concern when needed.

## Future tasking baseline

Use this README as the working engineering baseline for future modifications in this repository:

- preserve current architecture (router + shell + header controller)
- preserve design language (color/text/image tokens + screenutil scaling)
- preserve navigation semantics (`go` vs `push`)
- prefer extending shared components over duplicating UI logic
