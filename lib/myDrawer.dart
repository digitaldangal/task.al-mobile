import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Provider.dart';
import 'projects/projects-list.dart';
import 'projects/create-project.dart';
import 'user/guest-page.dart';
import 'user/settings-page.dart';

class MyDrawer extends StatefulWidget {

  final DocumentSnapshot currentProject;
  final bool homeProject;

  MyDrawer({Key key, this.currentProject, this.homeProject}): super(key: key);

  @override
  _MyDrawerState createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<DocumentSnapshot> _projects;
  dynamic _homeTasksCount = '';

  @override
  void initState() {
    super.initState();
    _listenProjects();
    _homeTasksCountFn();
  }

  // Listen to Projects
  Future <Null> _listenProjects() async {
    Firestore.instance.collection('users/' + Provider.of(context).value.uid + '/projects').orderBy('order').snapshots.listen(
      (data) =>
        setState( () {
          _projects = data.documents;
        })
    );
  }

  // List to Home Tasks (count them)
  Future <Null> _homeTasksCountFn() async {
    Firestore.instance.collection('users/' + Provider.of(context).value.uid + '/tasks').where('projectId', isNull: true).where('completed', isEqualTo: false).snapshots.listen(
      (data) =>
        setState( () {
          _homeTasksCount = data.documents.length;
        })
    );
  }


  // Loading indicator
  Widget _loading() {
    return new Center(
      child: new CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation(Colors.teal[300]))
    );
  }

  // User Settings
  Widget _userSettings() {
    if (Provider.of(context).value != null && Provider.of(context).value.isAnonymous)
      return new ListTile(
          title: const Text('Guest mode', style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.warning, color: Colors.yellow),
          onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => new GuestPage()))
      );
    else
      return new ListTile(
          title: new Text(Provider.of(context).value.email, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.settings, color: Colors.white),
          onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => new SettingsPage()
          ))
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Column(
        children: <Widget>[
          new Material(
            color: Colors.teal,
            child: new Padding(
              padding: const EdgeInsets.only(top:24.0),
              child: _userSettings()
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.home),
            title: const Text('Home'),
            trailing: new Text(_homeTasksCount.toString(), style: new TextStyle(color: Colors.grey, fontSize: 13.0)),
            selected: (widget.currentProject == null && widget.homeProject == true) ? true : false,
            onTap: () => Navigator.of(context).pushNamed('/')
          ),
          new Divider(height:0.0),
          new Expanded(
            child: _projects == null ?  _loading() : ProjectsList(projects: _projects, currentProject: widget.currentProject),
          ),
          new Divider(height:0.0),
          new CreateProject(projects: _projects),
        ],
      )
    );
  }
}
