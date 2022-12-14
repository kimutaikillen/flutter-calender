import 'package:flutter/material.dart';
import 'package:lesson03/repositories/cal_repo_interface.dart';
import '/screens/splash/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '/repositories/cal_repo.dart';
import '/providers/session_provider.dart';
import '/screens/cal_pager/cal_pager.dart';
import '/screens/intro/intro.dart';
import '/screens/login_options/login_options.dart';

class App extends StatelessWidget {
  final State<Splash> splashState;

  const App(this.splashState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steady Calendar',
      initialRoute: Splash.routeName,
      routes: {
        Splash.routeName: (context) => Splash(splashState),
        CalPager.routeName: (context) => const CalPager(),
        Intro.routeName: (context) => const Intro(),
        LoginOptions.routeName: (context) => const LoginOptions(),
      },
    );
  }
}

/// Performs initialization steps and then runs our app.
Future<void> runAppWithOptions({String envFileName = '.env',
CalRepoInterface calendarRepository = const CalendarRepository(), 
  required State<Splash> splashState}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await load(fileName: envFileName);

  await Supabase.initialize(
      url: 'https://${env['SUPABASE_PROJECT_ID']!}.supabase.co',
      anonKey: env['SUPABASE_ANON_KEY']!,
      debug: false);

  runApp(ChangeNotifierProvider(
      create: (context) => SessionProvider(calendarRepository),
      child: App(splashState)));
}

