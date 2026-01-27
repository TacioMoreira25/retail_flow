import 'dart:io'; // Para checar se é Android
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

    //Pedir permissão de alarme exato no Android
    if (Platform.isAndroid) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // Isso solicita ao usuário a permissão se ela não existir
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
      // Se a data já passou, não agenda o alarme ou agenda para daqui a 1 minuto
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
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // O causador do erro
    );
  }

  Future<void> cancelBoletoAlert(int id) async {
    await _notifications.cancel(id);
    print("Alarme do boleto $id cancelado!");
  }
}
