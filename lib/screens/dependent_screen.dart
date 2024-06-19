import 'package:flutter/material.dart';
import 'package:flutter_medicare_reminder/_common/alarm_modal.dart';
import 'package:flutter_medicare_reminder/_common/dependent_modal.dart';
import 'package:flutter_medicare_reminder/models/alarm.dart';
import 'package:flutter_medicare_reminder/models/user.dart';
import 'package:flutter_medicare_reminder/notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_medicare_reminder/services/dependent_service.dart';
import 'package:time_listener/time_listener.dart';

class DependentScreen extends StatefulWidget {
  final UserModel userModel;
  final String idParent;
  const DependentScreen(
      {super.key, required this.userModel, required this.idParent});

  @override
  State<DependentScreen> createState() => _DependentScreenState();
}

class _DependentScreenState extends State<DependentScreen> {
  final DependentService service = DependentService();
  late UserModel _userModel;
  late String _idParent;
  List<AlarmModel> alarms = [];
  final TimeListener listener = TimeListener();

  @override
  void initState() {
    super.initState();
    _userModel = widget.userModel;
    _idParent = widget.idParent;

    listener.listen((DateTime dt) {
      if (alarms.isNotEmpty) {
        for (var alarm in alarms) {
          if (alarm.hour == dt.hour && alarm.minute == dt.minute) {
            Notifications.showInstantNotification(
              alarm.name,
              alarm.description ?? 'Hora de cuidar disso!',
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.userModel.name,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            listener.cancel();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              showDependentModal(context, user: _userModel);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
              stream: service.connectStreamAlarm(_userModel.id, _idParent),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<AlarmModel> alarmList = [];

                    for (var doc in snapshot.data!.docs) {
                      AlarmModel alarm = AlarmModel.fromMap(doc.data());
                      alarmList.add(alarm);
                      alarms.add(alarm);
                    }

                    return Expanded(
                      child: ListView(
                        children: List.generate(alarmList.length, (index) {
                          AlarmModel alarm = alarmList[index];
                          final currentDate = DateTime.now();
                          final formattedTime = DateFormat.Hm().format(
                            DateTime(
                              currentDate.year,
                              currentDate.month,
                              currentDate.day,
                              alarm.hour,
                              alarm.minute,
                            ),
                          );
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 15),
                              textColor: Colors.white,
                              title: Text(alarm.name),
                              leading: Text(
                                formattedTime,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Nenhum alarme cadastrado',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Notifications.showInstantNotification(
                    'Dipirona', 'Tomar 40 gotas');
              },
              child: const Text('Exemplo Notificação'),
            ),
          ],
        ),
      ),
    );
  }
}
