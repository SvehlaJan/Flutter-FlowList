import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/base/stateful_page.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';

class FlowNoteDetailPage extends StatefulPage {
  static const String ARG_DATE = "date";

  final String initDateString;

  FlowNoteDetailPage({this.initDateString});

  @override
  _FlowNoteDetailPageState createState() => _FlowNoteDetailPageState();
}

class _FlowNoteDetailPageState extends StatefulPageState<FlowNoteDetailPage>
    with TickerProviderStateMixin {
  DateTime _selectedDate;

  TextEditingController _entry1ValueController;
  TextEditingController _entry2ValueController;
  TextEditingController _entry3ValueController;

  bool _isEditMode = false;
  FlowRepository _flowRepository = FlowRepository.get();
  UserRepository _userRepository = UserRepository.get();

  @override
  void initState() {
    super.initState();

    _entry1ValueController = new TextEditingController(text: "Sample a");
    _entry2ValueController = new TextEditingController(text: "Sample b");
    _entry3ValueController = new TextEditingController(text: "Sample c");

    if (widget.initDateString != null) {
      _setSelectedDate(DateTime.parse(widget.initDateString));
    } else {
      _setSelectedDate(DateTime.now());
    }
  }

  void _setSelectedDate(DateTime dateTime) {
    showProgress();

    _selectedDate = dateTime;
    _flowRepository.getFlowRecord(dateTime).then((DocumentSnapshot snapshot) {
      if (snapshot != null && snapshot.data != null) {
        _isEditMode = true;
        _entry1ValueController.text = snapshot[FlowRecord.KEY_ENTRY_1] ?? "";
        _entry2ValueController.text = snapshot[FlowRecord.KEY_ENTRY_2] ?? "";
        _entry3ValueController.text = snapshot[FlowRecord.KEY_ENTRY_3] ?? "";
      } else {
        _isEditMode = false;
        _entry1ValueController.text = "Sample text a";
        _entry2ValueController.text = "";
        _entry3ValueController.text = "";
      }
      showContent(force: true);
    }, onError: (Object o) {
      print(o);
    });
  }

  void _onFabClicked() {
    FlowRecord record = FlowRecord(_selectedDate, _entry1ValueController.text,
        _entry2ValueController.text, _entry3ValueController.text);

    FlowRepository.get().setFlowRecord(record).then((_) {
      Navigator.of(context).pop(true);
    }, onError: (Object o) {
      print(o);
    });
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
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Delete'),
                onPressed: () {
                  FlowRepository.get()
                      .deleteFlowRecord(_selectedDate)
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                  Navigator.of(context).pop(); // close dialog
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
      tooltip: 'Submit',
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
                FlowRecord.userDateString(_selectedDate),
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
