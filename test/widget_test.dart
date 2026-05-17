import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shamisen_tab_composer/main.dart';

void main() {
  testWidgets('Shamisen Tab Composer starts without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ShamisenTabApp());

    expect(find.text(appFullTitle), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(EditorScreen), findsOneWidget);
  });
}
