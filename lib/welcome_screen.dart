import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.orange,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink.shade200, // Lighter red
              Colors.yellow.shade200, // Lighter yellow
              Colors.orange.shade200, // Lighter orange
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                    child: Image.asset('images/Fire.png', height: 200.0)),
                const SizedBox(height: 20.0),
                const Text(
                  'Fire Chat',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pacifico',
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Satisfy'
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FlickerAnimatedText(
                          'Set Ablaze Your Chats ',
                          textStyle: TextStyle(color: Colors.red.shade900), // Red color for this flicker
                        ),
                        FlickerAnimatedText(
                          'Feel the Heat of Connection ',
                          textStyle: const TextStyle(color: Colors.black), // Orange color for this flicker
                        ),
                        FlickerAnimatedText(

                          'Sizzle in Style, Fire Up Your Talks',
                          textStyle: const TextStyle(color: Colors.deepPurple),
                        ),
                        FlickerAnimatedText(
                          'Where Conversations Catch Fire ',
                          textStyle: const TextStyle(color: Colors.blue), // Blue color for this flicker
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue, // Change the button color to blue
                      side: const BorderSide(color: Colors.blue, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
