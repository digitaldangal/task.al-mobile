# Task.al Mobile Apps

> Task.al mobile applications (Android/iOS) made with Flutter and Firebase.  
Android app: https://play.google.com/store/apps/details?id=al.task  
iOS app: https://itunes.apple.com/app/task-al/id1375019781

---

NOTE: This guide assumes that you have already installed Flutter. For more info about Flutter please check https://flutter.io

It's better that you don't clone directory this repository, unless you know what you are doing. So, `cd` into your desired directory and create a new Flutter project by running:

```flutter create task_al_mobile```

`cd` into the directory you have just created and open `pubspec.yaml` Add the following dependencies (just below sdk:flutter)

```
cloud_firestore: ^0.6.3
google_sign_in: ^3.0.2
firebase_auth: ^0.5.5
url_launcher: ^3.0.0
```

Install all your packages by running:

```
flutter packages get
```

Configuring Firebase and Google Sign in is kinda tricky in Flutter, especially if you are not familiar with Android/iOS apps. Please follow the instructions for each package you have installed on the following official docs to configure them.
https://pub.dartlang.org/packages/google_sign_in  
https://pub.dartlang.org/packages/cloud_firestore  
https://pub.dartlang.org/packages/firebase_auth  
Note: We plan to write better instructions here for configuring Firebase/Google-Sign-In

- Download/copy all files from the `lib` directory on this repository and replace on your local project.


and finally use the following command to run the application on your device/emulator

```
flutter run
```

Done! Questions and anything else. Email at `info@kondasoft.com`
