import 'package:flutter/material.dart';
import 'package:Doit/model/todo.dart';
import 'package:Doit/utils/utils.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> allTodo;

  TodoListView(this.allTodo);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: new BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _getListViewItemUI(context, allTodo[index]);
      },
      itemCount: allTodo.length,
    );
  }

  Widget _getListViewItemUI(BuildContext context, Todo todo) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 10, bottom: 5),
          child: SizedBox(
            height: 95.0,
            width: double.infinity,

            child: Card(

              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage("images/img_0.png"),
                    fit: BoxFit.fill,
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ListTile(

                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: <Widget>[
                          Text(
                            todo.title,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(
                            todo.description,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(
                            "${todo.date} ${todo.time}",
                            style: TextStyle(
                              fontSize: 11.0,
                            ),
                          ),
                        ],
                      ),

                      onTap: () {
                        showSnackBar(context, todo);
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

}