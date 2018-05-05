import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class SignUpPage extends StatefulWidget {

   @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      _handleLinkWithEmailAndPassword();
    }
  }

  // Link with Google Credential
  Future<Null> _handleLinkWithGoogleCredential() async {
    await _googleSignIn.disconnect();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    await _auth.linkWithGoogleCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    )
    .then((FirebaseUser user) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 3),
        content: new Text('Registered successfully. Please wait...'),
      ));
      new Future.delayed(new Duration(seconds: 3)).then(
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
  }

  // Link with Email and Password
  Future<Null> _handleLinkWithEmailAndPassword() async {
    await _auth.linkWithEmailAndPassword(
      email: _email,
      password: _password, 
    )
    .then((FirebaseUser user) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 3),
        content: new Text('Registered successfully. Please wait...'),
      ));
      new Future.delayed(new Duration(seconds: 2)).then(
        (_) => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false)
      );
    })
    .catchError((onError) {
      final snackbar = new SnackBar(
        duration: new Duration(seconds: 5),
        content: new Text(onError.message),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    });
  }

  // Build Login form
  Widget _buildLinkWithEmailForm() {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('Or sign up with email', style: const TextStyle(fontWeight: FontWeight.bold),),
            new Container(height: 8.0,),
            new TextFormField(
              decoration: new InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (val) =>
                !val.contains('@') ? 'Not a valid email.' : null,
              onSaved: (val) => _email = val,
            ),
            new Container(height: 10.0,),
            new TextFormField(
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (val) =>
                val.length < 6 ? 'Password must be minimum of 6 characters' : null,
              onSaved: (val) => _password = val,
            ),
            new Container(height: 22.0,),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new RaisedButton(
                    child: new Text('Sign up'),
                    disabledColor: Colors.black12,
                    disabledTextColor: Colors.black26,
                    onPressed: _submit,
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Create an account'),
      ),
      body: new ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
           new Form(
            key: formKey,
            child: new Column(
              children: [
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('Sign up with Google'),
                        color: Colors.blue[600],
                        textColor: Colors.white,
                        onPressed: _handleLinkWithGoogleCredential
                      )
                    )
                  ]
                ),
                new Container(height: 16.0,),
                _buildLinkWithEmailForm()          
              ],
            ),
          ),
        ]
      ),
    );
  }


}
