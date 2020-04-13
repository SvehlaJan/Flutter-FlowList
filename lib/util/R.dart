import 'package:flutter/widgets.dart';
import 'package:flutter_flow_list/generated/l10n.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/util/navigation_service.dart';

class R {
  R._();

  @deprecated
  static S get sString => S.of(getIt<NavigationService>().navigationKey.currentContext);

  static S string(BuildContext context) => S.of(context);
}
