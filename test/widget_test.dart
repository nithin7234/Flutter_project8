// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_8/main.dart';

void main() {
  testWidgets('Product search UI present', (WidgetTester tester) async {
    // Build the product search screen.
    await tester.pumpWidget(const MaterialApp(home: ProductSearchScreen()));

    // Verify that the input field and search button are present.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Enter product name'), findsOneWidget);
  });
}
