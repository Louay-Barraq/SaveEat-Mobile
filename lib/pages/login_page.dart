import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:save_eat/components/double_name_display_widget.dart';
import 'package:save_eat/components/title_with_subtitle_widget.dart';
import 'package:save_eat/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 150),
                /*
                Text(
                  "SAVE EAT",
                  style: const TextStyle(
                    letterSpacing: 4,
                    fontFamily: "Inconsolata",
                    fontWeight: FontWeight.w500,
                    fontSize: 36,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                */
                const SizedBox(height: 50),

                const TitleWithSubtitleWidget(
                  title: "Save Eat",
                  subtitle: "Login",
                ),

                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCCCCC),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  color: Color(0x3F000000),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Robot Name",
                                style: const TextStyle(
                                  fontFamily: 'Inconsolata',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  color: Color(0x3F000000),
                                )
                              ]
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: _nameController,
                                validator: (v) => v == null || v.isEmpty ? 'Enter robot name' : null,
                                style: TextStyle(
                                  fontFamily: 'Inconsolata',
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,          // Default border
                                  focusedBorder: InputBorder.none,   // When focused
                                  enabledBorder: InputBorder.none,   // When enabled
                                  errorBorder: InputBorder.none,     // When error is shown
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,

                                ),
                                ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCCCCC),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  color: Color(0x3F000000),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Robot Password",
                                style: const TextStyle(
                                  fontFamily: 'Inconsolata',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    color: Color(0x3F000000),
                                  )
                                ]
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                validator: (v) =>
                                v == null || v.isEmpty ? 'Enter password' : null,
                                style: TextStyle(
                                  fontFamily: 'Inconsolata',
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,          // Default border
                                  focusedBorder: InputBorder.none,   // When focused
                                  enabledBorder: InputBorder.none,   // When enabled
                                  errorBorder: InputBorder.none,     // When error is shown
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Robot name field is empty.',
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  if (_passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Robot password field is empty.',
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  if (_formKey.currentState!.validate()) {
                    setState(() => _loading = true);
                    final ok = await Provider.of<AuthProvider>(context, listen: false)
                        .login(_nameController.text, _passwordController.text);
                    setState(() => _loading = false);

                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Invalid Credentials',
                            style: TextStyle(color: Colors.white, fontSize: 17.0),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Logged in successfully',
                            style: TextStyle(color: Colors.white, fontSize: 17.0),
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    };
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(color: Colors.white),
                  minimumSize: Size.fromHeight(50),
                ),
                child: const Text(
                    'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
              ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
