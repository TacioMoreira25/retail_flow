import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inicialização do serviço
  Future<void> init() async {
    tz.initializeTimeZones();
    // Define o fuso horário local
    tz.setLocalLocation(tz.local);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    // Solicita permissão no Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // --- AGENDAMENTO DUPLO (08:00 e 14:00) ---

  Future<void> scheduleBoletoAlert(
    int id,
    String fornecedor,
    DateTime vencimento,
  ) async {
    // Garante que usamos o ano/mês/dia do vencimento, mas fixamos a hora
    final dataManha = DateTime(
      vencimento.year,
      vencimento.month,
      vencimento.day,
      8,
      0,
    );
    final dataTarde = DateTime(
      vencimento.year,
      vencimento.month,
      vencimento.day,
      14,
      0,
    );

    // Alarme 1: Manhã (Usa o ID original do boleto)
    await _agendarNotificacao(
      id: id,
      titulo: "Conta Vencendo Hoje! ☀️",
      corpo: "Pagar $fornecedor agora de manhã para não esquecer.",
      data: dataManha,
    );

    // Alarme 2: Tarde (Usa ID + 100000 para ser um alarme diferente)
    await _agendarNotificacao(
      id: id + 100000,
      titulo: "Última chance! 🕑",
      corpo: "Já pagou a conta da $fornecedor? O dia está acabando.",
      data: dataTarde,
    );
  }

  Future<void> _agendarNotificacao({
    required int id,
    required String titulo,
    required String corpo,
    required DateTime data,
  }) async {
    // Se a hora já passou (ex: criou o boleto às 09:00, o alarme das 08:00 não deve tocar)
    if (data.isBefore(DateTime.now())) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      titulo,
      corpo,
      tz.TZDateTime.from(data, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'boleto_channel_id',
          'Lembretes de Contas',
          channelDescription: 'Notificações de vencimento de boletos',
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFFE53935), // Vermelho
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancela AMBOS os alarmes (manhã e tarde)
  Future<void> cancelBoletoAlert(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    await flutterLocalNotificationsPlugin.cancel(id + 100000);
  }
}
