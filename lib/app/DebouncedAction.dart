import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';

class DebouncedAction {
  int milliseconds;
  Timer? _timer;
  Function _nextAction = () {};
  Function? _currentAction;
  bool _lock = false;
  String title = '';

  DebouncedAction({this.milliseconds = 250 , this.title = ''});

  run(String subTitle , Function action) {
    EasyDebounce.debounce('debouncer1'+ title + subTitle,
        Duration(milliseconds: milliseconds), () => action());
    return;
    // //if no action is running run the new action immediately
    // if (_currentAction == null) {
    //   //assign value to currentAction to indicate that there is a running action now
    //   _currentAction = action;
    //   action();
    // } else {
    //   // when there is a running action save the new action in nextAction to be the next action to run
    //   _nextAction = action;
    //   // create new timer to run the next action after delay ,
    //   // if timer has been created no need to create a new one
    //   if (_timer == null) {
    //     _timer = Timer(Duration(milliseconds: milliseconds), _run);
    //   }
    // }
  }

  _run() {
    // after timer finishes it calls _run() to run nextAction
    // if there is action running this new instance of _run() will stop,
    // but timer will not be null,
    // later this will indicate that _run() needs to be called again because the new nextAction was not executed
    if (_lock) {
      return;
    }
    _lock = true;
    // cancel old timer because it has finished and any new action needs to create new timer
    _timer = null;
    _currentAction = _nextAction;
    _currentAction!().then((_) {
      // unlock after delay so no action is executed directly after this action has finished
      Future.delayed(Duration(milliseconds: milliseconds ~/ 2), () {
        _lock = false;
        _currentAction = null;
        // if _run() was stopped before as mentioned above recall it again after delay
        // if _timer is working it may finish directly after unlocking _run(),
        // to avoid this delay timer by creating new one
        if (_timer != null) {
          _timer = Timer(Duration(milliseconds: milliseconds ~/ 2), _run);
        }
      });
    });
  }
}