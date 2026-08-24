import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:vintage_app/core/components/global_header/transparent_header.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/buttons/custom_button.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class AiScannerView extends StatefulWidget {
  const AiScannerView({super.key});

  @override
  State<AiScannerView> createState() => _AiScannerViewState();
}

class _AiScannerViewState extends State<AiScannerView> {
  bool _isBusy = false;
  bool _isAnalyzing = false;
  String? _cameraError;

  CameraController? _cameraController;
  Future<void>? _cameraInit;
  bool _isLiveCamera = false;

  bool get _cameraSupportedOnThisPlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  void _closeScan(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/homeScreen');
  }

  void _showCameraSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLiveCamera();
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startLiveCamera() async {
    if (_isBusy || _isAnalyzing) return;
    setState(() {
      _isBusy = true;
      _cameraError = null;
    });

    try {
      if (!_cameraSupportedOnThisPlatform) {
        setState(() {
          _cameraError =
              'Camera preview works only on Android/iOS. Please run on a phone or emulator.';
          _isLiveCamera = false;
        });
        _showCameraSnack(_cameraError!);
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _cameraError = 'No camera found on this device.';
          _isLiveCamera = false;
        });
        _showCameraSnack(_cameraError!);
        return;
      }

      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      setState(() {
        _cameraController?.dispose();
        _cameraController = controller;
        _cameraInit = controller.initialize();
        _isLiveCamera = true;
      });

      await _cameraInit;
    } on CameraException catch (e) {
      if (!mounted) return;
      final isDenied =
          e.code == 'CameraAccessDenied' ||
          e.code == 'CameraAccessDeniedWithoutPrompt';
      final message = isDenied
          ? 'Camera permission denied. Enable it in Settings and try again.'
          : 'Camera error: ${e.description ?? e.code}';
      setState(() {
        _cameraError = message;
        _isLiveCamera = false;
      });
      _showCameraSnack(message);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError =
            'Could not start camera preview. Please fully restart the app after flutter clean.\nDetails: ${e.runtimeType}';
        _isLiveCamera = false;
      });
      _showCameraSnack(_cameraError!);
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _startScan(BuildContext context) async {
    if (_isBusy || _isAnalyzing) return;

    final router = GoRouter.of(context);

    if (!_isLiveCamera || _cameraController == null) {
      await _startLiveCamera();
      return;
    }

    final controller = _cameraController;
    if (controller == null) return;

    setState(() {
      _isBusy = true;
      _cameraError = null;
    });

    try {
      await _cameraInit;

      try {
        await controller.setFocusMode(FocusMode.auto);
        await controller.setExposureMode(ExposureMode.auto);
        await controller.setFocusPoint(const Offset(0.5, 0.5));
      } catch (_) {
        // Focus APIs aren't supported on all devices.
      }

      // Small delay to allow focus to settle.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final picture = await controller.takePicture();
      final imagePath = picture.path;

      if (!mounted) return;
      setState(() {
        _isAnalyzing = true;
      });

      await Future<void>.delayed(const Duration(milliseconds: 1600));
      if (!mounted) return;

      await controller.dispose();
      if (!mounted) return;
      setState(() {
        _cameraController = null;
        _cameraInit = null;
        _isLiveCamera = false;
        _isAnalyzing = false;
      });

      if (!mounted) return;
      router.push('/user/scan/result', extra: imagePath);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError =
            'Scan failed. Please restart the app and try again.\nDetails: ${e.runtimeType}';
      });
      _showCameraSnack(_cameraError!);
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.lightText;
    final border = AppColors.crossIconColor;

    return TransparentHeader(
      backgroundColor: bg,
      extendBodyBehindAppBar: false,
      showBackButton: false,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Ai Scanner',
          style: TextStyles.semiBoldMedium.copyWith(
            color: border,
            fontSize: 18.sp,
          ),
        ),
      ),
      trailing: GestureDetector(
        onTap: () => _closeScan(context),
        child: Container(
          height: 40.w,
          width: 40.w,
          decoration: BoxDecoration(color: border, shape: BoxShape.circle),
          child: Center(
            child: _CloseXIcon(color: bg, size: 14.w, strokeWidth: 2.2.w),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-page live camera.
            if (_isLiveCamera)
              FutureBuilder<void>(
                future: _cameraInit,
                builder: (context, snapshot) {
                  final controller = _cameraController;
                  if (controller == null) return const SizedBox.shrink();
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox.shrink();
                  }
                  final previewSize = controller.value.previewSize;
                  if (previewSize == null) return const SizedBox.shrink();
                  return FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: previewSize.height,
                      height: previewSize.width,
                      child: CameraPreview(controller),
                    ),
                  );
                },
              )
            else
              ColoredBox(color: bg),

            // Foreground UI.
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 28.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 360.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _isAnalyzing
                          ? const _AnalyzingContent()
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 320.w,
                                  height: 320.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28.r),
                                    border: Border.all(
                                      color: border,
                                      width: 2.w,
                                    ),
                                  ),
                                ),
                                if (_isBusy && !_isLiveCamera)
                                  SizedBox(
                                    height: 28.w,
                                    width: 28.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.6.w,
                                      valueColor: AlwaysStoppedAnimation(
                                        border,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                      SizedBox(height: 26.h),
                      if (!_isAnalyzing) ...[
                        Text(
                          'Position antique within frame',
                          style: TextStyles.semiBoldMedium.copyWith(
                            color: border,
                            fontSize: 18.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Ensure good lighting for best results',
                          style: TextStyles.regularSmall.copyWith(
                            color: border.withValues(alpha: 0.70),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: 26.h),
                      if (!_isAnalyzing && _cameraError != null) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            _cameraError!,
                            textAlign: TextAlign.center,
                            style: TextStyles.regularSmall.copyWith(
                              color: border.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                      ],
                      if (!_isAnalyzing)
                        CustomButton(
                          height: 56.h,
                          width: 240.w,
                          borderRadius: 12.r,
                          btnColor: AppColors.redButton,
                          onTap: () => _startScan(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(

                                'assets/icons/camera_add_icon.svg',
                                width: 18.w,
                                height: 18.h,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.bodyBg,
                                  BlendMode.srcIn,
                                ),
                              ),

                              SizedBox(width: 10.w),
                              Text(
                                _isBusy ? 'Starting...' : 'Start Scan',
                                style: TextStyles.semiBoldMedium.copyWith(
                                  color: AppColors.bodyBg,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyzingContent extends StatelessWidget {
  const _AnalyzingContent();

  @override
  Widget build(BuildContext context) {
    final border = AppColors.darkText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 320.w,
          height: 320.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: border, width: 2.w),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.lightText.withValues(alpha: 0.55),
                AppColors.redButton.withValues(alpha: 0.28),
              ],
            ),
          ),
          child: Center(
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: border.withValues(alpha: 0.55),
                  width: 1.2.w,
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.camImg,
                  height: 34.h,
                  width: 34.w,
                  color: border.withValues(alpha: 0.70),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 26.h),
        Text(
          'Analyzing Antique...',
          textAlign: TextAlign.center,
          style: TextStyles.semiBoldMedium.copyWith(
            color: border,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Ai is processing details',
          textAlign: TextAlign.center,
          style: TextStyles.regularSmall.copyWith(
            color: border.withValues(alpha: 0.72),
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10.w,
              width: 10.w,
              decoration: BoxDecoration(
                color: AppColors.redButton.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Processing...',
              style: TextStyles.regularSmall.copyWith(
                color: border.withValues(alpha: 0.82),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CloseXIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const _CloseXIcon({
    required this.color,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CloseXIconPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _CloseXIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CloseXIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final inset = size.width * 0.18;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloseXIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
