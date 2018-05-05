import 'dart:async';
import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Provider.dart';
import 'project-page.dart';

class CreateProject extends StatefulWidget {

  final List<DocumentSnapshot> projects;

  CreateProject({Key key, this.projects }): super(key: key);

  @override
  _CreateProjectState createState() => new _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  TextEditingController _controller = new TextEditingController();

  // Create a new project
  Future<Null> _createProject(projectTitle) async {
    if (projectTitle == '') return;

    await Firestore.instance.collection('users/' + Provider.of(context).value.uid + '/projects').add({
      'title': projectTitle,
      'order':  widget.projects.length,
      'count': 0
    })
      .then((DocumentReference project) {
        project.get().then((DocumentSnapshot snap) {
          _controller.clear();
          Navigator.push(context, new MaterialPageRoute(builder: (context) =>
            new ProjectPage(
              currentProject: snap,
            )));
            
        });
    });
  }

  // Create a project (dialog)
  Future<Null> _createProjectDialog() async {
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Create a Project'),
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
            child: new Text('Create'),
            onPressed: () => (_controller.text != '') ? _createProject(_controller.text) : null,
            disabledColor: Colors.black12,
            disabledTextColor: Colors.grey,
            color: Colors.teal,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: const Icon(Icons.add),
      title: const Text('Create a project'),
      onTap: () => _createProjectDialog(),
    );
  }
}