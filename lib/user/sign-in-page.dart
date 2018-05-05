import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class SignInPage extends StatefulWidget {

   @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      _handleSignWithEmailAndPassword();
    }
  }

  // Sign in with Google
  Future<Null> _handleSignInWithGoogle() async {
    await _auth.signOut();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    )
    .then((FirebaseUser user) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Text('Logged in successfully. Please wait...'),
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
  }

  // Sign in with Email and Password
  Future<Null> _handleSignWithEmailAndPassword() async {
    await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password, 
    )
    .then((FirebaseUser user) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Text('Logged in successfully. Please wait...'),
      ));
      new Future.delayed(new Duration(seconds: 2)).then(
        (_) => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false)
      );
    })
    .catchError((onError) {
      final snackbar = new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Text(onError.message),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    });
  }

  // Build Login form
  Widget _buildEmailLoginForm() {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('Or sign in with email', style: const TextStyle(fontWeight: FontWeight.bold),),
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
                    child: new Text('Sign in'),
                    disabledColor: Colors.black12,
                    disabledTextColor: Colors.black26,
                    // color: Colors.teal,
                    // textColor: Colors.white,
                    onPressed: _submit ,
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  // Forgot password dialog 
  Future<Null> _handleForgotPasswordDialog() async {
    TextEditingController _controller = new TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: const Text('Reset your password'),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        children: <Widget>[
          new TextField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            controller: _controller,
            decoration: const InputDecoration( labelText: "Your email address"),
          ),
          new Container(height: 15.0,),
          new FlatButton(
            child: new Text('Send'),
            onPressed: () => _handleForgotPassword(_controller.text),
            disabledColor: Colors.black12,
            disabledTextColor: Colors.grey,
            color: Colors.teal,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  Future<Null> _handleForgotPassword(email) async {
    if (email == '') return; 
    
    _auth.sendPasswordResetEmail(email: email)
      .then((_) {
        Navigator.of(context).pop();
        final snackbar = new SnackBar(
          duration: new Duration(seconds: 5),
          content: new Text("Done! Please check your email"),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
      })
      .catchError((onError) {
        final snackbar = new SnackBar(
          duration: new Duration(seconds: 3),
          content: new Text(onError.message),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Sign in'),
      ),
      body: new ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          new Form(
            key: formKey,
            child: new Column(
              children: [
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('Sign in with Google'),
                        color: Colors.blue[600],
                        textColor: Colors.white,
                        onPressed: _handleSignInWithGoogle
                      )
                    )
                  ]
                ),
                new Container(height: 16.0,),
                _buildEmailLoginForm(),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        child: new Text('Forgot your password?'),
                        textColor: Colors.grey,
                        onPressed: () => _handleForgotPasswordDialog()
                      )
                    )
                  ]
                ),         
              ],
            ),
          ),
        ]
      ),
    );
  }
}