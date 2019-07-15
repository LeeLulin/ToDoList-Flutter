import 'package:flutter/material.dart';
import 'package:Doit/model/todo.dart';

showSnackBar(BuildContext context, Todo item) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text("${item.title} at ${item.date} ${item.time}"),
      backgroundColor: Colors.amber,
    ),
  );
}