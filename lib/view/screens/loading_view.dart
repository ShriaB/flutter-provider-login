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
  void isUserLoggedIn(context) async {
    final viewModel = Provider.of<UserViewModel>(context, listen: false);
    await viewModel.getUser();
    if (viewModel.user != null) {
      Navigator.pushReplacementNamed(context, RouteNames.home);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    isUserLoggedIn(context);
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
