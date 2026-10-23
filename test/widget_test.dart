import 'package:berkcuce_hw1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _search(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pumpAndSettle();
}

Future<void> _openFirstCard(WidgetTester tester) async {
  await tester.tap(find.text('Details').first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Explore lists events and search works with clear button', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusEventApp());
    expect(find.text('7 matching events'), findsOneWidget);

    await _search(tester, '  jAzZ ');
    expect(find.text('1 matching event'), findsOneWidget);
    expect(find.text('Student Jazz Night'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('7 matching events'), findsOneWidget);
  });

  testWidgets('Empty search result shows a message', (tester) async {
    await tester.pumpWidget(const CampusEventApp());
    await _search(tester, 'zzz-no-such-event');
    expect(find.text('No matching events'), findsOneWidget);

    await tester.tap(find.text('Clear search and filters'));
    await tester.pumpAndSettle();
    expect(find.text('7 matching events'), findsOneWidget);
  });

  testWidgets('Full event cannot be joined', (tester) async {
    await tester.pumpWidget(const CampusEventApp());
    await _search(tester, 'vision');
    await _openFirstCard(tester);

    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('Full - cannot join'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Join and cancel the last available place', (tester) async {
    await tester.pumpWidget(const CampusEventApp());
    await _search(tester, 'ieeextreme');
    expect(find.text('1 place left'), findsOneWidget);
    await _openFirstCard(tester);

    await tester.tap(find.text('Join event'));
    await tester.pumpAndSettle();
    expect(find.text('Join event?'), findsOneWidget);
    expect(find.text('Computer Engineering Lab B7'), findsWidgets);
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.text('Join event'), findsOneWidget);
    expect(find.text('1 place left'), findsOneWidget);

    await tester.tap(find.text('Join event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel participation'), findsOneWidget);
    expect(find.text('No places left'), findsOneWidget);
    expect(find.text('You joined "IEEEXtreme 26"'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Joined: 1'), findsOneWidget);
    await tester.tap(find.text('My Events'));
    await tester.pumpAndSettle();
    expect(find.text('IEEEXtreme 26'), findsOneWidget);

    await tester.tap(find.text('IEEEXtreme 26'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel participation'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel participation?'), findsOneWidget);
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.text('Join event'), findsOneWidget);
    expect(find.text('1 place left'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Joined: 0'), findsOneWidget);
    expect(find.text('You have not joined any events'), findsOneWidget);
  });

  testWidgets('Favorites update across views', (tester) async {
    await tester.pumpWidget(const CampusEventApp());
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No favorites yet'), findsOneWidget);

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('1 matching event'), findsOneWidget);
  });
}
