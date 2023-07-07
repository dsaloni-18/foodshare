// ignore_for_file: unnecessary_null_comparison, avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:foodshare/widgets/reusable_widgets.dart';
import 'package:foodshare/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  bool _showPwd = true;
  final pwd = TextEditingController();
  final cnfrmpwd = TextEditingController();
  late bool hasUppercase;
  late bool hasDigits;
  late bool hasLowercase;
  late bool hasSpecialCharacters;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var _userName = '';
  var _userEmail = '';
  var _userPasswrod = '';
  late bool isDonor;
  int count = 0;
  bool isResto = false;
  bool isCaterer = false;
  bool isIndividual = false;
  bool isNGO = false;
  String restoName = '';
  String catererName = '';
  String indiName = '';
  bool right = false;
  bool _showCnfrmPwd = true;

  void password() {
    setState(() {
      _showPwd = !_showPwd;
    });
  }

  void passwordC() {
    setState(() {
      _showCnfrmPwd = !_showCnfrmPwd;
    });
  }

  void validation() {
    hasUppercase = (pwd.text).contains(RegExp(r'[A-Z]'));
    hasDigits = (pwd.text).contains(RegExp(r'[0-9]'));
    hasLowercase = (pwd.text).contains(RegExp(r'[a-z]'));
    hasSpecialCharacters =
        (pwd.text).contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters) {
      setState(() {
        right = true;
      });
      return;
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              elevation: 10,
              content: FittedBox(
                  child: Column(
                children: <Widget>[
                  const Text('  Passwords must have :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('   1. Atleast one Uppercase letter ',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('    2. Atleast one Lowercase letter ',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('    3. Atleast one Special character',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('    4. Atleast one number from 0-9!',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              )),
            );
          });
    }
  }

  void saveAll() async {
    UserCredential authResult;
    final isValid = _formKey.currentState!.validate;
    FocusScope.of(context).unfocus();
    if (isValid != null) {
      _formKey.currentState?.save();
      try {
        setState(() {
          isLoading = true;
        });
        authResult = await _auth.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPasswrod);
        if (isDonor) {
          if (isResto) {
            await FirebaseFirestore.instance
                .collection('donors')
                .doc(authResult.user?.uid)
                .set({
              'username': _userName.trim(),
              'email': _userEmail.trim(),
              'type of donor': 'Restaurant',
              'address': " ",
              'reportCount': 0,
            });
          }
          if (isCaterer) {
            await FirebaseFirestore.instance
                .collection('donors')
                .doc(authResult.user?.uid)
                .set({
              'username': _userName.trim(),
              'email': _userEmail.trim(),
              'type of donor': 'Caterer',
              'address': " ",
              'reportCount': 0,
            });
          }
          if (isIndividual) {
            await FirebaseFirestore.instance
                .collection('donors')
                .doc(authResult.user!.uid)
                .set({
              'username': _userName.trim(),
              'email': _userEmail.trim(),
              'type of donor': 'Individual',
              'address': " ",
              'reportCount': 0,
            });
          }
        } else {
          if (isNGO) {
            await FirebaseFirestore.instance
                .collection('ngo')
                .doc(authResult.user?.uid)
                .set({
              'username': _userName.trim(),
              'email': _userEmail.trim(),
              'password': _userPasswrod.trim()
            });
          } else {
            await FirebaseFirestore.instance
                .collection('receiver')
                .doc(authResult.user?.uid)
                .set({
              'username': _userName.trim(),
              'email': _userEmail.trim(),
              'password': _userPasswrod.trim()
            });
          }
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user?.uid)
            .set({'Donor': isDonor, 'NGO': isNGO});
        Navigator.of(context).pushNamed(SignIn.routeName);
      } on PlatformException catch (err) {
        if (err.message != null) {}
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: const Text("Oops something went wrong"),
                  content: FittedBox(
                      child: Column(children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ])));
            });

        setState(() {
          isLoading = false;
        });
      } catch (err) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: const Text("Oops something went wrong"),
                  content: FittedBox(
                      child: Column(children: <Widget>[
                    const Text("sorry for incovinience"),
                    IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ])));
            });

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.white54, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    TextFormField(
                      initialValue: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                      ),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _userEmail = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userEmail = value!;
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      controller: pwd,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: _showPwd
                                ? const Icon(Icons.visibility_off,
                                    color: Colors.black)
                                : const Icon(Icons.visibility,
                                    color: Colors.black),
                            onPressed: () => password(),
                          )),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      obscureText: _showPwd,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _userPasswrod = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userPasswrod = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      controller: cnfrmpwd,
                      decoration: InputDecoration(
                          labelText: '*Confirm Password',
                          suffixIcon: IconButton(
                            icon: _showCnfrmPwd
                                ? const Icon(Icons.visibility_off,
                                    color: Colors.black)
                                : const Icon(Icons.visibility,
                                    color: Colors.black),
                            onPressed: () => passwordC(),
                          )),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      obscureText: _showCnfrmPwd,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (value != pwd.text) {
                          return 'Passwrods do not match!';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    count == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'What are you?',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              CheckboxListTile(
                                title: const Text("Restaurant",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: isResto,
                                onChanged: (newValue) {
                                  setState(() {
                                    isResto = !isResto;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              CheckboxListTile(
                                title: const Text("Caterer",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: isCaterer,
                                onChanged: (newValue) {
                                  setState(() {
                                    isCaterer = !isCaterer;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              CheckboxListTile(
                                title: const Text('Individual',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: isIndividual,
                                onChanged: (newValue) {
                                  setState(() {
                                    isIndividual = !isIndividual;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              isResto
                                  ? TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Restaurant name',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      onFieldSubmitted: (value) {
                                        _userName = value;
                                        FocusScope.of(context).unfocus();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'enter a vaild name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userName = value!;
                                      },
                                    )
                                  : const Text(''),
                              isIndividual
                                  ? TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Your name',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      onFieldSubmitted: (value) {
                                        _userName = value;
                                        FocusScope.of(context).unfocus();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ' Enter a valid name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userName = value!;
                                      },
                                    )
                                  : const Text(''),
                              isCaterer
                                  ? TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Caterer name',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      onFieldSubmitted: (value) {
                                        _userName = value;
                                        FocusScope.of(context).unfocus();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ' Enter a valid name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userName = value!;
                                      },
                                    )
                                  : const Text(''),
                            ],
                          )
                        : const Text(''),
                    count == -1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'What are you?',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              CheckboxListTile(
                                title: const Text("Compost Center",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: isNGO,
                                onChanged: (newValue) {
                                  setState(() {
                                    isNGO = !isNGO;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              CheckboxListTile(
                                title: const Text('NGO/Receiver',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: isIndividual,
                                onChanged: (newValue) {
                                  setState(() {
                                    isIndividual = !isIndividual;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              isNGO
                                  ? TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Compost Center Name',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      onFieldSubmitted: (value) {
                                        _userName = value;
                                        FocusScope.of(context).unfocus();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter a vaild name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userName = value!;
                                      },
                                    )
                                  : const Text(''),
                              isIndividual
                                  ? TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Your name',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      onFieldSubmitted: (value) {
                                        _userName = value;
                                        FocusScope.of(context).unfocus();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ' Enter a valid name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userName = value!;
                                      },
                                    )
                                  : const Text(''),
                            ],
                          )
                        : const Text(''),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (count == 0)
                          firebaseUIButton(context, "Start Receiving", () {
                            FocusScope.of(context).unfocus();
                            _formKey.currentState!.validate;

                            setState(() {
                              isDonor = false;
                              count = -1;
                            });
                          }),
                        if (count == 0)
                          firebaseUIButton(context, "Start Donating", () {
                            FocusScope.of(context).unfocus();
                            _formKey.currentState!.validate;
                            setState(() {
                              isDonor = true;
                              count = 1;
                            });
                          }),
                        isLoading
                            ? Container(
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                ),
                              )
                            : count != 0
                                ? firebaseUIButton(
                                    context,
                                    "Sign Up",
                                    () {
                                      FocusScope.of(context).unfocus();
                                      _formKey.currentState!.validate()
                                          ? validation()
                                          : print('');
                                      right ? saveAll() : print('');
                                    },
                                  )
                                : const Text("")
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
