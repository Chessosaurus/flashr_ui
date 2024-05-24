import 'package:flasher_ui/src/screens/friend_details.dart';
import 'package:flasher_ui/src/screens/group_detail.dart';
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
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return CustomPageRoute(builder: (_) => SafeArea(child: SplashPage(supabase: supabase)));
          case '/login':
            return CustomPageRoute(builder: (_) => SafeArea(child: LoginScreen(supabase: supabase)));
          case '/homepage':
            return CustomPageRoute(builder: (_) => SafeArea(child: HomePage()));
          case '/profile':
            return SlidePageRoute(builder: (_) => SafeArea(child: ProfilePage()));
          case '/movieswipe':
            return CustomPageRoute(builder: (_) => SafeArea(child: MovieSwipe()));
          case '/friends':
            return CustomPageRoute(builder: (_) => SafeArea(child: Friends()));
          case '/settings':
            return CustomPageRoute(builder: (_) => SafeArea(child: Settings()));
          case '/search':
            return SlidePageRoute(builder: (_) => SafeArea(child: SearchPage()));
          case '/groups':
            return CustomPageRoute(builder: (_) => SafeArea(child: Groups()));
          case '/requests':
            return CustomPageRoute(builder: (_) => SafeArea(child: Requests()));
          case '/qr_code':
            return CustomPageRoute(builder: (_) => SafeArea(child: QRScreens()));
          case '/friend_search':
            return SlidePageRoute(builder: (_) => SafeArea(child: SearchFriendPage()));
          case '/slide_to_home':
            return SlideDownPageRoute(builder: (_) => SafeArea(child: HomePage()));
          case '/slide_to_friends':
            return SlideDownPageRoute(builder: (_) => SafeArea(child: Friends()));
          case '/group_detail':
            return SlideDownPageRoute(builder: (_) => SafeArea(child: GroupDetailPage(groupId: 1,)));
          case '/friend_detail':
            return SlideDownPageRoute(builder: (_) => SafeArea(child: FriendDetailPage()));
          default:
            return null;
        }
      },
    );
  }
}

class CustomPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  CustomPageRoute({required this.builder});

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  SlidePageRoute({required this.builder})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
class SlideDownPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  SlideDownPageRoute({required this.builder})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, -1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
