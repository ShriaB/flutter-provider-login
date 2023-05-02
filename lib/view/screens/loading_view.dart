import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvvm_provider_login/utils/routes/route_names.dart';
import 'package:mvvm_provider_login/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  /// Checks if user is already logged in using UserViewModel
  /// If user logged in then redirects to home page
  /// Else goes to login page with a delay of 2 seconds
  Future<void> isUserLoggedIn() async {
    final viewModel = Provider.of<UserViewModel>(context, listen: false);
    bool isUserLoggedIn = await viewModel.getUser();
    Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      if (isUserLoggedIn) {
        Navigator.pushReplacementNamed(context, RouteNames.home);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    }
  }

  @override
  void initState() {
    isUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// While it checks if user is logged in or not a spinner is displayed
    return const Scaffold(
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
