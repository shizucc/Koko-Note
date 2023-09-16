import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleTodoList extends StatefulWidget {
  const ScheduleTodoList({super.key});

  @override
  State<ScheduleTodoList> createState() => _ScheduleTodoListState();
}

class _ScheduleTodoListState extends State<ScheduleTodoList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Ini jadwal"),
    );
  }
}
