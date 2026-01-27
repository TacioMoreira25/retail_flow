import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz_core;
import 'data/services/notification_service.dart';
import 'data/services/isar_service.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/home/home_screen.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<IsarService>(IsarService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await setupDependencies();
  await getIt<NotificationService>().init();

  runApp(const RetailFlowApp());
}

class RetailFlowApp extends StatelessWidget {
  const RetailFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tânia Modas',
      debugShowCheckedModeBanner: false,

      // AQUI A MÁGICA: Aplica o tema vermelho e a fonte Montserrat em tudo
      theme: AppTheme.lightTheme,

      home: const HomeScreen(), // Aponta para a navegação
    );
  }
}
