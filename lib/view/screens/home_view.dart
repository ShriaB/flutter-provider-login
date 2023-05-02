import 'package:flutter/material.dart';
import 'package:mvvm_provider_login/utils/routes/route_names.dart';
import 'package:mvvm_provider_login/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Home Screen"),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
              onPressed: () {
                userViewModel.clearUser();
                Navigator.pushReplacementNamed(context, RouteNames.login);
              },
              child: const Text("Logout"))
        ],
      )),
    );
  }
}
