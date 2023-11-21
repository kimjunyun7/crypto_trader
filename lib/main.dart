import 'package:crypto_trader/screens/home_screen.dart';
import 'package:crypto_trader/screens/login_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  /// 구글 폰트 라이센스
//   LicenseRegistry.addLicense(() async* {
//     final license = await rootBundle.loadString('google_fonts/OFL.txt');
//     yield LicenseEntryWithLineBreaks(['google_fonts'], license);
//   });
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
        // textTheme: GoogleFonts.latoTextTheme(textTheme),
        scheme: FlexScheme.money,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          bottomNavigationBarElevation: 24.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      routerConfig: _router,
      // routerDelegate: _router.routerDelegate,
      // routeInformationParser: _router.routeInformationParser,
      // routeInformationProvider: _router.routeInformationProvider,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
    ],
  );
}
