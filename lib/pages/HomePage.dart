import 'package:flutter/material.dart';
import 'package:Doit/widget/TodoView.dart';
import 'package:Doit/widget/Drawer.dart';
import 'package:Doit/model/todo.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin{

  TabController _tabController;
  final List<Todo> _allCities = Todo.allTodos();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Do it'),
        bottom: new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.today),),
            new Tab(icon: new Icon(Icons.access_time),),
          ],
        ),
      ),
      drawer: new Drawer(
        child: DrawerBuilder.myDrawer(context),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Center(
              child: TodoListView(_allCities)
          ),

          new Center(
              child: new Text('番茄时钟')),
        ],
      ),

      floatingActionButton: new Builder(builder: (BuildContext context){
        return new FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("点击了按钮"),
            ));
          },
          tooltip: '悬浮按钮',
          child: new Icon(Icons.add),
        );
      }),


    );
  }
}