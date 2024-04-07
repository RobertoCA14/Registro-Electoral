import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test text widget with "0"', (WidgetTester tester) async {
    // Infla el widget que estás probando
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Text('0')),
    ));

    // Busca el widget Text con el texto "0"
    expect(find.text('0'), findsOneWidget);
  });
}
