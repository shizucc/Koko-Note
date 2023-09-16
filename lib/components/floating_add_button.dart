import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screen/form_activity.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key, required this.color});

  final Color color;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: color,
        tooltip: "Tambah Aktivitas Baru",
        onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FormActivity()))
            },
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ));
  }
}
