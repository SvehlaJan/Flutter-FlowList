import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/date_picker_adapter.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RecordDetailPage extends StatefulWidget {
  static const String ARG_DATE = "date";

  final String initDateString;

  RecordDetailPage({this.initDateString});

  @override
  _RecordDetailPageState createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends BasePageState<RecordDetailPage> with TickerProviderStateMixin {
  FlowRecord _flowRecord;

  TextEditingController _entry1ValueController;
  TextEditingController _entry2ValueController;
  TextEditingController _entry3ValueController;

  bool _isEditMode = false;
  bool _isLoading = true;

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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlowRepository>(context, listen: false).getFlowRecord(dateTime).then((FlowRecord record) {
        _flowRecord = record;
        _isEditMode = record.isSaved;
        _entry1ValueController.text = record.firstEntry;
        _entry2ValueController.text = record.secondEntry;
        _entry3ValueController.text = record.thirdEntry;

        showContent();
      });
    });
  }

  void _onFabClicked() {
    _flowRecord.firstEntry = _entry1ValueController.text;
    _flowRecord.secondEntry = _entry2ValueController.text;
    _flowRecord.thirdEntry = _entry3ValueController.text;

    Provider.of<FlowRepository>(context, listen: false).updateFlowRecord(_flowRecord).then((value) => Navigator.of(context).pop(true));
  }

  void _onDateClicked() {
    DateTime today = DateTime.now();
    Picker(
        hideHeader: true,
        adapter: DatePickerAdapter(value: _flowRecord.dateTime, dayMax: today.day, monthMax: today.month, yearMax: today.year),
        title: Text("Select Date"),
        onConfirm: (Picker picker, List value) {
          _setSelectedDate((picker.adapter as DatePickerAdapter).value);
        }).showDialog(context);
  }

  void _showDeleteDialog() {
    showDialog<Null>(
      context: context,
      builder: (dialogContext) => new AlertDialog(
        title: Text("Delete record"),
        content: Text("Are you sure to delete this record?"),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          new FlatButton(
            child: new Text('Delete'),
            onPressed: () {
              Provider.of<FlowRepository>(context, listen: false).deleteFlowRecord(_flowRecord.dateTime).then((value) => Navigator.of(context).pop());
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
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: values),
      changeToFirst: true,
      hideHeader: false,
      onConfirm: (Picker picker, List value) {
        _flowRecord.dayScore = int.parse(picker.getSelectedValues().first.toString());
        showContent();
      },
    ).showModal(context); //_scaffoldKey.currentState);
  }

  void _onFavoriteClicked(int index) {
    _flowRecord.favoriteEntry = index;
    showContent();
  }

  Future<void> _getImage(ImageSource source) async {
    showLoading();
    File imageFile = await ImagePicker.pickImage(source: source, maxHeight: Constants.uploadImageMaxSize, maxWidth: Constants.uploadImageMaxSize);

    if (imageFile != null) {
      await uploadFile(imageFile);
    } else {
      showContent();
    }
  }

  Future<void> uploadFile(File imageFile) async {
    Provider.of<FlowRepository>(context, listen: false).uploadImage(imageFile, DateTime.now()).then((downloadUrl) {
      _flowRecord.imageUrl = downloadUrl;
      showContent();
    }, onError: (err) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("This file is not an image")));
      showContent();
    });
  }

  void showContent() => setState(() {
        _isLoading = false;
      });

  void showLoading() => setState(() {
        _isLoading = true;
      });

  @override
  String getPageTitle() {
    return 'Detail';
  }

  @override
  FloatingActionButton getPageFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: _onFabClicked,
      tooltip: 'Submit',
      child: const Icon(Icons.check),
    );
  }

  @override
  List<AppBarAction> getAppBarActions(BuildContext context) {
    return _isEditMode ? [AppBarAction("Delete", Icons.delete_forever, _showDeleteDialog)] : null;
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
        context,
        _isLoading
            ? Constants.centeredProgressIndicator
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        if (_flowRecord.imageUrl != null)
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: double.infinity, minHeight: 240.0),
                            child: Hero(
                              tag: _flowRecord.imageUrl,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Constants.centeredProgressIndicator,
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                imageUrl: _flowRecord.imageUrl,
                                imageBuilder: (context, provider) => Image(image: provider),
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
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_flowRecord.getUserDateString(), style: Theme.of(context).textTheme.headline6),
                                  Text("By " + Provider.of<UserRepository>(context, listen: false).currentUser.name, style: Theme.of(context).textTheme.caption)
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
                                  style: Theme.of(context).textTheme.title.apply(fontSizeFactor: 1.4),
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
                    _getTextField(_entry1ValueController, "Your first entry", _flowRecord?.favoriteEntry == 0, () {
                      _onFavoriteClicked(0);
                    }),
                    _getTextField(_entry2ValueController, "Your second entry", _flowRecord?.favoriteEntry == 1, () {
                      _onFavoriteClicked(1);
                    }),
                    _getTextField(_entry2ValueController, "Your third entry", _flowRecord?.favoriteEntry == 2, () {
                      _onFavoriteClicked(2);
                    }),
                  ],
                ),
              ));
  }

  Widget _getTextField(TextEditingController controller, String label, bool isFavorite, GestureTapCallback onFavoriteTap) {
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
