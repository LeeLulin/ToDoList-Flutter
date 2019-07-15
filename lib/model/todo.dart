class Todo {
  final String title;

  final String description;

  final String date;

  final String time;

  Todo({this.title, this.description, this.date, this.time});

  static List<Todo> allTodos() {
    var todo = List<Todo>();

    todo.add(Todo(
      title: "搭建Flutter环境",
      time: "12:00",
      date: "2019-05-06",
      description: "待办事项描述",
    ));
    todo.add(Todo(
      title: "Dart语言基本语法",
      time: "12:00",
      date: "2019-05-06",
      description: "待办事项描述",
    ));
    todo.add(Todo(
      title: "Android Studio集成Flutter",
      time: "12:00",
      date: "2019-05-06",
      description: "待办事项描述",
    ));
    todo.add(Todo(
      title: "ios真机调试",
      time: "12:00",
      date: "2019-05-06",
      description: "待办事项描述",
    ));

    return todo;
  }
}