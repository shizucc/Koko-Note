import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:drift/drift.dart' as drift;
import 'dart:core';
import '../components/todo_list_builder.dart';
import 'package:koko_note/helper/todolist_route.dart';

class TodayTodoList extends StatefulWidget {
  const TodayTodoList({super.key});

  @override
  State<TodayTodoList> createState() => _TodayTodoListState();
}

enum AppBarState { expanded, collapsed }

class _TodayTodoListState extends State<TodayTodoList> {
  final Color colorScheme = const Color.fromRGBO(114, 134, 211, 1);
  final Color colorCanvas = Colors.white;
  final DateTime dateTime = DateTime.now();

  final ScrollController _scrollController = ScrollController();
  late AppBarState _appBarState;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    _appBarState = AppBarState.expanded;
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.offset > 150 &&
        _appBarState == AppBarState.expanded) {
      setState(() {
        _appBarState = AppBarState.collapsed;
      });
    } else if (_scrollController.offset <= 150 &&
        _appBarState == AppBarState.collapsed) {
      setState(() {
        _appBarState = AppBarState.expanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
            backgroundColor: colorCanvas,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 200,
            leading: Icon(
              CupertinoIcons.person_alt_circle_fill,
              color: _appBarState == AppBarState.expanded
                  ? Colors.white
                  : Colors.black,
            ),
            title: _appBarState == AppBarState.collapsed
                ? const Text("Hari ini")
                : Container(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  decoration: BoxDecoration(color: colorScheme),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hai Aruuvi",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 40),
                        ),
                        Text(
                          "Ayo jadi produktif!",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 30),
                        )
                      ],
                    ),
                  )),
            )),
        SliverList(
          delegate: SliverChildListDelegate([
            Stack(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: _appBarState == AppBarState.expanded
                          ? colorScheme
                          : colorCanvas),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: colorCanvas,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 30),
                        child: Container(
                          width: 40,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TodoListBuilder(
                          color: colorScheme,
                          dateTime: dateTime,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]),
        )
      ],
    );
  }
}
