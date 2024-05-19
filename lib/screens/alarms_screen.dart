import 'package:flutter/material.dart';
import 'package:flutter_medicare_reminder/_common/alarm_modal.dart';
import 'package:flutter_medicare_reminder/_common/dependent_modal.dart';
import 'package:flutter_medicare_reminder/models/alarm.dart';
import 'package:flutter_medicare_reminder/models/user.dart';
import 'package:flutter_medicare_reminder/services/dependent_service.dart';
import 'package:intl/intl.dart';

class AlarmsScreen extends StatefulWidget {
  final UserModel userModel;
  const AlarmsScreen({super.key, required this.userModel});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final List<AlarmModel> alarmList = [
    AlarmModel(
        id: '1',
        name: 'Dipirona',
        description: 'Tomar 30 gotas',
        hour: 13,
        minute: 30)
  ];

  final DependentService service = DependentService();

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
              showUserModal(context, user: widget.userModel);
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
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 15),
                textColor: Colors.white,
                title: const Text('Novo Alarme'),
                leading: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onTap: () {
                  showAlarmModal(context, widget.userModel.id);
                },
              ),
            ),
            StreamBuilder(
              stream: service.connectStreamAlarm(widget.userModel.id),
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
                      alarmList.add(AlarmModel.fromMap(doc.data()));
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
                              trailing: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                showAlarmModal(context, widget.userModel.id,
                                    alarm: alarm);
                              },
                            ),
                          );
                        }),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Nenhum dependente cadastrado',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
