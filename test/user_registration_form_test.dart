import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/extensions/validation_extensions.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('Email Validation', () {
    test('Invalid email', () {
      expect('invalid'.isValidEmail(), false);
      expect('m@'.isValidEmail(), false);
      expect('mahmoud'.isValidEmail(), false);
      expect('mah@com'.isValidEmail(), false);
    });

    test('Valid email', () {
      expect('mahmoud@fg.com'.isValidEmail(), true);
      expect('mahmoud@gmail.com'.isValidEmail(), true);
    });
  });

  group('Password Validation', () {
    test('Invalid password', () {
      expect('invalid'.isValidPassword(), false);
      expect('mfghytr@'.isValidPassword(), false);
      expect('mahmoud12'.isValidPassword(), false);
      expect('maoh12345@@'.isValidPassword(), false);
    });

    test('Valid password', () {
      expect('Mmaoh12345@@'.isValidPassword(), true);
      expect('Maoh12345@\$'.isValidPassword(), true);
    });
  });

  testWidgets('Form Validation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    final nameField = find.byType(TextFormField).at(0);
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);
    final buttonRegister = find.text('Register');

    await tester.tap(buttonRegister);

    await tester.pumpAndSettle();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);

    // Enter invalid data
    await tester.enterText(nameField, 'mahmoud');
    await tester.enterText(emailField, 'mahmoud');
    await tester.enterText(passwordField, 'maoh1234');
    await tester.enterText(confirmPasswordField, 'Mmaoh12345@@');

    await tester.tap(buttonRegister);

    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password is too weak'), findsOneWidget);

    // Enter valid data
    await tester.enterText(nameField, 'mahmoud');
    await tester.enterText(emailField, 'mahmoud@fg.com');
    await tester.enterText(passwordField, 'Mmaoh12345@@');
    await tester.enterText(confirmPasswordField, 'Mmaoh12345@@');

    await tester.tap(buttonRegister);

    await tester.pumpAndSettle();

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
