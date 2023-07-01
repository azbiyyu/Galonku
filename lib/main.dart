import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:galonku/DepotPage/home_page_depot.dart';
import 'package:galonku/DepotPage/home_page_user.dart';
import 'package:galonku/DepotPage/home_user.dart';
import 'package:galonku/DepotPage/pesanan_depot.dart';
import 'package:galonku/DepotPage/pesanan_user.dart';
import 'package:galonku/DepotPage/settings_depot.dart';
import 'package:galonku/DepotPage/settings_user.dart';
import 'package:galonku/LandingPage/landingpage.dart';
import 'package:galonku/LandingPage/login_role.dart';
import 'package:galonku/LoginPage/mitra_input.dart';
import 'package:galonku/LoginPage/mitra_login.dart';
import 'package:galonku/LoginPage/mitra_signin.dart';
import 'package:galonku/LoginPage/user_login.dart';
import 'package:galonku/LoginPage/user_signin.dart';
import 'package:galonku/LoginPage/verifikasi.dart';
import 'package:provider/provider.dart';
import 'Controllers/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider<SharedPreferencesHelper>(
      create: (_) => SharedPreferencesHelper(),
      child: MyApp(),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  bool isLoggedIn = false;
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      initialRoute: '/',
      routes: {
        LandingPage.nameRoute: (context) => LandingPage(),
        LoginRole.nameRoute: (context) => LoginRole(),
        UserSignIn.nameRoute: (context) => UserSignIn(),
        UserLogin.nameRoute: (context) => UserLogin(),
        MitraSignIn.nameRoute: (context) => MitraSignIn(),
        MitraLogin.nameRoute: (context) => MitraLogin(),
        MitraInput.nameRoute: (context) => MitraInput(),
        HomePageUser.nameRoute: (context) => HomePageUser(),
        HomePageDepot.nameRoute: (context) => HomePageDepot(),
        Verifikasi.nameRoute: (context) => Verifikasi(isFromUserSignIn: true,),
        PesananDepot.nameRoute: (context) => PesananDepot(),
        PesananUser.nameRoute: (context) => PesananUser(),
        HomeUser.nameRoute: (context) => HomeUser(),
        SettingsDepot.nameRoute: (context) => SettingsDepot(),
        SettingsUser.nameRoute: (context) => SettingsUser(),
      },
      onGenerateRoute: (settings) {
        if(settings.name == '/landingpage'){
          return MaterialPageRoute(builder: (context) => LoginRole());
        }
        return null;
      },
    );
  }
}
