import 'dart:io';
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

    if (Platform.isAndroid) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleBoletoAlert(
    int id,
    String fornecedor,
    DateTime data,
  ) async {
    // Garantimos que a data seja meio-dia para evitar problemas de fuso no alarme
    final scheduledDate = DateTime(data.year, data.month, data.day, 12, 0);

    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    await _notifications.zonedSchedule(
      id,
      'Vencimento Hoje!',
      'Pagar boleto de $fornecedor',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'boletos_channel',
          'Alertas de Boletos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelBoletoAlert(int id) async {
    await _notifications.cancel(id);
    print("Alarme do boleto $id cancelado!");
  }
}
