import 'package:flasher_ui/src/screens/friends.dart';
import 'package:flasher_ui/src/screens/home.dart';
import 'package:flasher_ui/src/screens/movie_swipe.dart';
import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/screens/settings.dart';
import 'package:flasher_ui/src/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flasher_ui/src/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  runApp( App(supabase: supabase));
}

class App extends StatelessWidget {
  const App({Key? key, required this.supabase}) : super(key: key);
  final SupabaseClient supabase;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flashr',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF31531),
        ),
        scaffoldBackgroundColor: Colors.black, // Hintergrundfarbe
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 25), // Innenabstand anpassen
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          )
        ),

      ),
        initialRoute: '/', routes: <String, WidgetBuilder>{
        '/': (_) => SplashPage(supabase: supabase),
        '/login': (_) => LoginScreen(supabase: supabase),
        '/homepage': (_) => HomePage(supabase: supabase),
        '/profile': (_) => const ProfilePage(),
        '/movieswipe': (_) => const MovieSwipe(),
        '/friends': (_) => const Friends(),
        '/settings': (_) => const Settings(),
    }
    );
  }
}




