import 'dart:io';

import 'package:flutter/cupertino.dart';

class BasePageRoute extends CupertinoPageRoute {

  BasePageRoute({required WidgetBuilder builder, RouteSettings? settings,bool maintainState = true, bool fullscreenDialog = false}) : super(builder: builder,settings: settings,fullscreenDialog: fullscreenDialog,maintainState: maintainState);

  @override
  Duration get transitionDuration =>Platform.isIOS? super.transitionDuration : Duration(milliseconds: 350);
}