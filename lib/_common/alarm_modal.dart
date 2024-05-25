import 'package:flutter/material.dart';
import 'package:flutter_medicare_reminder/components/decoration_text_field.dart';
import 'package:flutter_medicare_reminder/models/alarm.dart';
import 'package:flutter_medicare_reminder/services/user_service.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

showAlarmModal(BuildContext context, String userId, {AlarmModel? alarm}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[900],
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) {
      return AlarmModal(
        userId: userId,
        alarmModel: alarm,
      );
    },
  );
}

class AlarmModal extends StatefulWidget {
  final String userId;
  final AlarmModel? alarmModel;
  const AlarmModal({super.key, required this.userId, this.alarmModel});

  @override
  State<AlarmModal> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AlarmModal> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  int _hourCtrl = 0;
  int _minuteCtrl = 0;

  bool isLoading = false;
  bool register = true;

  final UserService _dependentService = UserService();

  @override
  void initState() {
    if (widget.alarmModel != null) {
      _nameCtrl.text = widget.alarmModel!.name;
      _descriptionCtrl.text = widget.alarmModel!.description ?? '';
      _hourCtrl = widget.alarmModel!.hour;
      _minuteCtrl = widget.alarmModel!.minute;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        (widget.alarmModel != null)
                            ? 'Editar ${widget.alarmModel!.name}'
                            : 'Adicionar alarme',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(15, 0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: getAuthenticationInputDecoration('Nome'),
                      validator: (String? value) {
                        if (value == null || value.length < 3) {
                          return 'Nome inválido!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _descriptionCtrl,
                      decoration: getAuthenticationInputDecoration('Descrição'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            minValue: 0,
                            maxValue: 23,
                            value: _hourCtrl,
                            zeroPad: true,
                            infiniteLoop: true,
                            itemWidth: 80,
                            itemHeight: 40,
                            textStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                            selectedTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 26),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black,
                                ),
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _hourCtrl = value;
                              });
                            },
                          ),
                          const Text(
                            ':',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                          NumberPicker(
                            minValue: 0,
                            maxValue: 59,
                            value: _minuteCtrl,
                            zeroPad: true,
                            infiniteLoop: true,
                            itemWidth: 80,
                            itemHeight: 40,
                            textStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                            selectedTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 26),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black,
                                ),
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _minuteCtrl = value;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    sendClick(widget.userId);
                  },
                  child: (isLoading)
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.grey[800],
                          ),
                        )
                      : Text(
                          (widget.alarmModel != null)
                              ? 'Atualizar alarme'
                              : 'Cadastrar alarme',
                          style: const TextStyle(color: Colors.black),
                        ),
                ),
                Visibility(
                  visible: (widget.alarmModel != null),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red[100]),
                      shape: WidgetStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () {
                      deleteClick(widget.userId);
                    },
                    child: const Text(
                      'Excluir alarme',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendClick(String userId) {
    setState(() {
      isLoading = true;
    });

    String name = _nameCtrl.text;
    String description = _descriptionCtrl.text;
    int hour = _hourCtrl;
    int minute = _minuteCtrl;

    AlarmModel alarm = AlarmModel(
      id: const Uuid().v1(),
      name: name,
      description: description,
      hour: hour,
      minute: minute,
    );

    if (widget.alarmModel != null) {
      alarm.id = widget.alarmModel!.id;
    }

    _dependentService.registerAlarm(userId, alarm).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
    });
  }

  deleteClick(String userId) {
    setState(() {
      isLoading = true;
    });

    String name = _nameCtrl.text;
    String description = _descriptionCtrl.text;
    int hour = _hourCtrl;
    int minute = _minuteCtrl;

    AlarmModel alarm = AlarmModel(
      id: widget.alarmModel!.id,
      name: name,
      description: description,
      hour: hour,
      minute: minute,
    );

    _dependentService
        .deleteAlarm(dependentId: userId, alarmId: alarm.id)
        .then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
    });
  }
}
