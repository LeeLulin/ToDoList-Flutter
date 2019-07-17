import 'package:Doit/bean/Todos.dart';
import 'package:Doit/bean/user.dart';
import 'package:Doit/db/DatabaseHelper.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:Doit/model/todo.dart';
import 'package:Doit/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TodoPage();
  }
}

class TodoPage extends State<TodoListView> {
  var _items = [];
  int localTodos;
  var db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return layout(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    _queryList(context);
    super.initState();
  }

  ///查询多条数据
  void _queryList(BuildContext context) async {
    localTodos = await db.getCount();
//    db.clearTodo();
    print("localTodo: " + localTodos.toString() );
//    db.close();
      SharedPreferences sp = await SharedPreferences.getInstance();
      String objectId = sp.get("ObjectId");
      BmobQuery<Todos> query = BmobQuery();
      query.addWhereEqualTo("user", objectId);
      query.queryObjects().then((List<dynamic> data) {
        List<Todos> netTodo = data.map((i) => Todos.fromJson(i)).toList();
        print("查询到 " + netTodo.length.toString() + " 条数据");
        int index = 0;
        for (Todos todo in netTodo) {
          index++;
          if (todo != null) {
            print(index);
            print(todo.objectId);
            print(todo.title);
            print(todo.desc);

          }
        }
        setState(() {
          _items = netTodo;
        });

//        if( localTodos < netTodo.length){
//          saveTodos(netTodo);
//
//        }
//        loadData();

      }).catchError((e) {
        print(BmobError.convert(e).error);
      });





  }

//  ///把视频列表存到数据库以备用
//  void saveTodos(List<Todos> todos) async {
////    db.clearTodo();
//    todos.forEach((todo) => db.insertTodo(todo));
//    print("待办事项保存到数据库");
////    db.close();
//    setState(() {
//      _items = todos;
//    });
//  }

//  void loadData() async{
//   List<Todos> todos = await db.selectTodo();
//   _items = todos;
//   for (Todos todo in _items){
//     print(todo.title);
//   }
////    setState(() {
////      _items = todos;
////    });
//  }

//  Future<int> getLocalCount() async{
//    var db = DatabaseHelper();
//    return db.getCount();
//  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      body:
      new ListView.builder(
          physics: new BouncingScrollPhysics(),
          itemCount: _items.length,
          itemBuilder: itemView),
    );
  }


  Widget itemView(BuildContext context, int index) {
    Todos model = this._items[_items.length-1-index];
    return new Stack(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 10, bottom: 5),
          child: new SizedBox(
            height: 95.0,
            width: double.infinity,

            child: new Card(

              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),

              child: new Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage("images/img_0.png"),
                    fit: BoxFit.fill,
                  ),
                ),

                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new ListTile(

                      title: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: <Widget>[
                          new Text(
                            model.title,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          new Text(
                            model.desc,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          new Text(
                            "${model.date} ${model.time}",
                            style: TextStyle(
                              fontSize: 11.0,
                            ),
                          ),
                        ],
                      ),

                      onTap: () {
//                        showSnackBar(context, );
                      },
                    )

                  ],

                ),


              ),
            ),
          ),

        ),

        Positioned(
          left: 20.0,
          child: Container(
            height: 36.0,
            width: 2.0,
            color: Colors.black,
          ),
        ),

        Positioned(
          top: 36.0,
          left: 13.0,
          child: Container(
            height: 16.0,
            width: 16.0,
            decoration: BoxDecoration(
              border: new Border.all(color: Colors.black, width: 2.0),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Positioned(
          top: 52.0,
          left: 20.0,
          child: Container(
            height: 48.0,
            width: 2.0,
            color: Colors.black,
          ),
        ),

      ],
    );
  }
//  final List<Todos> allTodo;
//
//  TodoListView(this.allTodo);
//
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return null;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      physics: new BouncingScrollPhysics(),
//      itemBuilder: (BuildContext context, int index) {
//        return _getListViewItemUI(context, allTodo[index]);
//      },
//      itemCount: allTodo.length,
//    );
//  }
//
//  void initState() {
//    // TODO: implement initState
//    _queryList(context);
//    super.initState();
//  }
//
//
//
//  ///查询多条数据
//  void _queryList(BuildContext context) {
//    BmobQuery<Todos> query = BmobQuery();
//    query.setInclude("author");
//    query.setLimit(10);
//    query.setSkip(10);
//    query.queryObjects().then((List<dynamic> data) {
//      List<Todos> todos = data.map((i) => Todos.fromJson(i)).toList();
//
//      setState(() {
//        _items = todos;
//      });
//      int index = 0;
//      for (Todos todo in todos) {
//        index++;
//        if (todo != null) {
//          print(index);
//          print(todo.objectId);
//          print(todo.title);
//          print(todo.desc);
//
//        }
//      }
//    }).catchError((e) {
//
//    });
//  }
//
//
//  Widget _getListViewItemUI(BuildContext context, Todo todo) {
//    return Stack(
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.only(left: 40.0, right: 10, bottom: 5),
//          child: SizedBox(
//            height: 95.0,
//            width: double.infinity,
//
//            child: Card(
//
//              elevation: 5.0,
//              shape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(8.0))
//              ),
//
//              child: Container(
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(8.0),
//                  image: DecorationImage(
//                    image: AssetImage("images/img_0.png"),
//                    fit: BoxFit.fill,
//                  ),
//                ),
//
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    ListTile(
//
//                      title: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//
//                        children: <Widget>[
//                          Text(
//                            todo.title,
//                            style: TextStyle(
//                                fontSize: 20.0,
//                                fontWeight: FontWeight.bold
//                            ),
//                          ),
//
//                          Text(
//                            todo.description,
//                            style: TextStyle(
//                                fontSize: 15.0,
//                                fontWeight: FontWeight.bold
//                            ),
//                          ),
//
//                          Text(
//                            "${todo.date} ${todo.time}",
//                            style: TextStyle(
//                              fontSize: 11.0,
//                            ),
//                          ),
//                        ],
//                      ),
//
//                      onTap: () {
//                        showSnackBar(context, todo);
//                        },
//                    )
//
//                  ],
//
//                ),
//
//
//              ),
//            ),
//          ),
//
//        ),
//
//        Positioned(
//          left: 20.0,
//          child: Container(
//            height: 36.0,
//            width: 2.0,
//            color: Colors.black,
//          ),
//        ),
//
//        Positioned(
//          top: 36.0,
//          left: 13.0,
//          child: Container(
//            height: 16.0,
//            width: 16.0,
//            decoration: BoxDecoration(
//              border: new Border.all(color: Colors.black, width: 2.0),
//              shape: BoxShape.circle,
//            ),
//          ),
//        ),
//
//        Positioned(
//          top: 52.0,
//          left: 20.0,
//          child: Container(
//            height: 48.0,
//            width: 2.0,
//            color: Colors.black,
//          ),
//        ),
//
//      ],
//    );
//
//  }



}