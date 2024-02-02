import 'dart:io';

import 'package:firebase_project/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_project/service/provider.dart';

final _firebase = FirebaseAuth.instance;

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final _form = GlobalKey<FormState>();

  // void _submit(BuildContext context) async {
  //   final isValid = _form.currentState!.validate();
  //
  //   if (!isValid || Provider.of<LoginState>(context, listen: false).isLoggedIn && _selectedImage == null) {
  //     // show error message ...
  //     return;
  //   }
  //
  //   _form.currentState!.save();
  //
  //   try {
  //     if (!Provider.of<LoginState>(context, listen: false).isLoggedIn) {
  //       final userCredentials = await _firebase.signInWithEmailAndPassword(
  //           email: Provider.of<LoginState>(context, listen: false).enteredEmail, password: Provider.of<LoginState>(context, listen: false).enteredPassword);
  //     } else {
  //       final userCredentials = await _firebase.createUserWithEmailAndPassword(
  //           email: Provider.of<LoginState>(context, listen: false).enteredEmail, password: Provider.of<LoginState>(context, listen: false).enteredPassword);
  //
  //       final storageRef = FirebaseStorage.instance
  //           .ref()
  //           .child('user_images')
  //           .child('${userCredentials.user!.uid}.jpg');
  //
  //       await storageRef.putFile(_selectedImage!);
  //       final imageUrl = await storageRef.getDownloadURL();
  //
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userCredentials.user!.uid)
  //           .set({
  //         'username': Provider.of<LoginState>(context, listen: false).enteredUsername,
  //         'email': Provider.of<LoginState>(context, listen: false).enteredEmail,
  //         'image_url': imageUrl,
  //       });
  //     }
  //   } on FirebaseAuthException catch (error) {
  //     if (error.code == 'email-already-in-use') {
  //       // ...
  //     }
  //     ScaffoldMessenger.of(context).clearSnackBars();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(error.message ?? 'Authentication failed.'),
  //       ),
  //     );
  //   }
  // }
  void _submit(BuildContext context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid || (Provider.of<LoginState>(context, listen: false).isLoggedIn &&  Provider.of<LoginState>(context, listen: false).selectedImage == null)) {
      // show error message ...
      return;
    }

    _form.currentState!.save();

    try {
      if (!Provider.of<LoginState>(context, listen: false).isLoggedIn) {
        // Sign in
        print('satu');
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: Provider.of<LoginState>(context, listen: false).enteredEmail,
          password: Provider.of<LoginState>(context, listen: false).enteredPassword,
        );
        // Handle signed-in user
      } else {
        // Create new user
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: Provider.of<LoginState>(context, listen: false).enteredEmail,
          password: Provider.of<LoginState>(context, listen: false).enteredPassword,);
        print('${Provider.of<LoginState>(context, listen: false).enteredEmail}');
        // Handle user image upload
        if (Provider.of<LoginState>(context, listen: false).selectedImage != null) {
          print('dua');
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putFile(Provider.of<LoginState>(context, listen: false).selectedImage!);
          final imageUrl = await storageRef.getDownloadURL();

          // Save user data to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'username': Provider.of<LoginState>(context, listen: false).enteredUsername,
            'email': Provider.of<LoginState>(context, listen: false).enteredEmail,
            'image_url': imageUrl,
          }).then((value) {
            return {
            print('success')
          };
          }).catchError((err){
            print('error');
            print('${err}');
          });
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // Handle case where email is already in use
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Consumer<LoginState>(
                        builder: (context, login, child){
                          if (!login.isLoggedIn) {
                            return Column(
                              children: [
                                TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Email Address'),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please enter a valid email address.';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  Provider.of<LoginState>(context, listen: false).email(value!);
                                },
                              ),
                                TextFormField(
                                  decoration:
                                  const InputDecoration(labelText: 'Password'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.trim().length < 6) {
                                      return 'Password must be at least 6 characters long.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    Provider.of<LoginState>(context, listen: false).password(value!);
                                  },
                                ),
                                const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: (){
                                      _submit(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                    child: Text('Login'),
                                  ),
                                TextButton(
                                  onPressed: () {
                                    Provider.of<LoginState>(context, listen: false).login();
                                  },
                                  child: Text('Create an account'),
                                ),
                            ]);
                          }else{
                            return Column(
                                children: [
                                  UserImagePicker(
                                    onPickImage: (pickedImage) {
                                      Provider.of<LoginState>(context, listen: false).image(pickedImage);
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Email Address'),
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please enter a valid email address.';
                                      }

                                      return null;
                                    },
                                    onSaved: (value) {
                                      Provider.of<LoginState>(context, listen: false).email(value!);
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                    const InputDecoration(labelText: 'Username'),
                                    enableSuggestions: false,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.trim().length < 4) {
                                        return 'Please enter at least 4 characters.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      Provider.of<LoginState>(context, listen: false).username(value!);
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                    const InputDecoration(labelText: 'Password'),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.trim().length < 6) {
                                        return 'Password must be at least 6 characters long.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      Provider.of<LoginState>(context, listen: false).password(value!);
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: (){
                                      _submit(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                    child: Text('Sign In'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<LoginState>(context, listen: false).login();
                                    },
                                    child: Text('Already have an account?'),
                                  ),
                                ]);
                          }
                        }
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
