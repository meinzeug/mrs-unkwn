import 'dart:developer';

import 'package:bloc/bloc.dart';

/// Global observer for logging BLoC events and transitions.
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    log('Bloc event: $event', name: bloc.runtimeType.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log('Bloc transition: $transition', name: bloc.runtimeType.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('Bloc error: $error',
        name: bloc.runtimeType.toString(),
        stackTrace: stackTrace,
        level: 1000);
    super.onError(bloc, error, stackTrace);
  }
}
