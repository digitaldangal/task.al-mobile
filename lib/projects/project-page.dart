import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Provider.dart';
import '../myDrawer.dart';
import '../tasks/Tasks.dart';

class ProjectPage extends StatefulWidget {
  final DocumentSnapshot currentProject;

  ProjectPage({Key key, @required this.currentProject}): super(key: key);

  @override
  _ProjectPageState createState() => new _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>{
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  // Edit Project title
  Future<Null> _openEditProjectTitleDialog() async {
    TextEditingController _controller = new TextEditingController(text: widget.currentProject.data['title']);
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Edit Project Title'),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        children: <Widget>[
          new TextField(
            autofocus: true,
            controller: _controller,
            decoration: const InputDecoration( labelText: "Project Title"),
          ),
          new Container(height: 15.0,),
          new FlatButton(
            disabledColor: Colors.black12,
            color: Colors.teal,
            disabledTextColor: Colors.black26,
            textColor: Colors.white,
            child: new Text('Save'),
            onPressed: () { _editProjectTitle(_controller.text); },
          ),
        ],
      ),
    );
  }

  Future<Null> _editProjectTitle(newTitle) async {
    if (newTitle == '') return;
    Navigator.of(context).pop(context);
    await Firestore.instance.document('users/' + Provider.of(context).value.uid + '/projects/' + widget.currentProject.documentID).updateData({
      'title': newTitle,
    })
    .then((_) {
      setState(() => widget.currentProject.data['title'] = newTitle);
      scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text("Project title changed successfully"), duration: new Duration(seconds: 5))
      );
    })
    
    .catchError((e)=>print(e));
  }

  // Delete project
  Future<Null> _openDeleteProjectDialog() async {
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Delete Project'),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        children: <Widget>[
          new Text('IMPORTANT: Deleting a project can\'t be undone. Please confirm below'),
          new Container(height: 15.0,),
          new FlatButton(
            color: Colors.red,
            textColor: Colors.white,
            child: new Text('Confirm Delete!'),
            onPressed: _deleteProject,
          ),
        ],
      ),
    );
  }

  Future<Null> _deleteProject() async {
    await Firestore.instance.document('users/' + Provider.of(context).value.uid + '/projects/'+widget.currentProject.documentID).delete()
    .then((_) {
      scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text("Project was deleted successfully. Please wait..."), duration: new Duration(seconds: 3))
      );
      Navigator.of(context).pop(context);
    })
    .then((_) => new Future.delayed(new Duration(seconds: 3))
      .then((_) =>
        Navigator.of(context).pushReplacementNamed('/')
      )
    )
    .catchError((e)=>print(e));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      drawer: new MyDrawer(currentProject: widget.currentProject),
      appBar: new AppBar(
        title: new Text(widget.currentProject.data['title']),
        actions: <Widget>[
          new PopupMenuButton (
            onSelected: (result) {
              if (result == 'project-edit')
                _openEditProjectTitleDialog();
              if (result == 'project-delete')
                _openDeleteProjectDialog();
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'project-edit',
                child: const Text('Edit project title'),
              ),
              const PopupMenuItem(
                value: 'project-delete',
                child: const Text('Delete project'),
              ),
            ],
          )
        ],
      ),
      body: new Tasks(currentProject: widget.currentProject),
    );
  }
}
