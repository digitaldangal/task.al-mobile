import 'package:flutter/material.dart';

import 'sign-up-page.dart';
import 'sign-in-page.dart';

class GuestPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Guest mode'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are using Task.al without an account. You may continue using our app in this way if you like, but we strongly recommend you to register and permanently save your tasks.', style: const TextStyle( height: 1.2 ),),
            const Text('Already have an account? Please sign in.', style: const TextStyle( height: 1.2 ),),
            new Container(height: 16.0,),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new RaisedButton(
                    child: new Text('Register for Free'),
                    onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => new SignUpPage())),
                  )
                )
              ]
            ),
            new Container(height: 8.0,),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new RaisedButton(
                    child: new Text('Already have an account? Sign in'),
                    onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => new SignInPage())),
                  )
                )
              ]
            ),
          ]
        ),
      ),
    );
  }


}
