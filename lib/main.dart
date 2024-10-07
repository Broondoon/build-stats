import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Styling Demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        // body: const MyCustomForm(),
      ),
    );
  }
}

/* IDEA for Data Input Sync with Local Storage
   Implement one of the following:
   Sync occurs when click/tap outside of field
     (basically, when no longer interacting)
   Sync occurs set time after no changes
     (may be kinda hard to do)
*/

/* Text Editing Controller!
https://api.flutter.dev/flutter/widgets/TextEditingController-class.html
*/