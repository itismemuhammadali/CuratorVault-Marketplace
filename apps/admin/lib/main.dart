import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/routes.dart';

import 'core/components/global_header/header_controller.dart';
import 'core/components/global_header/header_controller_provider.dart';

import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// 4️⃣ Create controller once
  static final HeaderController _headerController = HeaderController();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      fontSizeResolver: (fontSize, instance) {
        return math.max(fontSize.toDouble(), instance.setWidth(fontSize));
      },
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: Routes.routes,
          builder: (context, widget) {
            return HeaderControllerProvider(
              controller: _headerController,
              child: MediaQuery.withClampedTextScaling(
                minScaleFactor: 1.0,
                maxScaleFactor: 1.2,
                child: widget!,
              ),
            );
          },
        );
      },
    );
  }
}
