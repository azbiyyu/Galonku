import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:galonku/DepotPage/bayar_galon.dart';
import 'package:galonku/DepotPage/chat_list.dart';
import 'package:galonku/DepotPage/chat_page.dart';
import 'package:galonku/DepotPage/detail_depot.dart';
import 'package:galonku/DepotPage/home_page_depot.dart';
import 'package:galonku/DepotPage/home_page_user.dart';
import 'package:galonku/DepotPage/home_user.dart';
import 'package:galonku/DepotPage/pesan_galon_lokasi.dart';
import 'package:galonku/DepotPage/pesan_galon_produk.dart';
import 'package:galonku/DepotPage/pesanan_depot.dart';
import 'package:galonku/DepotPage/pesanan_user.dart';
import 'package:galonku/DepotPage/settings_depot.dart';
import 'package:galonku/DepotPage/settings_user.dart';
import 'package:galonku/DesignSystem/_lupa_sandi.dart';
import 'package:galonku/DesignSystem/_syarat_ketentuan.dart';
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
import 'DepotPage/EditLocationPage.dart';
import 'LandingPage/splash_screen.dart';

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
    String selectedusername = '';
    String selectedemail = '';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
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
        Verifikasi.nameRoute: (context) => Verifikasi(
              isFromUserSignIn: true,
            ),
        PesananDepot.nameRoute: (context) => PesananDepot(),
        PesananUser.nameRoute: (context) => PesananUser(),
        HomeUser.nameRoute: (context) => HomeUser(),
        SettingsDepot.nameRoute: (context) => SettingsDepot(),
        SettingsUser.nameRoute: (context) => SettingsUser(),
        LupaSandi.nameRoute: (context) => LupaSandi(),
        SyaratKetentuan.nameRoute: (context) => SyaratKetentuan(),
        EditLocationPage.nameRoute: (context) => EditLocationPage(),
        DetailDepot.nameRoute: (context) => DetailDepot(email: selectedemail),
        // ignore: equal_keys_in_map
        ChatPage.nameRoute:(context) => ChatPage(email: selectedusername),
        PesanGalonLokasi.nameRoute:(context) => PesanGalonLokasi(email: selectedemail),
        PesanGalonProduk.nameRoute:(context) => PesanGalonProduk(email: selectedemail),
        BayarGalon.nameRoute:(context) => BayarGalon(),
        ChatList.nameRoute:(context) => ChatList()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/landingpage') {
          return MaterialPageRoute(builder: (context) => LoginRole());
        }
        return null;
      },
    );
  }
}
