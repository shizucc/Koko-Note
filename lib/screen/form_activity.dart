import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koko_note/database/model.dart';
import 'package:provider/provider.dart';
import 'package:koko_note/screen/main_list.dart';
import 'package:koko_note/helper/todolist_route.dart';

extension Data on Map<String, TextEditingController> {
  Map<String, dynamic> data() {
    final res = <String, dynamic>{};
    for (MapEntry e in entries) {
      res.putIfAbsent(e.key, () => e.value.text);
    }
    return res;
  }
}

class FormActivity extends StatefulWidget {
  const FormActivity({super.key});

  @override
  State<FormActivity> createState() => _FormActivityState();
}

enum ActivityTimeState { today, schedule }

class _FormActivityState extends State<FormActivity> {
  final _formKey = GlobalKey<FormState>();

  late String activityName;
  late String activityDescription;
  late DateTime activityDateTime;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late ActivityTimeState _activityTimeState;

  @override
  void initState() {
    _activityTimeState = ActivityTimeState.today;
    selectedDate = DateTime.now().add(const Duration(days: 1));
    selectedTime = TimeOfDay.now();
    super.initState();
  }

  @override
  void dispose() {
    // Close connection database

    // Dispose all fields in activityFromController
    activityFormController.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  void switchAddActivity(ActivityTimeState value) {
    setState(() {
      _activityTimeState = value;
    });
  }

  final Map<String, TextEditingController> activityFormController = {
    'activity_name': TextEditingController(),
    'activity_description': TextEditingController()
  };

  Future<void> processData() async {
    // Get data from form
    Map<String, dynamic> data = activityFormController.data();

    // Process data
    final String activityNameDump = data['activity_name'];
    final String activityDescriptionDump = data['activity_description'] ?? '';

    DateTime activityDateTimeDump;
    if (_activityTimeState == ActivityTimeState.today) {
      activityDateTimeDump = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, selectedTime.hour, selectedTime.minute);
    } else {
      activityDateTimeDump = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);
    }
    setState(() {
      activityName = activityNameDump;
      activityDescription = activityDescriptionDump;
      activityDateTime = activityDateTimeDump;
    });
  }

  String successMessageBuilder() {
    return "hehe";
  }

  void navigateToTodoList() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainTodoList(
                  initialTodoList: TodoListRoute.today,
                  message: successMessageBuilder(),
                )));
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<MyDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              CupertinoIcons.clear,
              size: 20,
            )),
        title: const Center(
            child: Text(
          "Tambah Aktivitas",
          style: TextStyle(fontSize: 17),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  processData();
                  database.insertTodoList(
                      activityName, activityDescription, activityDateTime);
                  navigateToTodoList();
                },
                child: const Icon(
                  CupertinoIcons.check_mark,
                  size: 20,
                )),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: activityFormController['activity_name'],
                      decoration: const InputDecoration(
                          labelText: "Nama Aktivitas",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama aktivitas harus diisi";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:
                          activityFormController['activity_description'],
                      decoration: const InputDecoration(
                          labelText: "Detail Aktivitas",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5))),
                      minLines: 1,
                      maxLines: 20,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => {
                                  switchAddActivity(ActivityTimeState.today)
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: _activityTimeState ==
                                                ActivityTimeState.today
                                            ? Colors.black
                                            : const Color.fromRGBO(
                                                0, 0, 0, 0.1),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Hari Ini",
                                      style: TextStyle(
                                          color: _activityTimeState ==
                                                  ActivityTimeState.today
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => {
                                  switchAddActivity(ActivityTimeState.schedule)
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: _activityTimeState ==
                                                ActivityTimeState.schedule
                                            ? Colors.black
                                            : const Color.fromRGBO(
                                                0, 0, 0, 0.1),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Jadwalkan",
                                      style: TextStyle(
                                          color: _activityTimeState ==
                                                  ActivityTimeState.schedule
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    )),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 50,
                    ),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Column(
                        children: [
                          const Text(
                            "Jam",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                  0,
                                  0,
                                  0,
                                  0.5,
                                ),
                                fontSize: 15),
                          ),
                          InkWell(
                            onTap: () async {
                              final TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                  initialEntryMode: TimePickerEntryMode.dial);

                              if (time != null) {
                                setState(() {
                                  selectedTime = time;
                                });
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(0, 0, 0, 0.5)))),
                              child: Text(
                                "${selectedTime.hour}:${selectedTime.minute}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _activityTimeState == ActivityTimeState.schedule
                        ? Container(
                            child: Column(
                              children: [
                                const Text(
                                  "Tanggal",
                                  style: TextStyle(
                                      color: Color.fromRGBO(
                                        0,
                                        0,
                                        0,
                                        0.5,
                                      ),
                                      fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final DateTime? date = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(3000));

                                    if (date != null) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.5)))),
                                    child: Text(
                                      "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
