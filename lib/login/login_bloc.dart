//login_bloc.dart
import 'dart:async';


import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../preferences/AppPref.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final formKey = GlobalKey<FormState>();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {


    if (Platform.isAndroid || Platform.isIOS) {

      var permission=  await Permission.locationWhenInUse.request();

      await Permission.locationAlways.request();
      bool isalways = await Permission.locationAlways.isGranted?true:false;
      if (permission == PermissionStatus.granted   ) {
        bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isLocationServiceEnabled) {
          await Geolocator.openLocationSettings();
        }
        emit(LoginSuccess());

      } else if (permission == PermissionStatus.denied) {
        emit(const LocationPermissionDenied('Location permission denied'));
      } else if (permission == PermissionStatus.permanentlyDenied) {
        emit(const LocationPermissionDenied('Location permission permanently denied'));
      }



    }



  }


}
