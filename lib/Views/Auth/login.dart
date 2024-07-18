import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/Constants/app_const.dart';
import 'package:pingolearn_assignment/Constants/constant_widgets.dart';
import 'package:pingolearn_assignment/Views/Auth/signup.dart';

import '../../Constants/loading_dialog.dart';
import '../Home/home_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog dialog = LoadingDialog();
      dialog.start(context);
      await loginUser(_emailController.text.trim(),
          _passwordController.text.trim(), dialog);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppConst.lightGrey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height * .06,
                    ),
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConst.blue,
                        fontFamily: AppConst.poppins,
                      ),
                    ),
                    SizedBox(
                      height: height * .18,
                    ),
                    ConstantWidgets.customTextField(
                      _emailController,
                      'Email',
                      _validateEmail,
                    ),
                    SizedBox(height: 16),
                    ConstantWidgets.customTextField(
                      _passwordController,
                      'Password',
                      _validatePassword,
                    ),
                    Flexible(child: Container()),
                    Center(
                      child: ConstantWidgets.customButton(
                        () async {
                          await submitForm();
                        },
                        'Login',
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'New here? ',
                              style: AppStyles.defaultTextStyle(
                                color: AppConst.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Signup',
                              style: AppStyles.defaultTextStyle(
                                  color: AppConst.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: height * .08,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(
      String emailOrPhone, String password, LoadingDialog dialog) async {
    try {
      await checkEmailAndLogin(emailOrPhone, password, dialog);
    } on FirebaseAuthException catch (e) {
      dialog.stop(context);
      AppConst.showSimpleToast(context, e.code.toString());
    }
  }

  Future<void> checkEmailAndLogin(
      String email, String password, LoadingDialog dialog) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential?.user;
      if (user != null) {
        dialog.stop(context);
        AppConst.showSimpleToast(context, 'Logged in as ${user!.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        dialog.stop(context);
        AppConst.showSimpleToast(context, 'Incorrect Credentials');
      }
    } catch (e) {
      dialog.stop(context);
      AppConst.showSimpleToast(context, e.toString());
    }
  }
}
