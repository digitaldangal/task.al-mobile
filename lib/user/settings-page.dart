import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../myDrawer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {

   @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  // Change Email 
  Future<Null> _changeEmailDialog(BuildContext context) async {
    TextEditingController _controller = new TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Change Email'),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        children: <Widget>[
          new Text('Sorry, this option is not yet available!'),
          new Text('Please use our web app (https://web.task.al) to make this change.')
          // new TextField(
          //   autofocus: true,
          //   controller: _controller,
          //   decoration: const InputDecoration( labelText: "Your email"),
          // ),
          // new Container(height: 15.0,),
          // new FlatButton(
          //   child: new Text('Save'),
          //   onPressed: () => (_controller.text != '') ? _changeEmail(_controller.text) : null,
          //   disabledColor: Colors.black12,
          //   disabledTextColor: Colors.grey,
          //   color: Colors.teal,
          //   textColor: Colors.white,
          // )
        ],
      ),
    );
  }

  Future<Null> _changeEmail(newEmail) async {
    if (newEmail == '') return; 
  }
  
  // Change Password
  Future<Null> _handleChangePassword(BuildContext context) async {
    TextEditingController _controller = new TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Change Password'),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        children: <Widget>[
          new Text('Sorry, this option is not yet available!'),
          new Text('Please use our web app (https://web.task.al) to make this change.')
          // new TextField(
          //   autofocus: true,
          //   controller: _controller,
          //   decoration: const InputDecoration( labelText: "Your email"),
          // ),
          // new Container(height: 15.0,),
          // new FlatButton(
          //   child: new Text('Save'),
          //   onPressed: () => (_controller.text != '') ? _changeEmail(_controller.text) : null,
          //   disabledColor: Colors.black12,
          //   disabledTextColor: Colors.grey,
          //   color: Colors.teal,
          //   textColor: Colors.white,
          // )
        ],
      ),
    );
  }

  Future<Null> _changePassword(newPassword) async {
    if (newPassword == '') return;  
  }

  // Delete Account
  Future<Null> _handleDeleteAccount(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Delete Account'),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        children: <Widget>[
          new Text('Sorry, this option is not yet available!'),
          new Text('Please use our web app (https://web.task.al) to make this change.')
          // new TextField(
          //   autofocus: true,
          //   controller: _controller,
          //   decoration: const InputDecoration( labelText: "Your email"),
          // ),
          // new Container(height: 15.0,),
          // new FlatButton(
          //   child: new Text('Save'),
          //   onPressed: () => (_controller.text != '') ? _changeEmail(_controller.text) : null,
          //   disabledColor: Colors.black12,
          //   disabledTextColor: Colors.grey,
          //   color: Colors.teal,
          //   textColor: Colors.white,
          // )
        ],
      ),
    );
  }

  Future<Null> _deleteUser() async {
  }

  // Sign out
  Future<Null> _handleSignOut() async {
    await _auth.signOut()
    .then((_) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Text('Logged out successfully. Please wait...'),
      ));
      new Future.delayed(new Duration(seconds: 2)).then(
        (_) => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false)
      );
    })
    .catchError((e) {
      final snackbar = new SnackBar(
        duration: new Duration(seconds: 3),
        content: new Text(e.message),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    });
    ;
  }

  Future<Null> _handleContactUs() async {
    const mailTo = 'mailto:info@kondasoft.com?subject=Regarding%20Task.al%20Mobile%20App';
    if (await canLaunch(mailTo)) {
      await launch(mailTo);
    } else {
      throw 'Could not launch $mailTo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      drawer: new MyDrawer(),
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      body: new ListView(
        padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.email),
            title: new Text('Change Email'),
            onTap: () => _changeEmailDialog(context),
          ),
          new ListTile(
            leading: new Icon(Icons.lock),
            title: new Text('Change Password'),
            onTap: () => _handleChangePassword(context),
          ),
          new ListTile(
            leading: new Icon(Icons.delete),
            title: new Text('Delete account'),
            onTap: () => _handleDeleteAccount(context),
          ),
          new ListTile(
            leading: new Icon(Icons.exit_to_app),
            title: new Text('Sign Out'),
            onTap: () => _handleSignOut(),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.mail_outline),
            title: new Text('Contact us'),
            subtitle: new Text('info@kondasoft.com'),
            onTap: () => _handleContactUs(),
          ),
        ],
      )
    );
  }

}