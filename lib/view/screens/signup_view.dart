import 'package:flutter/material.dart';
import 'package:mvvm_provider_login/data/response/status.dart';
import 'package:mvvm_provider_login/utils/routes/route_names.dart';
import 'package:mvvm_provider_login/utils/utils.dart';
import 'package:mvvm_provider_login/utils/validators.dart';
import 'package:mvvm_provider_login/view/styles/styles.dart';
import 'package:mvvm_provider_login/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isEmailValid = ValueNotifier<bool>(true);
  bool _isPasswordValid = true;

  String emailErrorText = "";

  void signup(context) async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    _isEmailValid.value = Validators.isEmailFormatValid(emailController.text);

    setState(() {
      _isPasswordValid = Validators.isPasswordValid(passwordController.text);
    });

    if (_isEmailValid.value && _isPasswordValid) {
      await viewModel.signup(emailController.text, passwordController.text);
      if (viewModel.data?.status == Status.SUCCESS) {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SignUp"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Email text field
              TextFormField(
                controller: emailController,
                focusNode: emailFocusNode,
                onFieldSubmitted: (value) {
                  Utils.changeFocus(context, emailFocusNode, passwordFocusNode);
                },
                decoration: InputDecoration(
                  border: textInputDecorationBorder,
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(
                height: 20.0,
              ),

              /// Password text fiel
              ValueListenableBuilder(
                valueListenable: _obscurePassword,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    decoration: InputDecoration(
                        border: textInputDecorationBorder,
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _obscurePassword.value = !_obscurePassword.value;
                            });
                          },
                          child: (value == false)
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        )),
                    obscureText: value,
                  );
                },
              ),

              const SizedBox(
                height: 20.0,
              ),

              /// Login Button
              ElevatedButton.icon(
                  style: textButtonStyle,
                  onPressed: () {
                    signup(context);
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "SignUp",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),

              const SizedBox(
                height: 20.0,
              ),

              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, RouteNames.login);
                },
                child: const Center(
                    child: Text("Already have an account? Login.")),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _obscurePassword.dispose();
  }
}
