import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _notifications.initialize(settings);
  }

  // Agenda o aviso para o dia do vencimento
  Future<void> scheduleBoletoAlert(
    int id,
    String fornecedor,
    DateTime data,
  ) async {
    await _notifications.zonedSchedule(
      id,
      'Vencimento Hoje!',
      'Pagar boleto de $fornecedor',
      tz.TZDateTime.from(
        data,
        tz.local,
      ).add(const Duration(hours: 8)), // Avisa às 08:00
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'boletos_channel',
          'Alertas de Boletos',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
