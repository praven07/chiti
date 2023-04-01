import 'dart:async';
import 'package:chiti/src/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class Chiti<Action, State> {
  late BehaviorSubject<State> _state$;

  @protected
  Map<Type, Function> get actionHandlers;

  @protected
  State get initialState;

  Chiti() {
    _state$ = BehaviorSubject.seeded(initialState);
  }

  ValueStream<State> get state => _state$.stream;

  FutureOr<void> dispatch(Action action) async {
    Type actionType = action.runtimeType;

    if (!actionHandlers.containsKey(actionType)) {
      throw ActionNotAvailableException(
        "The dispatched action $actionType does not have a corresponding method available.",
      );
    }

    return actionHandlers[actionType]?.call();
  }

  @protected
  void setState(State state) => this._state$.add(state);

  void dispose() {
    this._state$.close();
  }
}
