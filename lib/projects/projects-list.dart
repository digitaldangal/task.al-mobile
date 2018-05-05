import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

import 'project-page.dart';

class ProjectsList extends StatelessWidget {

  final List<DocumentSnapshot> projects;
  final DocumentSnapshot currentProject;

  ProjectsList({Key key, @required this.projects, @required this.currentProject}): super(key: key);

  // Projects list is empty
  Widget _emptyProjects() {
    return new Center (
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Container(
            width: 220.0,
            child: new Column(
              children: <Widget>[
                new Icon(Icons.list, color: Colors.black12, size: 60.0,),
                new Text('No projects yet!', textAlign:TextAlign.center, style: new TextStyle(color: Colors.black26, height: 1.3  ),),
              ],
            ),
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (projects.length == 0) return _emptyProjects(); 
    return new ListView.builder(
      shrinkWrap: true,
      itemCount:  projects.length,
      padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: projects[index].data['shared'] != null ? new Icon(Icons.group) : new Icon(Icons.list),
          title: new Text(projects[index].data['title'], overflow: TextOverflow.ellipsis, maxLines: 1,),
          trailing: new Text(projects[index].data['count'].toString(), style: new TextStyle(color: Colors.grey, fontSize: 13.0)),
          selected: (currentProject != null && projects[index].documentID == currentProject.documentID) ? true : false,
          onTap: () =>
            Navigator.push(context, new MaterialPageRoute(builder: (context) => new ProjectPage(
              currentProject: projects[index]
            )))
        );
      }
    );
  }
}