import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screen/today.dart';
import '../screen/tomorrow.dart';
import '../screen/schedule.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key, required this.color, required this.index});

  final Color color;
  final int index;
  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: widget.index,
        selectedItemColor: widget.color,
        onTap: (value) {
          if (value == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TodayTodoList()));
          }
          if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TomorrowTodoList()));
          }
          if (value == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleTodoList()));
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.today), label: "Hari ini"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_number), label: "Besok"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar), label: "Jadwal")
        ]);
  }
}
