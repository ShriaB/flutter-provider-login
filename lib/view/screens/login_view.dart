import 'package:flutter/material.dart';
import 'package:mvvm_provider_login/data/response/status.dart';
import 'package:mvvm_provider_login/utils/routes/route_names.dart';
import 'package:mvvm_provider_login/utils/utils.dart';
import 'package:mvvm_provider_login/utils/validators.dart';
import 'package:mvvm_provider_login/view/styles/styles.dart';
import 'package:mvvm_provider_login/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isEmailValid = ValueNotifier<bool>(true);
  bool _isPasswordValid = true;

  String emailErrorText = "";

  void login(context) async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    _isEmailValid.value = Validators.isEmailFormatValid(emailController.text);

    setState(() {
      _isPasswordValid = Validators.isPasswordValid(passwordController.text);
    });

    if (_isEmailValid.value && _isPasswordValid) {
      await viewModel.login(emailController.text, passwordController.text);

      if (viewModel.data?.status == Status.SUCCESS) {
        Navigator.pushReplacementNamed(context, RouteNames.home);
        Utils.showGreenSnackBar(context, "You are successfully Logged in");
      } else {
        if (viewModel.data?.error == Error.UNAUTHORISED) {
          Utils.showRedSnackBar(context, "Please enter valid credentials");
        } else if (viewModel.data?.error == Error.CONNECTION) {
          Utils.showRedSnackBar(
              context, "Please check your Internet Connectivity");
        } else {
          Utils.showRedSnackBar(
              context, "Some error occured! Please try after some time");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
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
              ValueListenableBuilder(
                valueListenable: _isEmailValid,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onFieldSubmitted: (value) {
                      _isEmailValid.value =
                          Validators.isEmailFormatValid(emailController.text);
                      Utils.changeFocus(
                          context, emailFocusNode, passwordFocusNode);
                    },
                    decoration: InputDecoration(
                        border: textInputDecorationBorder,
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        errorText: _isEmailValid.value
                            ? null
                            : "Please enter a valid email address: example@domain.com"),
                    keyboardType: TextInputType.emailAddress,
                  );
                },
              ),
              const SizedBox(
                height: 20.0,
              ),

              /// Password text field
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
                          _obscurePassword.value = !_obscurePassword.value;
                        },
                        child: (value == false)
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      errorText: _isPasswordValid
                          ? null
                          : "Password should contain atleat 6 characters",
                    ),
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
                    login(context);
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),

              const SizedBox(
                height: 20.0,
              ),

              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, RouteNames.signup);
                },
                child: const Center(
                    child: Text("Do not have an account? Sign Up.")),
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
