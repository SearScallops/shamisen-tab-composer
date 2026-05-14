import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:shamisen_tab_composer/main.dart';

void main() {
  testWidgets('Shamisen Tab Composer starts without crashing',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));

    await tester.pumpWidget(const ShamisenTabApp());
    await tester.pumpAndSettle();

    expect(find.text('Shamisen Tab Composer Alpha 0.1'), findsOneWidget);
    expect(find.text('Song Settings'), findsOneWidget);
    expect(find.text('Note Input'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}