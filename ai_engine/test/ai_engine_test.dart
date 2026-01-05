import 'package:flutter_test/flutter_test.dart';

import 'package:ai_engine/ai_engine.dart';

void main() {
  test('AiEngine can be instantiated', () {
    final engine = AiEngine();
    expect(engine, isNotNull);
  });
}
