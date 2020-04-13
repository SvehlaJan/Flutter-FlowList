import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/ui/flow_record_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String ENTRY_1 = "Entry 1";
  const String ENTRY_2 = "Entry 2";
  const String ENTRY_3 = "Entry 3";
  const String IMAGE_URL = "http://image.jpg";

  testWidgets('FlowRecordTile with filled records show all data', (WidgetTester tester) async {
    bool onTileClicked = false;
    DateTime dateTime = DateTime.now();
    FlowRecord record = FlowRecord.withDateTime(dateTime, firstEntry: ENTRY_1, secondEntry: ENTRY_2, thirdEntry: ENTRY_3, imageUrl: IMAGE_URL);
    await tester.pumpWidget(MaterialApp(home: FlowRecordTile(record: record, onTap: () => onTileClicked = true)));
    await tester.tap(find.byType(InkWell));

    final dateFinder = find.text(FlowRecord.userDateString(dateTime));
    final entry1Finder = find.text("1. $ENTRY_1");
    final entry2Finder = find.text("2. $ENTRY_2");
    final entry3Finder = find.text("3. $ENTRY_3");
    final imageFinder = find.byWidgetPredicate((widget) => widget is CachedNetworkImage && widget.imageUrl == IMAGE_URL);

    expect(dateFinder, findsOneWidget);
    expect(entry1Finder, findsOneWidget);
    expect(entry2Finder, findsOneWidget);
    expect(entry3Finder, findsOneWidget);
    expect(imageFinder, findsOneWidget);

    expect(onTileClicked, true);
  });

  testWidgets('FlowRecordTile with empty records show no data', (WidgetTester tester) async {
    bool onTileClicked = false;
    DateTime dateTime = DateTime.now();
    FlowRecord record = FlowRecord.withDateTime(dateTime);
    await tester.pumpWidget(MaterialApp(home: FlowRecordTile(record: record, onTap: () => onTileClicked = true)));
    await tester.tap(find.byType(InkWell));

    final dateFinder = find.text(FlowRecord.userDateString(dateTime));
    final entry1Finder = find.text("1. ");
    final entry2Finder = find.text("2. ");
    final entry3Finder = find.text("3. ");
    final imageFinder = find.byType(CachedNetworkImage);

    expect(dateFinder, findsOneWidget);
    expect(entry1Finder, findsOneWidget);
    expect(entry2Finder, findsOneWidget);
    expect(entry3Finder, findsOneWidget);
    expect(imageFinder, findsNothing);
    expect(onTileClicked, true);
  });
}
