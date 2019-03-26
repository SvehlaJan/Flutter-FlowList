import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_flow_list/entities/flow_record_entity.dart';
import 'package:flutter_flow_list/pages/base/firebase_database_page.dart';

class KoprAddNotePage extends FirebasePoweredPage {
  final String initDateString;

  KoprAddNotePage({this.initDateString});

  @override
  _KoprAddNotePageState createState() => new _KoprAddNotePageState();
}

class _KoprAddNotePageState extends FirebasePoweredPageState<KoprAddNotePage>
    with TickerProviderStateMixin {
  DatabaseError _error;

  DateTime _selectedDate;
  DatabaseReference _recordsRef;
  DatabaseReference _selectedRecordRef;
  StreamSubscription<Event> _selectedRecordSubscription;

  AnimationController _controller;
  TextEditingController _entry1ValueController;
  TextEditingController _entry2ValueController;
  TextEditingController _entry3ValueController;

  bool _isEditMode = false;

  static const int kStartValue = 2;

  @override
  void initState() {
    super.initState();

    _entry1ValueController = new TextEditingController(text: "Sample a");
    _entry2ValueController = new TextEditingController(text: "Sample b");
    _entry3ValueController = new TextEditingController(text: "Sample c");
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print('Animation completed');
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _selectedRecordSubscription.cancel();
  }

  @override
  void initFirebaseReferences(String userId) {
    // Demonstrates configuring the database directly
//    final FirebaseDatabase database = new FirebaseDatabase();
    // Demonstrates configuring to the database using a file
    final FirebaseDatabase database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    _recordsRef = database
        .reference()
        .child('kopr')
        .child('flow_notes')
        .child(userId)
        .child('records');

    if (widget.initDateString != null) {
      _setSelectedDate(DateTime.parse(widget.initDateString));
    } else {
      _setSelectedDate(DateTime.now());
    }
  }

  void _initRecordForDateTime(DateTime dateTime) {
    String date = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);

    if (_selectedRecordSubscription != null) {
      _selectedRecordSubscription.cancel();
    }

    _selectedRecordRef = _recordsRef.child(date);

    _selectedRecordRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        _isEditMode = true;
        _entry1ValueController.text =
            snapshot.value[FlowRecord.KEY_ENTRY_1] ?? "";
        _entry2ValueController.text =
            snapshot.value[FlowRecord.KEY_ENTRY_2] ?? "";
        _entry3ValueController.text =
            snapshot.value[FlowRecord.KEY_ENTRY_3] ?? "";
      } else {
        _isEditMode = false;
        _entry1ValueController.text = "Sample text a";
        _entry2ValueController.text = "";
        _entry3ValueController.text = "";
      }
      showContent(force: true);
    });
    _selectedRecordSubscription =
        _selectedRecordRef.onChildChanged.listen((Event event) {
      print('Child changed: ${event.snapshot.key ?? "null"}');
      setState(() {
        _error = null;
        _controller.forward(from: 0.0);
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        _error = error;
      });
    });
  }

  void _setSelectedDate(DateTime dateTime) {
    _initRecordForDateTime(dateTime);
    _selectedDate = dateTime;
  }

  Future<Null> _onFabClicked() async {
    await _selectedRecordRef.update(<String, String>{
      FlowRecord.KEY_ENTRY_1: _entry1ValueController.text,
      FlowRecord.KEY_ENTRY_2: _entry2ValueController.text,
      FlowRecord.KEY_ENTRY_3: _entry3ValueController.text,
      FlowRecord.KEY_DATE_MODIFIED: DateTime.now().toIso8601String()
    });

    Navigator.of(context).pop(true);
  }

  void _onDateClicked() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minYear: 2000,
      maxYear: DateTime.now().year,
      initialYear: _selectedDate.year,
      initialMonth: _selectedDate.month,
      initialDate: _selectedDate.day,
      onChanged: (year, month, date) {},
      onConfirm: (year, month, date) {
        _setSelectedDate(new DateTime(year, month, date));
      },
    );
  }

  void _onDeleteClicked() {
    showDialog<Null>(
      context: context,
      builder: (_) => new AlertDialog(
            title: Text("Delete record"),
            content: Text("Are you sure to delete this record?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Delete'),
                onPressed: () {
                  _recordsRef.remove().then((_) {
                    Navigator.of(context).pop();
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
      barrierDismissible: true,
    );
  }

  @override
  String getPageTitle() {
    return 'Flow notes';
  }

  @override
  FloatingActionButton getPageFab() {
    return FloatingActionButton(
      onPressed: _onFabClicked,
      tooltip: 'Increment',
      child: const Icon(Icons.check),
    );
  }

  @override
  List<Widget> getPageActions() {
    return _isEditMode
        ? [
            IconButton(
                icon: Icon(Icons.delete_forever), onPressed: _onDeleteClicked)
          ]
        : null;
  }

  @override
  Widget getContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: _onDateClicked,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                formatDate(_selectedDate, [dd, '.', mm, '.', yyyy]),
                textAlign: TextAlign.center,
                style: new TextStyle(color: Colors.black, fontSize: 30.0),
              ),
            ),
          ),
        ),
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new TextField(
            maxLines: 1,
            controller: _entry1ValueController,
          ),
        ),
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new TextField(
            maxLines: 1,
            controller: _entry2ValueController,
          ),
        ),
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new TextField(
            maxLines: 1,
            controller: _entry3ValueController,
          ),
        )
      ],
    );
  }
}
