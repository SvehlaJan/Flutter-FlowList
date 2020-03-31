import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/pages/notes/detail/record_detail_view_model.dart';
import 'package:flutter_flow_list/util/R.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/date_picker_adapter.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class RecordDetailPage extends StatefulWidget {
  static const String ARG_DATE_STR = "RecordDetailPage.DATE_STR";
  static const String ARG_IMAGE_URL = "RecordDetailPage.IMAGE_URL";

  final String initDateString;
  final String initPhotoUrl;

  RecordDetailPage(this.initDateString, this.initPhotoUrl);

  @override
  _RecordDetailPageState createState() => _RecordDetailPageState();

  static Map<String, dynamic> createArguments({final String dateStr, final String imageUrl}) {
    Map<String, dynamic> arguments = {};
    if (dateStr != null) {
      arguments[ARG_DATE_STR] = dateStr;
      arguments[ARG_IMAGE_URL] = imageUrl;
    }
    return arguments;
  }
}

class _RecordDetailPageState extends BasePageState<RecordDetailPage> with TickerProviderStateMixin {
  final TextEditingController _entry1ValueController = TextEditingController();
  final TextEditingController _entry2ValueController = TextEditingController();
  final TextEditingController _entry3ValueController = TextEditingController();
  final FocusNode _entry1FocusNode = FocusNode();
  final FocusNode _entry2FocusNode = FocusNode();
  final FocusNode _entry3FocusNode = FocusNode();

  @override
  String getPageTitle() => R.string(context).record_detail_title;

  void _onFabClicked(RecordsDetailViewModel model) {
    model.record.firstEntry = _entry1ValueController.text;
    model.record.secondEntry = _entry2ValueController.text;
    model.record.thirdEntry = _entry3ValueController.text;

    model.updateFlowRecord().then((value) => Navigator.of(context).pop(true));
  }

  void _onDateClicked(RecordsDetailViewModel model) {
    DateTime today = DateTime.now();
    Picker(
      hideHeader: false,
      adapter: DatePickerAdapter(value: model.record.dateTime, dayMax: today.day, monthMax: today.month, yearMax: today.year),
      title: Text(R.string(context).record_detail_date_picker_title),
      onConfirm: (Picker picker, List value) {
        DateTime dateTime = (picker.adapter as DatePickerAdapter).value;
        model.fetchRecord(dateTime);
      },
    ).showModal(context);
  }

  void _onRatingClicked(RecordsDetailViewModel model) {
    List<int> values = List<int>.generate(5, (i) => i + 1);
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: values),
      selecteds: [(model.record.dayScore ?? 1) - 1],
      title: Text(R.string(context).record_detail_score_picker_title),
      changeToFirst: true,
      hideHeader: false,
      onConfirm: (Picker picker, List value) {
        model.onDayScoreSelected(int.parse(picker.getSelectedValues().first.toString()));
      },
    ).showModal(context); //_scaffoldKey.currentState);
  }

  void _onDeleteClicked(RecordsDetailViewModel model) {
    showDialog<Null>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(R.string(context).record_detail_delete_dialog_title),
        actions: <Widget>[
          FlatButton(
            child: Text(R.string(context).general_cancel),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          FlatButton(
            child: Text(R.string(context).general_delete),
            onPressed: () {
              model.deleteFlowRecord().then((value) => Navigator.of(context).pop());
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void _onFavoriteClicked(int index, RecordsDetailViewModel model) {
    model.onFavoriteEntrySelected(index);
  }

  List<AppBarAction> buildAppBarActions(BuildContext context, RecordsDetailViewModel model) {
    return model.isEditMode ? [AppBarAction("Delete", Icons.delete_forever, () => _onDeleteClicked(model))] : null;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RecordsDetailViewModel>.withConsumer(
        viewModel: RecordsDetailViewModel(),
        onModelReady: (model) {
          model.showSnackBarStream.listen((message) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
          });
          model.resetRecordStream.listen((record) {
            _entry1ValueController.text = record.firstEntry;
            _entry2ValueController.text = record.secondEntry;
            _entry3ValueController.text = record.thirdEntry;
          });

          if (widget.initDateString != null) {
            model.fetchRecord(DateTime.parse(widget.initDateString));
          } else {
            model.fetchRecord(DateTime.now());
          }
        },
        builder: (context, model, child) {
          return buildScaffold(
            context,
            LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (widget.initPhotoUrl != null) _buildImageHeader(context, model),
                          if (!model.busy) _buildHeader(context, model),
                          if (!model.busy) ..._buildTextFields(context, model),
                          if (model.busy) Expanded(child: Constants.centeredProgressIndicator),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            fab: FloatingActionButton(
              onPressed: () => (!model.busy) ? _onFabClicked(model) : null,
              tooltip: R.string(context).general_submit,
              child: const Icon(Icons.check),
            ),
            appBarActions: (!model.busy) ? buildAppBarActions(context, model) : null,
          );
        });
  }

  Widget _buildHeader(BuildContext context, RecordsDetailViewModel model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () => _onDateClicked(model),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(model.record.getUserDateString(), style: Theme.of(context).textTheme.headline6),
                  Text("${R.string(context).record_detail_by_prefix} ${model.currentUser.name}", style: Theme.of(context).textTheme.caption)
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => _onRatingClicked(model),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[..._getDayScoreStars(model.record.dayScore ?? 0)],
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _getDayScoreStars(int stars) => List<Widget>.generate(5, (index) => Icon(Icons.star, color: (index < 5 - stars) ? Colors.grey : Colors.amber));

  List<Widget> _buildTextFields(BuildContext context, RecordsDetailViewModel model) {
    return [
      _buildTextField(
        context,
        _entry1ValueController,
        _entry1FocusNode,
        R.string(context).record_detail_entry_hint_1,
        model.record?.favoriteEntry == 0,
        () => _onFavoriteClicked(0, model),
        () => FocusScope.of(context).requestFocus(_entry2FocusNode),
      ),
      _buildTextField(
        context,
        _entry2ValueController,
        _entry2FocusNode,
        R.string(context).record_detail_entry_hint_2,
        model.record?.favoriteEntry == 1,
        () => _onFavoriteClicked(1, model),
        () => FocusScope.of(context).requestFocus(_entry3FocusNode),
      ),
      _buildTextField(
        context,
        _entry2ValueController,
        _entry3FocusNode,
        R.string(context).record_detail_entry_hint_3,
        model.record?.favoriteEntry == 2,
        () => _onFavoriteClicked(2, model),
        () => _onFabClicked(model),
      )
    ];
  }

  Widget _buildTextField(
      BuildContext context, TextEditingController controller, FocusNode focusNode, String hint, bool isFavorite, VoidCallback onFavoriteTap, VoidCallback onSubmitted) {
//    bool favoriteEntryEnabled = getIt<FeatureService>().getBool(FeatureService.FEATURE_FAVORITE_ENTRY);
    bool favoriteEntryEnabled = false;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.subtitle1,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              onSubmitted: (_) => onSubmitted(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hint,
                labelStyle: Theme.of(context).textTheme.bodyText1,
                suffix: favoriteEntryEnabled
                    ? InkWell(
                        onTap: () => onFavoriteTap(),
                        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      )
                    : null,
              ),
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, RecordsDetailViewModel model) {
    String photoUrl = model.record?.imageUrl ?? widget.initPhotoUrl;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        if (photoUrl != null)
          Hero(
            tag: photoUrl,
            child: CachedNetworkImage(
              placeholder: (context, url) => Constants.centeredProgressIndicator,
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageUrl: photoUrl,
              imageBuilder: (context, provider) => Image(image: provider),
              fit: BoxFit.fill,
            ),
          ),
        _buildImageControls(context, model)
      ],
    );
  }

  Widget _buildImageControls(BuildContext context, RecordsDetailViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          RawMaterialButton(
            elevation: 4.0,
            onPressed: () => model.getImage(ImageSource.camera),
            child: Icon(Icons.camera_alt),
            shape: CircleBorder(),
            fillColor: Theme.of(context).cardColor,
            constraints: BoxConstraints(),
            padding: const EdgeInsets.all(12.0),
          ),
          Spacer(),
          RawMaterialButton(
            elevation: 4.0,
            onPressed: () => model.getImage(ImageSource.gallery),
            child: Icon(Icons.image),
            shape: CircleBorder(),
            fillColor: Theme.of(context).cardColor,
            constraints: BoxConstraints(),
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }
}
