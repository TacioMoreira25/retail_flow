import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/data/latest.dart' as tz; // Dados de fuso horário
import 'package:timezone/timezone.dart' as tz_core;
import 'data/services/notification_service.dart';
import 'data/services/isar_service.dart';
import 'ui/dashboard/widgets/dashboard_screen.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Registra o Serviço de Notificações (Singleton = única instância pro app)
  getIt.registerSingleton<NotificationService>(NotificationService());

  // Registra o Isar (Banco de Dados)
  getIt.registerSingleton<IsarService>(IsarService());
}

void main() async {
  // 2. Garante que a engine do Flutter está pronta
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Inicializa os dados de Fuso Horário
  tz.initializeTimeZones();
  // Define o local padrão
  // tz_core.setLocalLocation(tz_core.getLocation('America/Sao_Paulo'));

  // 4. Inicializa seus serviços e banco de dados
  await setupDependencies();

  // Inicializa o plugin de notificações especificamente
  await getIt<NotificationService>().init();

  runApp(const RetailFlowApp());
}

class RetailFlowApp extends StatelessWidget {
  const RetailFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RetailFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
