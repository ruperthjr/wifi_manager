import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nestnet/app.dart';

void main() {
  testWidgets('NestNet app launches and shows SplashScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: NestNetApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}