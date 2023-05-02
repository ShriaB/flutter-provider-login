import 'package:flutter/material.dart';
import 'package:mvvm_provider_login/data/network/base_api_services.dart';
import 'package:mvvm_provider_login/data/network/network_api_services.dart';
import 'package:mvvm_provider_login/repository/login_repository.dart';
import 'package:mvvm_provider_login/repository/login_repository_impl.dart';
import 'package:mvvm_provider_login/utils/routes/route_names.dart';
import 'package:mvvm_provider_login/utils/routes/routes.dart';
import 'package:mvvm_provider_login/view_model/login_view_model.dart';
import 'package:mvvm_provider_login/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// Depencdencies
    BaseApiServices apiService = NetworkApiServices();
    LoginRepository repository = LoginRepositoryImpl(apiService);

    // Provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel(repository)),
        ChangeNotifierProvider(create: (_) => UserViewModel())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: RouteNames.loading,
        onGenerateRoute: Routes.generateRoutes,
      ),
    );
  }
}
