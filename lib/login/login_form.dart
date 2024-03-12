// login_form.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../user/userprofile_screen.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => UserProfileScreen()),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
        }
        else if (state is LocationPermissionDenied) {
             showDialog(
          context: context as BuildContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                  'Background Location Access Required'),
              content: Text(
                  'To use this app, please enable background location access in your device settings.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    openAppSettings(); // Open app settings so the user can manually enable background location access
                    Navigator.of(context).pop();
                  },
                  child: Text('Go to Settings'),
                ),
              ],
            );
          },);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {

            return Form(

              key: context.read<LoginBloc>().formKey,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),

                    SizedBox(height: 50),
                    const Text(
                      "Please login using app credentials",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true, // Set filled to true
                          fillColor: Color(0xFFF7F9FA),
                          labelText: 'Username'),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isHidden,

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true, // Set filled to true
                        fillColor: Color(0xFFF7F9FA),
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          child: Icon(
                              _isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: Size(double.infinity, 30),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: state is LoginLoading
                          ? null // Disable the button if in loading state
                          : () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;
                        context.read<LoginBloc>().add(LoginSubmitted(
                          email: email,
                          password: password,
                        ));
                      },
                      child: state is LoginLoading
                          ? CircularProgressIndicator(
                    backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),


                  ],
                ),
              ),
            );

        },
      ),
    );
  }

}
