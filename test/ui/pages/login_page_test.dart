import 'dart:async';

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
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<String?> mainErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    mainErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((realInvocation) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((realInvocation) => passwordErrorController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((realInvocation) => mainErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((realInvocation) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((realInvocation) => isLoadingController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester widgetTester) async {
    presenter = MockLoginPresenter();
    initStreams();
    mockStreams();

    final loginPage = MaterialApp(
        home: LoginPage(
      loginPresenter: presenter,
    ));
    await widgetTester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });
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

  testWidgets('Should present error if email is invalid', (widgetTester) async {
    await loadPage(widgetTester);

    emailErrorController.add('any error');
    await widgetTester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid',
      (widgetTester) async {
    await loadPage(widgetTester);

    emailErrorController.add(null);
    await widgetTester.pump();

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
  });

  testWidgets('Should present no error if email is valid',
      (widgetTester) async {
    await loadPage(widgetTester);

    emailErrorController.add('');
    await widgetTester.pump();

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
  });

  testWidgets('Should present error if password is invalid',
      (widgetTester) async {
    await loadPage(widgetTester);

    passwordErrorController.add('any error');
    await widgetTester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present error if password is invalid',
      (widgetTester) async {
    await loadPage(widgetTester);

    passwordErrorController.add('');
    await widgetTester.pump();

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
  });

  testWidgets('Should enable button if form is valid', (widgetTester) async {
    await loadPage(widgetTester);

    isFormValidController.add(true);

    await widgetTester.pump();

    final filledButton =
        widgetTester.widget<FilledButton>(find.byType(FilledButton));

    expect(filledButton.onPressed, isNotNull);
  });

  testWidgets('Should enable button if form is valid', (widgetTester) async {
    await loadPage(widgetTester);

    isFormValidController.add(false);

    await widgetTester.pump();

    final filledButton =
        widgetTester.widget<FilledButton>(find.byType(FilledButton));

    expect(filledButton.onPressed, isNull);
  });

  testWidgets('Should call authetication on form submit', (widgetTester) async {
    await loadPage(widgetTester);

    isFormValidController.add(true);

    await widgetTester.pump();
    await widgetTester.tap(find.byType(FilledButton));
    await widgetTester.pump();

    verify(presenter.auth()).called(1);
  });

  testWidgets('Should present loading', (widgetTester) async {
    await loadPage(widgetTester);

    isLoadingController.add(true);

    await widgetTester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (widgetTester) async {
    await loadPage(widgetTester);

    isLoadingController.add(true);

    await widgetTester.pump();

    isLoadingController.add(false);

    await widgetTester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if authenticaiton fails',
      (widgetTester) async {
    await loadPage(widgetTester);

    mainErrorController.add('main error');

    await widgetTester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (widgetTester) async {
    await loadPage(widgetTester);
    addTearDown(() {
      verify(presenter.dispose());
    });
  });
}
