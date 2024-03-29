import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/helper/colors.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/widgets/bottombar.dart';
import 'package:lottie/lottie.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({super.key});

  final _nameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.4,
                width: double.infinity,
                child: Lottie.asset(
                  'assets/Animation - 1702389671540.json',
                  fit: BoxFit.fill,
                  width: screenWidth * 1,
                  height: screenHeight * 0.6,
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  height: screenHeight * 0.6,
                  width: double.infinity,
                  color: GreenColor.green,
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const Center(
                              child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: YellowColor.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          )),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Value is empty';
                              } else {
                                return null;
                              }
                            },
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'NAME',
                              labelStyle: TextStyle(color: YellowColor.yellow),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Value is empty';
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(color: YellowColor.yellow),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                checkLogin(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.03,
                                    horizontal: screenWidth * 0.05),
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: GreenColor.green,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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

  void checkLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final username = _nameController.text;
      final password = _passwordController.text;
      if (username == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScreenBtm()),
        );
        final sharedPrefs = await SharedPreferences.getInstance();
        await sharedPrefs.setBool(saveKey, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Username and password do not match',
            style: TextStyle(color: GreenColor.green),
          ),
          margin: EdgeInsets.all(8),
          duration: Duration(seconds: 3),
          backgroundColor: YellowColor.yellow,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }
}
