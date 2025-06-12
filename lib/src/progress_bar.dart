import 'package:flutter/material.dart';
import 'dart:math';

class SemicircularStageProgress extends StatelessWidget {
  /// Required: Total number of stages to display
  final int totalStages;

  /// Required: Current active stage (1-based index)
  final int currentStage;

  /// Width of the widget (default: 300)
  final double? width;

  /// Height of the widget (default: 200)
  final double? height;

  /// Thickness of each arc segment (default: 14)
  final double? arcWidth;

  /// Padding around the semicircle (default: 10)
  final double? padding;

  /// How much of each arc is visible (0.0 to 1.0, default: 0.75)
  final double? gapFactor;

  /// Color for completed stages (default: Color(0xff7FE47E))
  final Color? completedColor;

  /// Color for current stage (default: Color(0xff309646))
  final Color? currentColor;

  /// Color for future stages (default: Colors.grey.shade300)
  final Color? futureColor;

  /// Whether to show indicator dot for current stage (default: true)
  final bool? showCurrentIndicator;

  /// Size of the outer indicator dot (default: 12)
  final double? indicatorOuterSize;

  /// Size of the inner indicator dot (default: 8)
  final double? indicatorInnerSize;

  /// Color of the outer indicator dot (default: completedColor)
  final Color? indicatorOuterColor;

  /// Color of the inner indicator dot (default: Colors.white)
  final Color? indicatorInnerColor;

  /// Text to display below the indicator (default: None)
  final String? stageText;

  /// Style for the stage text (default: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
  final TextStyle? stageTextStyle;

  /// Text to display status below stage text (default: None)
  final String? statusText;

  /// Style for the status text (default: TextStyle(fontSize: 18, color: completedColor or currentColor))
  final TextStyle? statusTextStyle;

  /// Space between the indicator and text (default: 20)
  final double? textSpacing;

  const SemicircularStageProgress({
    super.key,
    required this.totalStages,
    required this.currentStage,
    this.width,
    this.height,
    this.arcWidth,
    this.padding,
    this.gapFactor,
    this.completedColor,
    this.currentColor,
    this.futureColor,
    this.showCurrentIndicator,
    this.indicatorOuterSize,
    this.indicatorInnerSize,
    this.indicatorOuterColor,
    this.indicatorInnerColor,
    this.stageText,
    this.stageTextStyle,
    this.statusText,
    this.statusTextStyle,
    this.textSpacing,
  }) : assert(
         currentStage > 0 && currentStage <= totalStages,
         'currentStage must be between 1 and totalStages',
       ),
       assert(totalStages > 0, 'totalStages must be greater than 0');

  @override
  Widget build(BuildContext context) {
    final int completedStages = currentStage - 1;
    final bool isCompleted = currentStage <= completedStages;

    final bool showStageText = stageText != null;
    final bool showStatusText = statusText != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width ?? 300,
          height: height ?? 200,
          child: CustomPaint(
            painter: _StageArcPainter(
              totalStages: totalStages,
              currentStage: currentStage,
              arcWidth: arcWidth ?? 14,
              padding: padding ?? 10,
              gapFactor: gapFactor ?? 0.75,
              completedColor: completedColor ?? const Color(0xff7FE47E),
              currentColor: currentColor ?? const Color(0xff309646),
              futureColor: futureColor ?? Colors.grey.shade300,
              showCurrentIndicator: showCurrentIndicator ?? true,
              indicatorOuterSize: indicatorOuterSize ?? 12,
              indicatorInnerSize: indicatorInnerSize ?? 8,
              indicatorOuterColor:
                  indicatorOuterColor ??
                  completedColor ??
                  const Color(0xff7FE47E),
              indicatorInnerColor: indicatorInnerColor ?? Colors.white,
            ),
          ),
        ),
        SizedBox(height: textSpacing ?? 20),
        if (showStageText)
          Text(
            stageText ?? 'Stage $currentStage',
            style:
                stageTextStyle ??
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        if (showStatusText)
          Text(
            statusText ?? (isCompleted ? 'Completed' : 'In Progress'),
            style:
                statusTextStyle ??
                TextStyle(
                  fontSize: 18,
                  color: isCompleted
                      ? completedColor ?? const Color(0xff7FE47E)
                      : currentColor ?? const Color(0xff309646),
                ),
          ),
      ],
    );
  }
}

class _StageArcPainter extends CustomPainter {
  final int totalStages;
  final int currentStage;
  final double arcWidth;
  final double padding;
  final double gapFactor;
  final Color completedColor;
  final Color currentColor;
  final Color futureColor;
  final bool showCurrentIndicator;
  final double indicatorOuterSize;
  final double indicatorInnerSize;
  final Color indicatorOuterColor;
  final Color indicatorInnerColor;

  const _StageArcPainter({
    required this.totalStages,
    required this.currentStage,
    required this.arcWidth,
    required this.padding,
    required this.gapFactor,
    required this.completedColor,
    required this.currentColor,
    required this.futureColor,
    required this.showCurrentIndicator,
    required this.indicatorOuterSize,
    required this.indicatorInnerSize,
    required this.indicatorOuterColor,
    required this.indicatorInnerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final int completedStages = currentStage - 1;
    final double radius = (size.width / 2) - padding;
    final Offset center = Offset(size.width / 2, size.height - arcWidth);
    final double totalArc = pi;
    final double arcSpacing = totalArc / totalStages;
    final double arcSweep = arcSpacing * gapFactor;
    final double gap = arcSpacing * (1 - gapFactor) / 2;

    for (int i = 0; i < totalStages; i++) {
      final Paint paint = Paint()
        ..strokeWidth = arcWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (i < completedStages) {
        paint.color = completedColor;
      } else if (i == completedStages) {
        paint.color = currentColor;
      } else {
        paint.color = futureColor;
      }

      final double startAngle = pi + i * arcSpacing + gap;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcSweep,
        false,
        paint,
      );

      if (showCurrentIndicator && i + 1 == currentStage) {
        final double angle = startAngle + arcSweep / 2;
        final Offset circleOffset = Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        );

        canvas.drawCircle(
          circleOffset,
          indicatorOuterSize,
          Paint()..color = indicatorOuterColor,
        );
        canvas.drawCircle(
          circleOffset,
          indicatorInnerSize,
          Paint()..color = indicatorInnerColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StageArcPainter oldDelegate) {
    return oldDelegate.totalStages != totalStages ||
        oldDelegate.currentStage != currentStage ||
        oldDelegate.arcWidth != arcWidth ||
        oldDelegate.padding != padding ||
        oldDelegate.gapFactor != gapFactor ||
        oldDelegate.completedColor != completedColor ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.futureColor != futureColor ||
        oldDelegate.showCurrentIndicator != showCurrentIndicator ||
        oldDelegate.indicatorOuterSize != indicatorOuterSize ||
        oldDelegate.indicatorInnerSize != indicatorInnerSize ||
        oldDelegate.indicatorOuterColor != indicatorOuterColor ||
        oldDelegate.indicatorInnerColor != indicatorInnerColor;
  }
}
