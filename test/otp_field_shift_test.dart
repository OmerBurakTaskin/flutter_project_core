import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/widgets/otp_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('typed digit does not scroll off-center after focus moves to the next field', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: OtpField(onCompleted: (_) {}),
          ),
        ),
      ),
    );

    final editableTextState = tester.state<EditableTextState>(find.byType(EditableText).first);
    final renderEditable = editableTextState.renderEditable;

    await tester.enterText(find.byType(TextFormField).first, '1');
    await tester.pumpAndSettle();

    FocusManager.instance.primaryFocus?.nextFocus();
    await tester.pumpAndSettle();

    expect(renderEditable.offset.pixels, 0.0);
  });
}
