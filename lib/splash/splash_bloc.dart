// splash_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'package:background_services/splash/splash_event.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../preferences/AppPref.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(InitialState()) {
    on<LoadApp>(_onLoadApp);
  }

  Future<void> _onLoadApp(LoadApp event, Emitter<SplashState> emit) async {
    try {
      emit(LoadedState());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
