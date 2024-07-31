import 'package:buddy_guardian/game/flappy_game.dart';
import 'package:buddy_guardian/provider/login_provider.dart';
import 'package:buddy_guardian/provider/register_provider.dart';
import 'package:buddy_guardian/routes/app_routes.dart';
import 'package:buddy_guardian/routes/routes.dart';
import 'package:buddy_guardian/screens/game_over.dart';
import 'package:buddy_guardian/screens/main_menu.dart';
import 'package:buddy_guardian/services/local_storage.dart';
import 'package:buddy_guardian/services/push_notification_service.dart';
import 'package:buddy_guardian/utils/orientacion.dart';
import 'package:buddy_guardian/utils/utils_snackbar.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Intl.defaultLocale = 'es';
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  await LocalStorage().init();
  final isLoggedIn = LocalStorage().getIsLoggedIn();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await Flame.device.fullScreen();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => LoginProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => RegisterProvider()),
      ],
      child: MaterialApp(
        // navigatorKey: NavigationServices.navigatorKey,
        navigatorObservers: [OrientationResetObserver()],
        scaffoldMessengerKey: NotificationService.messengerKey,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('es', 'ES'),
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
        // routes: appRoutes,
        routes: {
          ...appRoutes,
          '/game': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            final game = FlappyBirdGame();
            return GameWidget(
              game: game,
              initialActiveOverlays: const [
                'mainMenu',
              ],
              overlayBuilderMap: {
                'mainMenu': (context, _) =>
                    MainMenuScreen(game: game, userData: args['userData']),
                'gameOver': (context, _) =>
                    GameOverScreen(game: game, userData: args['userData']),
              },
            );
          },
        },
      ),
    );
  }
}
