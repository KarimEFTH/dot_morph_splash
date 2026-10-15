import 'package:flutter_test/flutter_test.dart';

import 'package:dot_morph_splash/main.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DotMorphSplashApp());
    // L'app demarre sans erreur
    expect(tester.takeException(), isNull);
  });
}
