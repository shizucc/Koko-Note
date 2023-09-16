import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:koko_note/database/model.dart';
import 'package:koko_note/screen/today.dart';
import 'package:koko_note/screen/tomorrow.dart';
import 'package:koko_note/screen/schedule.dart';
import 'package:koko_note/helper/todolist_route.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'dart:async';
import '../components/floating_add_button.dart';

class MainTodoList extends StatefulWidget {
  final TodoListRoute? initialTodoList;
  final String? message;
  const MainTodoList({super.key, this.initialTodoList, this.message});
  @override
  State<MainTodoList> createState() => _MainTodoListState();
}

class _MainTodoListState extends State<MainTodoList> {
  var currentPage = 0;
  late OverlayEntry _overlayEntry;
  bool _showMessage = false;
  // final database = MyDatabase();

  void changePage(int index) {
    setState(() {
      currentPage = index;
    });
  }

  void _showMessageBanner() {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.2,
        left: MediaQuery.of(context).size.width * 0.1,
        child: Text("Berhasil menambah"),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the banner after a specific duration (e.g., 3 seconds).
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(index: currentPage, children: const [
          TodayTodoList(),
          TomorrowTodoList(),
          ScheduleTodoList()
        ]),
        floatingActionButton: const FloatingAddButton(
          color: Colors.black,
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentPage,
            selectedItemColor: Colors.black,
            onTap: (value) {
              changePage(value);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.today), label: "Hari ini"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.list_number), label: "Besok"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.calendar), label: "Jadwal")
            ]));
  }
}
