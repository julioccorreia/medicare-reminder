import 'package:flutter/material.dart';
import 'package:flutter_medicare_reminder/models/alarm.dart';
import 'package:flutter_medicare_reminder/models/user.dart';

class AlarmsScreen extends StatelessWidget {
  final UserModel userModel;
  AlarmsScreen({super.key, required this.userModel});

  final List<AlarmModel> alarmList = [
    AlarmModel(
        id: '1',
        fkUser: '123',
        fkUserDependent: '1',
        name: 'Dipirona',
        description: 'Tomar 30 gotas',
        date: DateTime.now())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          userModel.name,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Transform.flip(
            flipX: true,
            child: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
          onPressed: () {},
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: List.generate(alarmList.length, (index) {
            AlarmModel alarm = alarmList[index];
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
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                trailing: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
