import 'package:flutter_test/flutter_test.dart';
import 'package:semicircular_stage_progress/semicircular_stage_progress.dart';

void main() {
  test(
    'Throws assertion error if currentStage is greater than totalStages',
    () {
      expect(
        () => SemicircularStageProgress(totalStages: 5, currentStage: 6),
        throwsA(isA<AssertionError>()),
      );
    },
  );
}
