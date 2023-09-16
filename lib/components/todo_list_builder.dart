import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koko_note/database/model.dart';

class TodoListBuilder extends StatefulWidget {
  const TodoListBuilder(
      {super.key, required this.color, required this.dateTime});
  final DateTime dateTime;
  final Color color;
  @override
  State<TodoListBuilder> createState() => _TodoListBuilderState();
}

class _TodoListBuilderState extends State<TodoListBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          TodoListTimeRange(
              color: widget.color,
              timeStart: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 0, 0, 0),
              timeEnd: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 5, 59, 59)),
          TodoListTimeRange(
              color: widget.color,
              timeStart: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 6, 0, 0),
              timeEnd: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 11, 59, 59)),
          TodoListTimeRange(
              color: widget.color,
              timeStart: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 12, 0, 0),
              timeEnd: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 18, 59, 59)),
          TodoListTimeRange(
              color: widget.color,
              timeStart: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 19, 0, 0),
              timeEnd: DateTime(widget.dateTime.year, widget.dateTime.month,
                  widget.dateTime.day, 23, 59, 59)),
        ],
      ),
    );
  }
}

class TodoListTimeRange extends StatefulWidget {
  const TodoListTimeRange(
      {super.key,
      required this.color,
      required this.timeStart,
      required this.timeEnd});
  final Color color;
  final DateTime timeStart;
  final DateTime timeEnd;
  @override
  State<TodoListTimeRange> createState() => _TodoListTimeRangeState();
}

class _TodoListTimeRangeState extends State<TodoListTimeRange> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<MyDatabase>(context);
    return StreamBuilder(
      stream: database.streamTodoList(widget.timeStart, widget.timeEnd),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.hasError) {
          print("Error");
          return Container();
        } else {
          var activities = snapshot.data ?? [];
          if (activities.isEmpty) {
            return Container();
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      color: widget.color,
                      size: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.timeStart.hour}.${widget.timeStart.minute} - ${widget.timeEnd.hour}.${widget.timeEnd.minute}",
                      style: TextStyle(
                          color: widget.color,
                          fontSize: 32,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: activities.map((activity) {
                    return TodoList(
                      color: widget.color,
                      id: activity.id,
                      title: activity.title,
                      description: activity.description,
                      time: activity.time,
                      status: activity.status,
                    );
                  }).toList(),
                ),
              ],
            );
          }
        }
      },
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList(
      {super.key,
      required this.color,
      required this.id,
      required this.title,
      required this.description,
      required this.time,
      required this.status});
  final Color color;
  final int id;
  final String title;
  final String? description;
  final DateTime time;
  final bool status;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.5, color: Colors.grey)),
        child: Row(
          children: [
            const Icon(CupertinoIcons.chevron_down),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.7)),
                          "${widget.description}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.clock,
                            color: widget.color,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.time.hour}.${widget.time.minute}",
                            style: TextStyle(color: widget.color),
                          )
                        ],
                      )
                    ]),
              ),
            ),
            const Icon(CupertinoIcons.checkmark_alt_circle)
          ],
        ));
  }
}
