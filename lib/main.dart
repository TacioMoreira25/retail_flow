import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/services/isar_service.dart';
import 'data/services/notification_service.dart';
import 'ui/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa serviços
  final isarService = IsarService();
  final notificationService = NotificationService();

  await notificationService.init();

  GetIt.I.registerSingleton<IsarService>(isarService);
  GetIt.I.registerSingleton<NotificationService>(notificationService);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corDaMarca = Color(0xFFB71C1C);

    return MaterialApp(
      title: 'Tânia Modas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: corDaMarca,
          primary: corDaMarca,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: corDaMarca,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: const HomeScreen(),
    );
  }
}
