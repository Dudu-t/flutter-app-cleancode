import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fordevs/ui/pages/pages.dart';

@GenerateNiceMocks([MockSpec<LoginPresenter>()])
import 'login_page_test.mocks.dart';

void main() {
  late LoginPresenter presenter;

  Future<void> loadPage(WidgetTester widgetTester) async {
    presenter = MockLoginPresenter();
    final loginPage = MaterialApp(
        home: LoginPage(
      loginPresenter: presenter,
    ));
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

    final email = faker.internet.email();

    await widgetTester.enterText(find.bySemanticsLabel('Email'), email);

    verify(presenter.validateEmail(email));

    final password = faker.internet.password();

    await widgetTester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(presenter.validatePassword(password));
  });
}
