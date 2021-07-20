import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String? email,
    String? password,
    String? username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  AuthForm({required this.submitFn, required this.isLoading});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String? _userEmail = '';
  String? _username = '';
  String? _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      print(_userEmail);
      print(_username);
      print(_userPassword);
      widget.submitFn(
        _userEmail!.trim(),
        _userPassword!.trim(),
        _username!.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a valid email address';
                      }
                      if (value.isEmpty || !value.contains('@'))
                        return 'Please enter a valid email address';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      key: ValueKey('username'),
                      onSaved: (value) {
                        _username = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a valid username';
                        }
                        if (value.isEmpty || value.length < 3)
                          return 'Please enter at least 3 characters';
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a valid password';
                      }
                      if (value.isEmpty || value.length < 7)
                        return 'Password must be at least 7 characters long.';
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading)
                    CircularProgressIndicator()
                  else
                    Column(children: [
                      ElevatedButton(
                          onPressed: _trySubmit,
                          child: _isLogin ? Text('Log in') : Text('Sign Up')),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: _isLogin
                              ? Text('Create new Account')
                              : Text('I already have an account'))
                    ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
