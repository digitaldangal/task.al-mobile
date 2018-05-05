import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Provider.dart';
import 'myDrawer.dart';
import 'tasks/Tasks.dart';
import 'user/guest-page.dart';

class AppState extends ValueNotifier {
  AppState(value) : super(value);
}

var appState = new AppState(null);

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Provider(
      data: appState,
      child: new MaterialApp(
        title: 'Task.al',
        theme: new ThemeData(
          primaryColor: Colors.teal[600],
        ),
        home: new HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _handleAuth();
  }

  // Check if user is logged in or not
  Future<Null> _handleAuth() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Provider.of(context).value = _user;

    if (_user == null) {
      _handleSignInAnonymously();
    }
  }

  // Anonymous Registration 
  Future<Null> _handleSignInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously()
      .then((FirebaseUser _user) => _handleAuth());
  }

  // Loading indicator
  Widget _loading() {
    return new Center (
      child: new CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation(Colors.teal[300]))
    );
  }
  
  @override
  Widget build(BuildContext context) {
    FirebaseUser _authUser = Provider.of(context).value;
    return new Material(
      child: new Scaffold(
        drawer: new MyDrawer(homeProject: true),
        appBar: new AppBar(
          title: new Text('Task.al'),
          actions: <Widget>[
            (_authUser != null && _authUser.isAnonymous) ? new IconButton(
              icon: new Icon(Icons.warning), color: Colors.yellow,
              tooltip: 'Guest mode',
              onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => new GuestPage()))
            ) : new Container(),
          ],
        ),
        body: _authUser == null ? _loading() : new Tasks(currentProject: null),
      )
    );
  }

}