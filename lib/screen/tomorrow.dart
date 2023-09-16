import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koko_note/components/bottom_navbar.dart';
import 'package:koko_note/components/floating_add_button.dart';
import 'package:koko_note/helper/todolist_route.dart';

class TomorrowTodoList extends StatefulWidget {
  const TomorrowTodoList({super.key});

  @override
  State<TomorrowTodoList> createState() => _TomorrowTodoListState();
}

class _TomorrowTodoListState extends State<TomorrowTodoList> {
  final Color colorScheme = Color.fromRGBO(255, 135, 135, 1);
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Ini adalah tommorow"));
  }
}
