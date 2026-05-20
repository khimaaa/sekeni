import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'services/app_state.dart';
import 'services/locale_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Consumer<LocaleService>(
        builder: (context, locale, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sekeni',
            theme: ThemeData(
              fontFamily: locale.isArabic ? null : 'Roboto',
              scaffoldBackgroundColor: const Color(0xFFF8F9FA),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF007A3D),
              ),
            ),
            builder: (context, child) {
              return Directionality(
                textDirection: locale.textDirection,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
