import 'dart:async';
import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Provider.dart';

class Tasks extends StatefulWidget {
  final DocumentSnapshot currentProject;

  Tasks({Key key, @required this.currentProject }): super(key: key);

  @override
  _TasksState createState() => new _TasksState(); 
}

class _TasksState extends State<Tasks> {
  var _unsubscribe;
  List<DocumentSnapshot> _tasks;
  final TextEditingController _textController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  bool _isComposing = false;

  void initState() {
    super.initState();
    _listenTasks();
  }

  // Listen tasks
  Future<Null> _listenTasks() async {
    if (widget.currentProject == null)
      _unsubscribe = Firestore.instance.collection('users/' + Provider.of(context).value.uid + '/tasks')
        .where('projectId', isNull: true).orderBy('order')
        .snapshots.listen(
          (data) => setState(() => _tasks = data.documents)
        );
     else 
      _unsubscribe = Firestore.instance.collection('users/' + Provider.of(context).value.uid + '/tasks')
        .where('projectId', isEqualTo: widget.currentProject.documentID).orderBy('order')
        .snapshots.listen(
          (data) {
            setState(() => _tasks = data.documents);
          }
        );
  }

  // Add a new task
  Future<Null> _handleAddTask(taskTitle) async {
    if (taskTitle == '') return;
    _textController.clear();
    _isComposing = false;

    await Firestore.instance.collection('users/' + Provider.of(context).value.uid + '/tasks').add({
      'title': taskTitle,
      'completed': false,
      'order': _tasks.length,
      'projectId': widget.currentProject != null ? widget.currentProject.documentID : null
    }); 
    
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    
  }

  // Handle completion for a task
  Future<Null> _handleCompletion(DocumentSnapshot task, bool completed) async {
    Firestore.instance.document('users/' + Provider.of(context).value.uid + '/tasks/' + task.documentID).updateData({
      'completed': completed,
    });
  }

  // Delete a task
  Future<Null> _deleteTask(DocumentSnapshot task,) async {
    await Firestore.instance.document('users/' + Provider.of(context).value.uid + '/tasks/' + task.documentID).delete();
  }

  // Edit Task
  Future<Null> _editTask(DocumentSnapshot task, String newTaskTitle) async {    
    if (newTaskTitle.length == 0) return;
    await Firestore.instance.document('users/' + Provider.of(context).value.uid + '/tasks/' + task.documentID).updateData({
      'title': newTaskTitle
    });
  }

  // Edit task (Dialog)
  Future<Null> _editTaskDialog(BuildContext context, DocumentSnapshot task) async {
    TextEditingController _taskTitleController = new TextEditingController(text: task.data['title']);

    await showDialog (
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Edit task'),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        children: <Widget>[
          new TextField(
            controller: _taskTitleController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration( labelText: "Task title"),
          ),
          new Container(height: 15.0,),
          new FlatButton(
            child: new Text('Save'),
            onPressed: () => _editTask(task, _taskTitleController.text).then((_) =>  Navigator.of(context).pop()),
            disabledColor: Colors.black12,
            disabledTextColor: Colors.grey,
            color: Colors.teal,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  // Loading indicator
  Widget _loading() {
    return new Center (
      child: new CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation(Colors.teal[300]))
    );
  }

  // Tasks list is empty
  Widget _emptyTasks() {
    return new Center (
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Container(
            child: new Column(
              children: <Widget>[
                new Icon(Icons.done, color: Colors.black12, size: 70.0,),
                new Text('No tasks yet!', textAlign:TextAlign.center, style: new TextStyle(color: Colors.black26, height: 1.3  ),),
              ],
            ),
          ),
        ]
      )
    );
  }

  // Tasks list
  Widget _tasksList() {
    return new ListView.builder (
      controller: _scrollController,
      padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
      itemCount: _tasks.length,
      itemBuilder: (BuildContext context, int index) =>
        _taskItem(_tasks[index])
    );
  }

  // Add task form
  Widget _addTaskForm() {
    return new Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onChanged: (String text) { setState(() =>  _isComposing = text.length > 0 ); },
              onSubmitted: _handleAddTask,
              decoration: const InputDecoration(hintText: "Add a task", hintStyle: const TextStyle(color: Colors.black26), border: InputBorder.none ),
            ),
          ),
          new Material(
            color: Colors.white,
            child:  new IconButton(
              highlightColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              disabledColor: Colors.black26,
              color: Colors.teal,
              icon: new Icon(Icons.send,),
              onPressed: _isComposing ? () => _handleAddTask(_textController.text) : null, 
            ),
          ),
        ],
      )
    );
  }

  // Task item 
  Widget _taskItem(DocumentSnapshot task) {
    return new Dismissible(
      background: new Container(
        color: Colors.red, 
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18.0),
        child: new Icon(Icons.delete, color: Colors.white,),
      ),
      key: new Key(task.documentID),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteTask(task),
      child: new ListTile(
        leading: new Checkbox(value: task.data['completed'], activeColor: Colors.black26, onChanged: (bool newValue) { 
          _handleCompletion(task, newValue);
        }),
        title: (task.data['completed'] == false) ? 
          new Text(task.data['title'],) :
          new Text(task.data['title'], style: const TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis, maxLines: 1),
        onTap: () => _editTaskDialog(context, task),
      ),
    );
  }

  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks == null) return _loading();

    return new Column(
      children: <Widget>[
        new Expanded(
          child: (_tasks.length == 0) ? _emptyTasks() : _tasksList(),
        ),
        new Divider(height: 1.0),
        _addTaskForm()
      ],
    );
  }
}