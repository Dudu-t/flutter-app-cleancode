import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs/ui/pages/pages.dart';

void main() {
  Future<void> loadPage(WidgetTester widgetTester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await widgetTester.pumpWidget(loginPage);
  }

  testWidgets('Should load with correct initial state', (widgetTester) async {
    await loadPage(widgetTester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(
        Text,
      ),
    );
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the hint text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(
        Text,
      ),
    );
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the hint text',
    );

    final button = widgetTester.widget<FilledButton>(find.byType(FilledButton));

    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values', (widgetTester) async {
    await loadPage(widgetTester);
  });
}
