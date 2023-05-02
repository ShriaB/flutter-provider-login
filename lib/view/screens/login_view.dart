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
  /// TextEditingControllers for TextFormFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Focus nodes for TextFormFields
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  /// If email had valid format after email validation and accordingly error text is displayed
  final ValueNotifier<bool> _isEmailValid = ValueNotifier<bool>(true);

  /// If password should be hidden or not
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(false);
  // If password has a valid format or not after password validation
  bool _isPasswordValid = true;

  /// Checks if email and password have a valid format
  /// If not valid then display error messages
  /// If valid then calls the login() of viewModel
  /// If request is successful then navigates to Home screen
  /// Else displays snackbars to give feedback to the user that request failed
  void login() async {
    print("In login");
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    _isEmailValid.value = Validators.isEmailFormatValid(_emailController.text);

    setState(() {
      _isPasswordValid = Validators.isPasswordValid(_passwordController.text);
    });

    if (_isEmailValid.value && _isPasswordValid) {
      await viewModel.login(_emailController.text, _passwordController.text);

      if (context.mounted) {
        if (viewModel.data?.status == Status.SUCCESS) {
          Navigator.pushReplacementNamed(context, RouteNames.home);
          Utils.showGreenSnackBar(context, "You are successfully Logged in");
        } else {
          if (viewModel.data?.error == Error.UNAUTHORISED) {
            Utils.showRedSnackBar(context, "Please enter valid credentials");
          } else if (viewModel.data?.error == Error.NO_INTERNET) {
            Utils.showRedSnackBar(
                context, "Please check your Internet Connectivity");
          } else {
            Utils.showRedSnackBar(
                context, "Some error occured! Please try after some time");
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        /// Appbar
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
                /// Listening to [_isEmailValid] for displaying error messages
                valueListenable: _isEmailValid,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onFieldSubmitted: (value) {
                      _isEmailValid.value =
                          Validators.isEmailFormatValid(_emailController.text);
                      Utils.changeFocus(
                          context, _emailFocusNode, _passwordFocusNode);
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
                /// Listening to [_obscurePassword] for hidding and showing the password
                valueListenable: _obscurePassword,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
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
                    print("Button pressed");
                    login();
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

              /// Sign Up text
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
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _obscurePassword.dispose();
    _isEmailValid.dispose();
  }
}
