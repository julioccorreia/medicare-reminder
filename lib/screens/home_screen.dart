import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medicare_reminder/_common/dependent_modal.dart';
import 'package:flutter_medicare_reminder/models/user.dart';
import 'package:flutter_medicare_reminder/screens/alarms_screen.dart';
import 'package:flutter_medicare_reminder/services/authentication_service.dart';
import 'package:flutter_medicare_reminder/services/user_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService service = UserService();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    tzdata.initializeTimeZones();
    final location = tz.getLocation('America/Sao_Paulo');
    final now = tz.TZDateTime.now(location);
    String formattedMonth =
        DateFormat.MMMM('pt_BR').format(now)[0].toUpperCase() +
            DateFormat.MMMM('pt_BR').format(now).substring(1);
    String formattedDate =
        "${DateFormat('dd').format(now)} de $formattedMonth - ${DateFormat('yyyy').format(now)}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          formattedDate,
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
          onPressed: () {
            AuthenticationService().logout();
          },
        ),
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
                title: const Text('Novo Dependente'),
                leading: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onTap: () {
                  showDependentModal(context); 
                },
              ),
            ),
            StreamBuilder(
              stream: service.connectStreamDependent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<UserModel> dependentList = [];

                    for (var doc in snapshot.data!.docs) {
                      dependentList.add(UserModel.fromMap(doc.data()));
                    }

                    return Expanded(
                      child: ListView(
                        children: List.generate(dependentList.length, (index) {
                          UserModel userModel = dependentList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 15),
                              textColor: Colors.white,
                              title: Text(userModel.name),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlarmsScreen(
                                      userModel: userModel,
                                    ),
                                  ),
                                );
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
