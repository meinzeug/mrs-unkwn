import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'base_event.dart';
import 'base_state.dart';

/// Base class for BLoC with default logging and error handling.
abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  @override
  void onEvent(E event) {
    log('Event: $event', name: runtimeType.toString());
    super.onEvent(event);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log('Error: $error',
        name: runtimeType.toString(),
        stackTrace: stackTrace,
        level: 1000);
    super.onError(error, stackTrace);
  }
}
