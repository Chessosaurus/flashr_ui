import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flasher_ui/src/screens/login.dart';
import 'package:flasher_ui/src/screens/home.dart';
import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/screens/movie_swipe.dart';
import 'package:flasher_ui/src/screens/friends.dart';
import 'package:flasher_ui/src/screens/settings.dart';
import 'package:flasher_ui/src/screens/search_result.dart';
import 'package:flasher_ui/src/screens/groups.dart';
import 'package:flasher_ui/src/screens/requests.dart';
import 'package:flasher_ui/src/screens/splash.dart';
import 'package:flasher_ui/src/screens/qr_code.dart';
import 'package:flasher_ui/src/screens/search_friend_result.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load .env
  await dotenv.load(fileName: 'assets/.env');
  String supabaseBaseUrl = dotenv.env['SUPABASE_BASE_URL'] ?? '';
  String supabaseBaseKey = dotenv.env['SUPABASE_BASE_KEY'] ?? '';

  await Supabase.initialize(
    url: supabaseBaseUrl,
    anonKey: supabaseBaseKey,
    debug: false,
  );

  final supabase = Supabase.instance.client;
  runApp(App(supabase: supabase));
}

class App extends StatelessWidget {
  const App({Key? key, required this.supabase}) : super(key: key);
  final SupabaseClient supabase;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'flashr',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFF31531),
          ),
          scaffoldBackgroundColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 25),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              )
          ),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (_) => SafeArea(child: SplashPage(supabase: supabase)),
          '/login': (_) => SafeArea(child: LoginScreen(supabase: supabase)),
          '/homepage': (_) => SafeArea(child: HomePage(supabase: supabase)),
          '/profile': (_) => SafeArea(child: ProfilePage()),
          '/movieswipe': (_) => SafeArea(child: MovieSwipe()),
          '/friends': (_) => SafeArea(child: Friends()),
          '/settings': (_) => SafeArea(child: Settings()),
          '/search': (_) => SafeArea(child: SearchPage()),
          '/groups': (_) => SafeArea(child: Groups()),
          '/requests': (_) => SafeArea(child: Requests()),
          '/qr_code': (_) => SafeArea(child: QRScreens()),
          '/friend_search': (_) => SafeArea(child: SearchFriendPage()),
        }
    );
  }
}
