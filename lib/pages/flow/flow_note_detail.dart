import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/base/stateful_page.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';

class FlowNoteDetailPage extends StatefulPage {
  static const String ARG_DATE = "date";

  final String initDateString;

  FlowNoteDetailPage({this.initDateString});

  @override
  _FlowNoteDetailPageState createState() => _FlowNoteDetailPageState();
}

class _FlowNoteDetailPageState extends StatefulPageState<FlowNoteDetailPage>
    with TickerProviderStateMixin {
//  DateTime _selectedDate;
  FlowRecord _flowRecord;

  TextEditingController _entry1ValueController;
  TextEditingController _entry2ValueController;
  TextEditingController _entry3ValueController;

  bool _isEditMode = false;
  FlowRepository _flowRepository = FlowRepository.get();
  UserRepository _userRepository = UserRepository.get();

  @override
  void initState() {
    super.initState();

    _entry1ValueController = new TextEditingController();
    _entry2ValueController = new TextEditingController();
    _entry3ValueController = new TextEditingController();

    if (widget.initDateString != null) {
      _setSelectedDate(DateTime.parse(widget.initDateString));
    } else {
      _setSelectedDate(DateTime.now());
    }
  }

  void _setSelectedDate(DateTime dateTime) {
    showProgress();

    _flowRepository.getFlowRecord(dateTime).then((DocumentSnapshot snapshot) {
      if (snapshot != null && snapshot.data != null) {
        _isEditMode = true;
        _flowRecord = FlowRecord.fromSnapShot(snapshot);
      } else {
        _isEditMode = false;
        _flowRecord = FlowRecord(dateTime);
      }

      _entry1ValueController.text = _flowRecord.firstEntry ?? "";
      _entry2ValueController.text = _flowRecord.secondEntry ?? "";
      _entry3ValueController.text = _flowRecord.thirdEntry ?? "";

      showContent(force: true);
    }, onError: (Object o) {
      print(o);
    });
  }

  void _onFabClicked() {
    _flowRecord.firstEntry = _entry1ValueController.text;
    _flowRecord.secondEntry = _entry2ValueController.text;
    _flowRecord.thirdEntry = _entry3ValueController.text;

    FlowRepository.get().setFlowRecord(_flowRecord).then((_) {
      Navigator.of(context).pop(true);
    }, onError: (Object o) {
      print(o);
    });
  }

  void _onDateClicked() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      locale: 'en',
      minYear: 2000,
      maxYear: DateTime.now().year,
      initialYear: _flowRecord.dateTime.year,
      initialMonth: _flowRecord.dateTime.month,
      initialDate: _flowRecord.dateTime.day,
      onConfirm: (year, month, date) {
        _setSelectedDate(new DateTime(year, month, date));
      },
    );
  }

  void _onDeleteClicked() {
    showDialog<Null>(
      context: context,
      builder: (dialogContext) => new AlertDialog(
            title: Text("Delete record"),
            content: Text("Are you sure to delete this record?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              new FlatButton(
                child: new Text('Delete'),
                onPressed: () {
                  showProgress();
                  FlowRepository.get()
                      .deleteFlowRecord(_flowRecord.dateTime)
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
      barrierDismissible: true,
    );
  }

  void _onRatingClicked() {
    List<int> values = new List<int>.generate(10, (i) => i + 1);
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: values),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          _flowRecord.dayScore =
              int.parse(picker.getSelectedValues().first.toString());
          print(_flowRecord.dayScore.toString());
          showContent(force: true);
        }).showModal(this.context); //_scaffoldKey.currentState);
  }

  void _onFavoriteClicked(int index) {
    _flowRecord.favoriteEntry = index;
    showContent(force: true);
  }

  Future<void> _getImage(ImageSource source) async {
    showProgress();
    File imageFile = await ImagePicker.pickImage(
        source: source,
        maxHeight: Constants.uploadImageMaxSize,
        maxWidth: Constants.uploadImageMaxSize);

    if (imageFile != null) {
      await uploadFile(imageFile);
    } else {
      showContent();
    }
  }

  Future<void> uploadFile(File imageFile) async {
    _flowRepository.uploadImage(imageFile, DateTime.now()).then((downloadUrl) {
      _flowRecord.imageUrl = downloadUrl;
      showContent();
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  @override
  String getPageTitle() {
    return 'Detail';
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: 240.0,
                    ),
                child: Center(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: _flowRecord.imageUrl ?? "",
                    imageBuilder: (context, provider) {
                      Image image = Image(image: provider);
                      return image;
                    },
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              _getImageControls()
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: _onDateClicked,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_flowRecord.getUserDateString(),
                            style: Theme.of(context).textTheme.title),
                        Text("By " + _userRepository.getUserName(),
                            style: Theme.of(context).textTheme.caption)
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: _onRatingClicked,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        _flowRecord.dayScore?.toString() ?? "?",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .apply(fontSizeFactor: 1.4),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          _getTextField(_entry1ValueController, "Your first entry",
              _flowRecord?.favoriteEntry == 0, () {
            _onFavoriteClicked(0);
          }),
          _getTextField(_entry2ValueController, "Your second entry",
              _flowRecord?.favoriteEntry == 1, () {
            _onFavoriteClicked(1);
          }),
          _getTextField(_entry2ValueController, "Your third entry",
              _flowRecord?.favoriteEntry == 2, () {
            _onFavoriteClicked(2);
          }),
        ],
      ),
    );
  }

  Widget _getTextField(TextEditingController controller, String label,
      bool isFavorite, GestureTapCallback onFavoriteTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.subhead,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: Theme.of(context).textTheme.body1,
              ),
              controller: controller,
            ),
          ),
          InkWell(
            onTap: onFavoriteTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getImageControls() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _getImage(ImageSource.camera),
            child: new Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 24.0,
            ),
            shape: new CircleBorder(),
            fillColor: Colors.white70,
            constraints: BoxConstraints(),
            padding: const EdgeInsets.all(12.0),
          ),
          Spacer(),
          RawMaterialButton(
            onPressed: () => _getImage(ImageSource.gallery),
            child: new Icon(
              Icons.image,
              color: Colors.white,
              size: 24.0,
            ),
            shape: new CircleBorder(),
            fillColor: Colors.white70,
            constraints: BoxConstraints(),
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }
}
