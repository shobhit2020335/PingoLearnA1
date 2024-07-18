import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/Constants/app_const.dart';
import 'package:pingolearn_assignment/Constants/constant_widgets.dart';

import '../../Constants/loading_dialog.dart';
import '../Home/home_page.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await checkAndProceed(
          _emailController.text.trim(), _passwordController.text.trim());
    }
  }

  Future<void> checkAndProceed(String email, String password) async {
    LoadingDialog dialog = LoadingDialog();
    dialog.start(context);

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await collectionReference.where('email', isEqualTo: email).get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      if (documentSnapshot.exists) {
        dialog.stop(context);
        AppConst.showSimpleToast(
            context, 'User with email already  exists. please login');
      }
    } else {
      Map<String, dynamic> map = {
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
      };

      createAccount(map, dialog);
    }
  }

  void createAccount(Map<String, dynamic> map, LoadingDialog dialog) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email == '' || password == '') {
      AppConst.showSimpleToast(context, 'Please fill all the details');
      dialog.stop(context);
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          addUserInDatabase(map, dialog);
        }).onError((error, stackTrace) {
          dialog.stop(context);
          AppConst.showSimpleToast(context, error.toString());
        });
      } on FirebaseAuthException catch (e) {
        dialog.stop(context);
        AppConst.showSimpleToast(context, e.code.toString());
      }
    }
  }

  Future<void> addUserInDatabase(
      Map<String, dynamic> data, LoadingDialog dialog) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('Users');

      await collectionReference.add(data).then((value) {
        print('Document created successfully.');
        dialog.stop(context);
        ;
        AppConst.showSimpleToast(context, 'User created successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      });
    } catch (error) {
      print('Error creating document: $error');
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                    // children: [
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
                      height: height * .14,
                    ),
                    // SizedBox(height: 50),
                    ConstantWidgets.customTextField(
                      _nameController,
                      'Name',
                      _validateName,
                    ),
                    SizedBox(height: 16),
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
                          await _submitForm();
                        },
                        'Signup',
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppStyles.defaultTextStyle(
                                color: AppConst.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Login',
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
