import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final String text;
  const Popup(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Notice'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(this.text),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
